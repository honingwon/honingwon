package sszt.cache
{
	import flash.utils.Timer;
	import flash.net.SharedObject;
	import flash.events.TimerEvent;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;
	import flash.events.NetStatusEvent;
	import sszt.interfaces.loader.*;
	
	public class CacheManager implements ICacheApi 
	{
		
		private const NEEDSPACE:int = 31457280;
		private const _totalTryTime:int = 2;
		
		private var _saveTimer:Timer;
		private var _fileList:Array;
		private var _saveList:Array;
		private var _noTip:Boolean;
		private var _tryTime:int;
		private var _sharedObject:SharedObject;
		private var _sitePath:String;
		private var _clientPath:String;
		private var _canCache:Boolean;
		private var _currentVersion:int;
		private var _version:int;
		private var _preVersion:int;
		
		public function CacheManager(data:XMLList,version:int,preVersion:int, sitePath:String, clientPath:String)
		{
			_saveTimer = new Timer(500);
			_saveTimer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			_sitePath = sitePath;
			_clientPath = clientPath;
			_version = version;
			_preVersion = preVersion;
			_tryTime = 0;
			_canCache = false;
			_noTip = false;
			getCacheList();
			checkVersion();
			updateFiles(data);
			_saveList = [];
		}
		public function saveCacheList():Boolean
		{
			var state:String;
			if (!(_canCache)){
				return (false);
			};
			try {
				state = _sharedObject.flush(NEEDSPACE);
				if (state != SharedObjectFlushStatus.PENDING){
					_sharedObject.data["fileList"] = _fileList;
					_sharedObject.data["version"] = _currentVersion;
					_saveTimer.start();
					return (true);
				}
			} 
			catch(e:Error) {
				Security.showSettings(SecurityPanel.LOCAL_STORAGE);
			}
			return (false);
		}
		private function onTimerHandler(evt:TimerEvent):void
		{
			var o:Object;
			var path:String;
			var so:SharedObject;
			var evt:TimerEvent = evt;
			if (!(_canCache)){
				return;
			};
			if (_saveList.length > 0){
				try {
					o = _saveList.splice(0, 1)[0];
					path = o["path"];
					so = SharedObject.getLocal(path);
					so.data[path] = o["data"];
					so.data[(path + "s")] = o["len"];
					so.data[(path + "c")] = o["checkDatas"];
					if (o["callback"] != null){
						(o["callback"]());
					}
					o = null;
					addToFileList(path);
					_sharedObject.data["fileList"] = _fileList;
					_sharedObject.data["version"] = _currentVersion;
				} 
				catch(e:Error) {
					trace(e);
				}
			}
		}
		public function setFile(path:String, data:ByteArray, backup:Boolean=true, callback:Function=null):void
		{
			var checkDatas:Array;
			var i:int;
			var l:int;
			var t:ByteArray;
			if (_noTip || _fileList == null || _sharedObject == null)
			{
				return;
			}
			path = getPathWithoutSite(path);
			try {
				checkDatas = new Array(50);
				if (data.length > 50){
					i = 0;
					l = (data.length - 25);
					i = 0;
					while (i < 25) {
						checkDatas[i] = data[i];
						checkDatas[(i + 25)] = data[l];
						i = (i + 1);
						l = (l + 1);
					}
				}
				if (backup){
					t = new ByteArray();
					data.position = 0;
					data.readBytes(t, 0, data.length);
					_saveList.push({
						path:path,
						data:t,
						callback:callback,
						len:data.length,
						checkDatas:checkDatas
					})
				} 
				else {
					_saveList.push({
						path:path,
						data:data,
						callback:callback,
						len:data.length,
						checkDatas:checkDatas
					})
				}
			} 
			catch(e:Error) {
				trace(e.message);
			}
		}
		public function getCanCache():Boolean
		{
			return (_canCache);
		}
		private function getCacheList():void
		{
			var t:Array;
			try {
				_sharedObject = SharedObject.getLocal("sszt/ssztCache");
				_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				t = _sharedObject.data["fileList"];
				if (t == null){
					_fileList = [];
					_currentVersion = -1;
					_canCache = false;
				} 
				else {
					_fileList = t;
					_currentVersion = int(_sharedObject.data["version"]);
					_canCache = true;
					_saveTimer.start();
				}
			}
			catch(e:Error) {
				trace(e.message);
			}
		}
		
		private function checkVersion():void
		{
			if(_currentVersion != _preVersion && _currentVersion != _version)
			{
				_fileList = [];
				_currentVersion = _version;
			}
		}
		private function deleteFiles(path:String, fileType:String="", updateChild:Boolean=false):void
		{
			var names:Array;
			var i:int = (_fileList.length - 1);
			while (i >= 0) {
				if (fileType == ""){
					if (updateChild){
						if (_fileList[i].indexOf(path) != -1){
							_fileList.splice(i, 1);
						};
					} else {
						if (_fileList[i] == path){
							_fileList.splice(i, 1);
						};
					};
				} else {
					if (checkSamePath(_fileList[i], path, updateChild)){
						names = _fileList[i].split(".");
						if (names[(names.length - 1)] == fileType){
							_fileList.splice(i, 1);
						};
					};
				};
				i--;
			};
		}
		private function deleteFileLists(path:String, files:Array, updateChild:Boolean=false):void
		{
			var i:int;
			if (path == ""){
				return;
			}
			if (files.indexOf("*") > -1){
				deleteFiles(path, "", updateChild);
			} else {
				i = 0;
				while (i < files.length) {
					if (files[i] != ""){
						if (files[i].slice(0, 2) == "*."){
							deleteFiles(path, files[i].slice(2), updateChild);
						} else {
							deleteFiles((path + files[i]), "", updateChild);
						}
					}
					i++;
				}
			}
		}
		private function clearSaveObjects():void
		{
			_saveList.length = 0;
		}
		private function checkSamePath(filePath:String, path:String, updateChild:Boolean=false):Boolean
		{
			if (updateChild){
				return ((filePath.indexOf(path) > -1));
			}
			var t:Array = filePath.split("/");
			var s:Array = t.slice(0, (t.length - 1));
			var t1:Array = path.split("/");
			var s1:Array = t1.slice(0, (t1.length - 1));
			return ((s1.join("/") == s.join("/")));
		}
		public function setCanCache(value:Boolean):void
		{
			_canCache = value;
			if (!_canCache){
				clearSaveObjects();
				_saveTimer.stop();
				_noTip = true;
			}
		}
		private function addToFileList(path:String):void
		{
			var n:int = _fileList.indexOf(path);
			if (n == -1){
				_fileList.push(path);
			}
		}
		private function getPathWithoutSite(path:String):String
		{
			var tmpPath:String = "";
			if (path.indexOf(_sitePath) > -1){
				tmpPath = _sitePath;
			} else {
				tmpPath = _clientPath;
			}
			var t:Array = path.split(tmpPath);
			return t.length == 1 ? String(t[0]) : String(t[1]);
		}
		private function updateFiles(data:XMLList):void
		{
			var x:XML;
			var v:int;
			var list:XMLList;
			var j:int;
			var p:String;
			var fs:Array;
			var uc:Boolean;
			var lastVersion:int = -1;
			var i:int;
			while (i < data.length()) {
				x = XML(data[i]);
				v = int(x.@value);
				if (_currentVersion < v){
					lastVersion = v;
					list = XML(data[i])..path;
					j = 0;
					while (j < list.length()) {
						p = String(list[j].@value);
						fs = String(list[j].@file).split(",");
						uc = (String(list[j].@updateChild) == "true");
						deleteFileLists(p, fs, uc);
						j++;
					}
				}
				i++;
			}
			if (lastVersion != -1){
				_currentVersion = lastVersion;
			}
		}
		public function clearCache():void
		{
			if (_sharedObject){
				_fileList = [];
				_sharedObject.data["fileList"] = _fileList;
				_sharedObject.data["version"] = _currentVersion;
				try {
					_sharedObject.flush();
				} 
				catch(e:Error) {
				}
			}
		}
		public function getFile(path:String, callBack:Function, backup:Boolean=true):void
		{
			var t:ByteArray;
			var tl:int;
			var c:Array;
			var i:Object;
			var so:SharedObject;
			var isRight:Boolean;
			var l:int;
			var k:int;
			var tt:ByteArray;
			var path:String = path;
			var callBack:Function = callBack;
			var backup:Boolean = backup;
			if (_fileList == null || _sharedObject == null || !_canCache){
				callBack(null)
				return;
			}
			path = getPathWithoutSite(path);
			if (_fileList.indexOf(path) == -1){
				(callBack(null));
				return;
			}
			for each (i in _saveList) {
				if (i["path"] == path){
					t = i["data"];
					break;
				}
			}
			if (!(t)){
				try {
					so = SharedObject.getLocal(path);
					t = so.data[path];
					tl = so.data[(path + "s")];
					c = so.data[(path + "c")];
					so = null;
				} catch(e:Error) {
					trace(e.message);
				}
			}
			if (t){
				isRight = true;
				if (tl != t.length){
					trace(path);
					isRight = false;
				}
				if (isRight){
					if (((c) && ((c.length == 50)))){
						l = (t.length - 25);
						k = 0;
						while (k < 25) {
							if (((!((c[k] == t[k]))) || (!((c[(k + 25)] == t[l]))))){
								isRight = false;
								break;
							}
							k = (k + 1);
							l = (l + 1);
						}
					}
				}
				if (isRight){
					if (backup){
						tt = new ByteArray();
						t.position = 0;
						t.readBytes(tt, 0, t.length);
						(callBack(tt));
						t = null;
					} else {
						t.position = 0;
						(callBack(t));
					}
				} 
				else {
					(callBack(null));
				}
			}
			else {
				(callBack(null));
			}
		}
		private function netStatusHandler(evt:NetStatusEvent):void
		{
			_tryTime++;
			if (evt.info.code == "SharedObject.Flush.Failed"){
				if (_tryTime < _totalTryTime){
					saveCacheList();
				} else {
					_canCache = false;
					_noTip = true;
					clearSaveObjects();
					_saveTimer.stop();
				}
			} 
			else {
				_noTip = false;
				_canCache = true;
				_sharedObject.data["fileList"] = _fileList;
				_sharedObject.data["version"] = _currentVersion;
				_saveTimer.start();
			}
		}
		
	}
}