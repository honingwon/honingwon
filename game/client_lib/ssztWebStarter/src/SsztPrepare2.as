/**
 *  加载顺序：
 */
package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import sszt.cache.CacheManager;
	import sszt.events.LoaderEvent;
	import sszt.interfaces.decode.IDecode;
	import sszt.interfaces.loader.ICacheApi;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.loader.ILoaderApi;
	import sszt.interfaces.moviewrapper.IMovieManager;

	public class SsztPrepare2
	{
		private var _parentsp:Sprite;
		
		private var _user:String;
		private var _sign:String;
		private var _site:String;
		private var _serverid:int;
		private var _tick:String;
		private var _fcm:String;
		
		private var _pf:String;
		private var _pfKey:String;
		private var _openKey:String;
		private var _zoneId:int;
		private var _domain:String;
		
		private var _guest:Boolean;
		private var _is_yellow_vip:int;
		private var _is_yellow_year_vip:int;
		private var _yellow_vip_level:int;
		private var _is_yellow_high_vip:int;
		
		private var _isVisitor:Boolean;
		private var _userId:Number;
		private var _configData:XML;
		private var _commonConfigData:XML;
		private var _filterWordData:Array;
		private var _useCache:Boolean;
		private var _sitePath:String;
		private var _clientPath:String;
		private var _requestPath:String;
		private var _decoder:IDecode;
		private var _cache:ICacheApi;
		private var _loading:MovieClip;
		private var _allRegisterComplete:Boolean;
		private var _mainLoadComplete:Boolean;
		private var _loaderApi:ILoaderApi;
		private var _movieWrapperApi:IMovieManager;
		private var _createPlug:Sprite;
		private var _choisePlug:Sprite;
		private var _nick:String;
		private var _ssztgame:Sprite;
		private var _completeHandler:Function;
		private var _isFirstLogin:Boolean;
		
		
		private var _loginIp:String;
		private var _loginPort:int;
		
		//Bgp 网关IP
		private var _backIp:String;
		private var _backPort:int;
		
		private var _backIp2:String;
		private var _backPort2:int;
		private var _registerTmpPath:String;
		
		private var _gameIp:String;
		private var _gamePort:int;
		
		private var _type:int = 0;
		private var _alert:RoleAlert;
		
		private var _plat:int = 0;
		private var _key:int = 0;
		
		
		//zhurl Add 4.25
		private var _cur:int = 0;
		
		public function SsztPrepare2(user:String,site:String,serverid:int,tick:String,sign:String,fcm:String,
									 pf:String, pfKey:String, openKey:String, zoneId:int,domain:String,
									 loginIp:String,loginPort:int,guest:String,
									 is_yellow_vip:int,is_yellow_year_vip:int,yellow_vip_level:int,is_yellow_high_vip:int,complateHandler:Function = null)
		{
			_user = user;
			_site = site;
			_serverid = serverid;
			_tick = tick;
			_sign = sign;
			_fcm = fcm;
			_pf = pf;
			_pfKey = pfKey;
			_openKey = openKey;
			_zoneId = zoneId;
			_domain = domain;
			
			_guest = guest == "1";
			
			_is_yellow_vip = is_yellow_vip;
			_is_yellow_year_vip = is_yellow_year_vip;
			_yellow_vip_level = yellow_vip_level;
			_is_yellow_high_vip = is_yellow_high_vip;
			
			_completeHandler = complateHandler;
			if(_user == "")_isVisitor = true;
			else _isVisitor = false;
			_loginIp = loginIp;
			_loginPort = loginPort;
			_type = 1;
			_alert = new RoleAlert();
			_decoder = new Decode();
		}
		
		public function setup(sp:Sprite):void
		{
			_parentsp = sp;
			
			//加清除缓存的功能
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			_parentsp.contextMenu = cm;
			var item:ContextMenuItem = new ContextMenuItem("清除缓存");
			cm.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,clearCacheHandler);
			
			loadConfig();
		}
		
		private function clearCacheHandler(evt:ContextMenuEvent):void
		{
			if(_cache)
			{
				_cache.clearCache();
			}
		}
		
		/**
		 * 加载配置
		 * 
		 */		
		private function loadConfig():void
		{
			var configLoader:URLLoader = new URLLoader();
			configLoader.dataFormat = URLLoaderDataFormat.TEXT;
			configLoader.addEventListener(Event.COMPLETE,configCompleteHandler);
			configLoader.load(new URLRequest(addRandom("config.xml")));
			var commonConfigLoader:URLLoader = new URLLoader();
			commonConfigLoader.dataFormat = URLLoaderDataFormat.TEXT;
			commonConfigLoader.addEventListener(Event.COMPLETE,commonConfigCompleteHandler);
			commonConfigLoader.load(new URLRequest(addRandom("commonconfig.xml")));
		}
		/**
		 * 配置加载完成,加载解密程序
		 * @param evt
		 * 
		 */		
		private function configCompleteHandler(evt:Event):void
		{
			var configloader:URLLoader = evt.currentTarget as URLLoader;
			configloader.removeEventListener(Event.COMPLETE,configCompleteHandler);
//			_parentsp["backgroundColor"] = 16777215;
			
			_configData = XML(configloader.data);
			checkAllConfigComplete();
		}
		private function commonConfigCompleteHandler(evt:Event):void
		{
			var commonconfigLoader:URLLoader = evt.currentTarget as URLLoader;
			commonconfigLoader.removeEventListener(Event.COMPLETE,configCompleteHandler);
			_commonConfigData = XML(commonconfigLoader.data);
			checkAllConfigComplete();
		}
		private function checkAllConfigComplete():void
		{
			if(!_configData || !_commonConfigData)return;
			
			var list:XMLList = _configData.config.POLICY_FILES.file;
			for each(var f:XML in list)
			{
				Security.loadPolicyFile(f.@value);
			}
			_useCache = String(_commonConfigData.config.CACHELOCAL.@value) == "true";
			_sitePath = String(_configData.config.SITE.@value);
			_clientPath = String(_configData.config.SITE_CLIENT.@value);
			_requestPath = String(_configData.config.WEBSERVICE_PATH.@value);
			_registerTmpPath = String(_configData.config.REGISTERTMP_PATH.@value);
			_backIp = String(_configData.config.backupIp.@value);
			_backPort = int(_configData.config.backupPort.@value);
			_backIp2 = String(_configData.config.backupIp2.@value);
			_backPort2 = int(_configData.config.backupPort2.@value);
			_plat = int(_configData.config.PLAT.@value);
			SocketProxy.setup(_plat,_loginIp,_loginPort,_user,_site,_serverid,_tick,_sign,_fcm,_guest,_is_yellow_vip,_is_yellow_year_vip,_yellow_vip_level,_is_yellow_high_vip,_alert,_parentsp,String(_configData.config.OFFICAL_PATH.@value),null,_backIp,_backPort);
			
			cachebytesComplete(null);
			
		}

		/**
		 * 缓存域添加完成
		 * @param evt
		 * 
		 */		
		private function cachebytesComplete(evt:Event):void
		{
			CacheManager;
			var ccl:Class = ApplicationDomain.currentDomain.getDefinition("sszt.cache.CacheManager") as Class;
			_cache = new ccl((_commonConfigData.update)[0]..version,_commonConfigData.config.DEBUGING.@nv,_commonConfigData.config.DEBUGING.@cv,_sitePath,_clientPath) as ICacheApi;
			
			
			getCacheData(_sitePath + "img/loading/loading.swf",loadingCacheBack);
			function loadingCacheBack(bytes:ByteArray):void
			{
				if(bytes != null)
				{
					var loadingBytesLoader:Loader = new Loader();
					loadingBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadingByteComplate);
					loadingBytesLoader.loadBytes(bytes,new LoaderContext(false,ApplicationDomain.currentDomain));
				}
				else
				{
					var loadingLoader:URLLoader = new URLLoader();
					loadingLoader.dataFormat = URLLoaderDataFormat.BINARY;
					loadingLoader.addEventListener(Event.COMPLETE,loadingLoaderComplete);
					loadingLoader.load(new URLRequest(addRandom(_sitePath + "img/loading/loading.swf")));
				}
			}
		}
		
		private function loadingLoaderComplete(evt:Event):void
		{
			var loadingloader:URLLoader = evt.currentTarget as URLLoader;
			loadingloader.removeEventListener(Event.COMPLETE,loadingLoaderComplete);
			var bytes:ByteArray = loadingloader.data as ByteArray;
			if(_useCache)_cache.setFile(_sitePath + "img/loading/loading.swf",bytes);
			
			var loadingBytesLoader:Loader = new Loader();
			loadingBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadingByteComplate);
			loadingBytesLoader.loadBytes(bytes,new LoaderContext(false,ApplicationDomain.currentDomain));
		}
		
		private function loadingByteComplate(evt:Event):void
		{
			var lcl:Class = ApplicationDomain.currentDomain.getDefinition("ssztui.loading.LoadingAsset") as Class;
			_loading = new lcl() as MovieClip;
			_parentsp.stage.addEventListener(Event.RESIZE,stageResizeHandler);
			_parentsp.addChildAt(_loading,0);
			setProgress(3);		
			loadLoaderLib();
			stageResizeHandler(null);
		}
		
		private function stageResizeHandler(evt:Event):void
		{
			var vx:int;
			if(_loading)
			{
				vx = _parentsp.stage.stageWidth - _loading.width >> 1;
				_loading.x = vx >0 ? vx:0;
			}
			if(_createPlug)
			{
				vx = _parentsp.stage.stageWidth - 1200 >> 1;
				_createPlug.x = vx >0 ? vx:0;
			}
			
		}
		
		
		/**
		 * 加载包加载
		 * 
		 */		
		private function loadLoaderLib():void
		{
			getCacheData(_clientPath + "client/Cookieadministratorwww.163.com[1].txt",loaderLibBack);
			
			function loaderLibBack(bytes:ByteArray):void
			{
				if(bytes != null)
				{
					var loaderLibByteLoader:Loader = new Loader();
					loaderLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderLibByteComplete);
					loaderLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
				}
				else
				{
					var loaderLibLoader:URLLoader = new URLLoader();
					loaderLibLoader.dataFormat = URLLoaderDataFormat.BINARY;
					loaderLibLoader.addEventListener(Event.COMPLETE,loaderLibComplete);
					loaderLibLoader.load(new URLRequest(addRandom(_clientPath + "client/Cookieadministratorwww.163.com[1].txt")));
				}
			}
			
		}
		
		/**
		 * 加载包加载完成，添加域 
		 * @param evt
		 * 
		 */		
		private function loaderLibComplete(evt:Event):void
		{
			var loaderLibLoader:URLLoader = evt.currentTarget as URLLoader;
			loaderLibLoader.removeEventListener(Event.COMPLETE,loaderLibComplete);
			var bytes:ByteArray = loaderLibLoader.data as ByteArray;
			
			if(_useCache)_cache.setFile(_clientPath + "client/Cookieadministratorwww.163.com[1].txt",bytes);
			
			var loaderLibByteLoader:Loader = new Loader();
			loaderLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderLibByteComplete);
			loaderLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
			
		}
		
		
		/**
		 * 加载包加载完成
		 * @param evt
		 * 
		 */		
		private function loaderLibByteComplete(evt:Event):void
		{
			
			var cl:Class = ApplicationDomain.currentDomain.getDefinition("sszt.loader.LoaderManager") as Class;
			_loaderApi = new cl() as ILoaderApi;
			_loaderApi.setup(ApplicationDomain.currentDomain,_decoder,_useCache ? _cache : null);
			setProgress(4);
			loadFilterWords();
		}
		
		
		/**
		 * 加载过滤词
		 * 
		 */		
		private function loadFilterWords():void
		{
			var filterwordloader:ILoader = _loaderApi.createRequestLoader(_requestPath + "FilterContentList.txt",null,filterWrodLoadComplete,true);
			filterwordloader.loadSync();
			function filterWrodLoadComplete(loader:ILoader):void
			{
				setProgress(5);
				var data:ByteArray = loader.getData() as ByteArray;
				data.position = 0;
				data.readByte(); //版本
				data.readByte();
				data.readByte();
				_filterWordData = [];
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					_filterWordData.push(data.readUTF());
				}
				loader.dispose();
				loadRoles();
			}
		}
		
		
		
		/**
		 * 加载main前需要加载 
		 * 
		 */		
		private function perLoadMain():void
		{
			loadBasicLib();
		}
		
		
		/**
		 * basic加载
		 * 
		 */		
		private function loadBasicLib():void
		{
			getCacheData(_clientPath + "client/Cookieadministratorwww.163.com[2].txt",loaderBasicBack);
			
			function loaderBasicBack(bytes:ByteArray):void
			{
				if(bytes != null)
				{
					var loaderBasicByteLoader:Loader = new Loader();
					loaderBasicByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderBasicByteComplete);
					loaderBasicByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
				}
				else
				{
					var loaderBasicLoader:URLLoader = new URLLoader();
					loaderBasicLoader.dataFormat = URLLoaderDataFormat.BINARY;
					loaderBasicLoader.addEventListener(Event.COMPLETE,loaderrBasicComplete);
					loaderBasicLoader.load(new URLRequest(addRandom(_clientPath + "client/Cookieadministratorwww.163.com[2].txt")));
				}
			}
			
		}
		
		/**
		 * basic加载完成，添加域 
		 * @param evt
		 * 
		 */		
		private function loaderrBasicComplete(evt:Event):void
		{
			var loaderBasicLoader:URLLoader = evt.currentTarget as URLLoader;
			loaderBasicLoader.removeEventListener(Event.COMPLETE,loaderrBasicComplete);
			var bytes:ByteArray = loaderBasicLoader.data as ByteArray;
			
			if(_useCache)_cache.setFile(_sitePath + "client/Cookieadministratorwww.163.com[2].txt",bytes);
			
			var loaderBasicByteLoader:Loader = new Loader();
			loaderBasicByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderBasicByteComplete);
			loaderBasicByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
			
		}
		
		/**
		 * 加载包加载完成
		 * @param evt
		 * 
		 */		
		private function loaderBasicByteComplete(evt:Event):void
		{
			var cl:Class = ApplicationDomain.currentDomain.getDefinition("sszt.events.SocketEvent") as Class;
			setProgress1(9,19,true);
			loadUILib();
		}
		
		/**
		 * 加载uilib
		 * 
		 */		
		private function loadUILib():void
		{
			getCacheData(_clientPath + "client/Cookieadministratorwww.163.com[3].txt",uiLibBack);
			
			function uiLibBack(bytes:ByteArray):void
			{
				if(bytes != null)
				{
					var uiLibByteLoader:Loader = new Loader();
					uiLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,uiLibByteComplete);
					uiLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
				}
				else
				{
					var uiLibLoader:URLLoader = new URLLoader();
					uiLibLoader.dataFormat = URLLoaderDataFormat.BINARY;
					uiLibLoader.addEventListener(Event.COMPLETE,uiLibComplete);
					uiLibLoader.load(new URLRequest(addRandom(_clientPath + "client/Cookieadministratorwww.163.com[3].txt")));
				}
			}
		}
		
		/**
		 * uilib加载完成，添加域 
		 * @param evt
		 * 
		 */		
		private function uiLibComplete(evt:Event):void
		{
			var uiLibLoader:URLLoader = evt.currentTarget as URLLoader;
			uiLibLoader.removeEventListener(Event.COMPLETE,uiLibComplete);
			var bytes:ByteArray = uiLibLoader.data as ByteArray;
			
			if(_useCache)_cache.setFile(_sitePath + "client/Cookieadministratorwww.163.com[3].txt",bytes);
			
			var uiLibByteLoader:Loader = new Loader();
			uiLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,uiLibByteComplete);
			uiLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
			
		}
		
		private function uiLibByteComplete(evt:Event):void
		{
			setProgress1(19,30,true);
			loadCore();
		}
		
		
		/**
		 * core加载
		 * 
		 */		
		private function loadCore():void
		{
			getCacheData(_clientPath + "client/Cookieadministratorwww.163.com[4].txt",loaderCoreBack);
			
			function loaderCoreBack(bytes:ByteArray):void
			{
				if(bytes != null)
				{
					var loaderCoreByteLoader:Loader = new Loader();
					loaderCoreByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderCoreByteComplete);
					loaderCoreByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
				}
				else
				{
					var loaderCoreLoader:URLLoader = new URLLoader();
					loaderCoreLoader.dataFormat = URLLoaderDataFormat.BINARY;
					loaderCoreLoader.addEventListener(Event.COMPLETE,loaderCoreComplete);
					loaderCoreLoader.load(new URLRequest(addRandom(_clientPath + "client/Cookieadministratorwww.163.com[4].txt")));
				}
			}
			
		}
		
		/**
		 * core加载完成，添加域 
		 * @param evt
		 * 
		 */		
		private function loaderCoreComplete(evt:Event):void
		{
			var loaderCoreLoader:URLLoader = evt.currentTarget as URLLoader;
			loaderCoreLoader.removeEventListener(Event.COMPLETE,loaderCoreComplete);
			var bytes:ByteArray = loaderCoreLoader.data as ByteArray;
			
			if(_useCache)_cache.setFile(_sitePath + "client/Cookieadministratorwww.163.com[4].txt",bytes);
			
			var loaderCoreByteLoader:Loader = new Loader();
			loaderCoreByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderCoreByteComplete);
			loaderCoreByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
			
		}
		
		/**
		 * core加载完成
		 * @param evt
		 * 
		 */		
		private function loaderCoreByteComplete(evt:Event):void
		{
			setProgress1(30,0,false);
			loadUtil();
		}
		
		
		
		/**
		 *　加载工具包 
		 * 
		 */		
		private function loadUtil():void
		{
			getCacheData(_clientPath + "client/Cookieadministratorwww.163.com[5].txt",utilBack);
			
			function utilBack(bytes:ByteArray):void
			{
				if(bytes != null)
				{
					var utilLibByteLoader:Loader = new Loader();
					utilLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,utilLibByteComplete);
					utilLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
				}
				else
				{
					var utilLibLoader:URLLoader = new URLLoader();
					utilLibLoader.dataFormat = URLLoaderDataFormat.BINARY;
					utilLibLoader.addEventListener(Event.COMPLETE,utilLibComplete);
					utilLibLoader.load(new URLRequest(addRandom(_clientPath + "client/Cookieadministratorwww.163.com[5].txt")));
				}
			}
		}
		/**
		 * 工具包加载完成，添加域 
		 * @param evt
		 * 
		 */		
		private function utilLibComplete(evt:Event):void
		{
			var loaderLibLoader:URLLoader = evt.currentTarget as URLLoader;
			loaderLibLoader.removeEventListener(Event.COMPLETE,utilLibComplete);
			var bytes:ByteArray = loaderLibLoader.data as ByteArray;
			
			if(_useCache)_cache.setFile(_clientPath + "client/Cookieadministratorwww.163.com[5].txt",bytes);
			
			var loaderLibByteLoader:Loader = new Loader();
			loaderLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,utilLibByteComplete);
			loaderLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
			
		}
		
		/**
		 * 工具包 加载完成 
		 * @param evt
		 * 
		 */		
		private function utilLibByteComplete(evt:Event):void
		{
			var mcl:Class = ApplicationDomain.currentDomain.getDefinition("sszt.moviewrapper.MovieManager") as Class;
			_movieWrapperApi = new mcl() as IMovieManager;
			_movieWrapperApi.setup(40);
			
			setProgress(31);
			
			loadCharacterLib();
		}
		
		/**
		 * 加载模型包  
		 * 
		 */		
		private function loadCharacterLib():void
		{
			getCacheData(_clientPath + "client/Cookieadministratorwww.163.com[6].txt",characterLibBack);
			
			function characterLibBack(bytes:ByteArray):void
			{
				if(bytes != null)
				{
					var characterLibByteLoader:Loader = new Loader();
					characterLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,characterLibByteComplete);
					characterLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
				}
				else
				{
					var characterLibLoader:URLLoader = new URLLoader();
					characterLibLoader.dataFormat = URLLoaderDataFormat.BINARY;
					characterLibLoader.addEventListener(Event.COMPLETE,characterLibComplete);
					characterLibLoader.load(new URLRequest(addRandom(_clientPath + "client/Cookieadministratorwww.163.com[6].txt")));
				}
			}
		}
		
		/**
		 * 模型包加载完成，添加域 
		 * @param evt
		 * 
		 */		
		private function characterLibComplete(evt:Event):void
		{
			var characterLibLoader:URLLoader = evt.currentTarget as URLLoader;
			characterLibLoader.removeEventListener(Event.COMPLETE,characterLibComplete);
			var bytes:ByteArray = characterLibLoader.data as ByteArray;
			
			if(_useCache)_cache.setFile(_sitePath + "client/Cookieadministratorwww.163.com[6].txt",bytes);
			
			var characterLibByteLoader:Loader = new Loader();
			characterLibByteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,characterLibByteComplete);
			characterLibByteLoader.loadBytes(_decoder.decode(bytes,_type),new LoaderContext(false,ApplicationDomain.currentDomain));
			
		}
		
		private function characterLibByteComplete(evt:Event):void
		{
			setProgress(32);
			loadMain();
		}
		
		
		
	
		/**
		 * 加载角色列表
		 * 
		 */		
		private function loadRoles():void
		{
			SocketProxy.getRoleData(getRolesBack);
			
		}
		
		private function getRolesBack(data:ByteArray,useBgp:Boolean):void
		{
			var isloadMain:Boolean = false;
			var len:int = data.readShort();
			if(len == 0)
			{
				_allRegisterComplete = false;
				_isFirstLogin = true;
				loadCreateRole();
			}
			else if(len == 1)
			{
				_allRegisterComplete = true;
				_isFirstLogin = false;
				data.readShort();
				var t:Number = data.readShort();
				_userId = (t << 24) * 256 + data.readUnsignedInt();
				data.readBoolean();
				data.readInt();
				_user = data.readUTF();
				_nick = data.readUTF();
//				data.readShort();
//				data.readByte();
				isloadMain = true;
			}
			else
			{
				_allRegisterComplete = false;
				_isFirstLogin = false;
				var players:Array = [];
				for(var i:int = 0; i < len; i++)
				{
					var player:Object = {};
					data.readShort();
					var tt:Number = data.readShort();
					player["id"] = (tt << 24) * 256 + data.readUnsignedInt();
					player["sex"] = data.readBoolean();
					player["level"] = data.readInt();
					player["userName"] = data.readUTF();
					player["nickName"] = data.readUTF();
					player["serverIndex"] = data.readShort();
					player["career"] = data.readByte();
					players.push(player);
				}
			}
			_gameIp = data.readUTF();
			_gamePort = data.readShort();
			if(useBgp)
			{
				_gameIp = _backIp2;
				_gamePort = _backPort2;
			}
			if(isloadMain)
				perLoadMain();
		}
		
		/**
		 * 加载main前需要加载 
		 * 
		 */		
		private function loadMain():void
		{
			if(_completeHandler != null)
			{
				_completeHandler(createPresetupParam());
				return;
			}
			var mainLoader:ILoader = _loaderApi.createSwfLoader(_clientPath + "client/Cookieadministratorwww.163.com[0].txt",mainLoadComplete,3,_type);
			mainLoader.addEventListener(LoaderEvent.LOAD_PROGRESS,loadProgressHandler);
			mainLoader.loadSync();
			function mainLoadComplete(loader:ILoader):void
			{
				_mainLoadComplete = true;
				createSSZTGGame();
				checkIn();
				loader.removeEventListener(LoaderEvent.LOAD_PROGRESS,loadProgressHandler);
				loader.dispose();
			}
			function loadProgressHandler(evt:LoaderEvent):void
			{
				var n:Number = (evt.bytesLoaded / evt.bytesTotal) * 18;
				setProgress(32 + int(n));
			}
			
		}
		
		private function loadCreateRole():void
		{

			_isFirstLogin = true;
			/**
			 * 正式
			 * */
			var createRoleLoader:ILoader = _loaderApi.createSwfLoader(_clientPath + "client/Cookieadministratorwww.163.com[9].txt",createRoleComplete,3,_type);
			createRoleLoader.addEventListener(LoaderEvent.LOAD_PROGRESS,loadProgressHandler);
			createRoleLoader.loadSync();
			function createRoleComplete(loader:ILoader):void
			{
				//进入创建角色界面，等待回调
				var cl:Class = _loaderApi.getClassByPath("RoleCreateView") as Class;
				var param:Object = {callback:createRolesComplete,filterword:_filterWordData,alert:_alert,
					config:_configData,commoncomfing:_commonConfigData,loader:_loaderApi,user:_user,sitePath:_sitePath,clientPath:_clientPath,requirePath:_requestPath,
					tick:_tick,site:_site,serverid:_serverid,sign:_sign,cm:_fcm, 
					pf:_pf ,pfKey:_pfKey,openKey:_openKey ,zoneId:_zoneId,domain:_domain,
					createFunc:SocketProxy.createRole};
				_createPlug = new cl(param) as Sprite;
				stageResizeHandler(null);
				_parentsp.addChild(_createPlug);
				loader.dispose();
				perLoadMain();
			}
			function loadProgressHandler(evt:LoaderEvent):void
			{
				var n:Number = (evt.bytesLoaded / evt.bytesTotal) * 3;
				setProgress(5 + int(n));
			}
		}
		
		/**
		 * 注册成功回调
		 * @param nick
		 * 
		 */		
		private function createRolesComplete(nick:String,id:Number):void
		{
			_allRegisterComplete = true;
			_nick = nick;
			_userId = id;
			_createPlug["dispose"]();
			_createPlug = null;
			//正式进入
			checkIn();
		}
		

		
		private function checkIn():void
		{
			if(!_allRegisterComplete || !_mainLoadComplete)return;
			SocketProxy.close();
			createSSZTGGame();
			_parentsp.addChild(_ssztgame);
			_ssztgame["setup"]();
		}
		
		private function createSSZTGGame():void
		{
			if(_ssztgame == null)
			{
				var SSZTGCl:Class = ApplicationDomain.currentDomain.getDefinition("ssztGame") as Class;
				_ssztgame = new SSZTGCl() as Sprite;
				_ssztgame["preSetup"](createPresetupParam());
			}
			else
			{
				_ssztgame["setUserId"]({userId:_userId});
			}
		}
		
		private function createPresetupParam():Object
		{
			var param:Object = {userId:_userId,user:_user,pass:"",sign:_sign,site:_site,serverid:_serverid,tick:_tick,fcm:_fcm,
				pf:_pf ,pfKey:_pfKey,openKey:_openKey ,zoneId:_zoneId,domain:_domain,
				guest:_guest,
				config:_configData,commonconfig:_commonConfigData,filterWord:_filterWordData,useCache:_useCache,
				sitePath:_sitePath,clientPath:_clientPath,requestPath:_requestPath,decode:_decoder,
				cache:_cache,addProgress:addProgress,loaderApi:_loaderApi,
				movieManager:_movieWrapperApi,nick:_nick,parentDispose:dispose,
				isFirstLogin:_isFirstLogin,stage:_parentsp.stage,gameIp:_gameIp,gamePort:_gamePort,
				isYellowVip:_is_yellow_vip,isYellowYearVip:_is_yellow_year_vip,yellowVipLevel:_yellow_vip_level,isYellowHighVip:_is_yellow_high_vip};
			return param;
		}
		
		private function getCacheData(path:String,callback:Function):void
		{
			if(!_useCache)
			{
				callback(null);
				return;
			}
			_cache.getFile(path,cacheCallback);
			function cacheCallback(bytes:ByteArray):void
			{
				if(bytes == null)
					callback(null);
				else 
					callback(bytes);
			}
		}
		
		
		private var _hadSetProgress:Boolean;
		private function setProgress(n:int):void
		{
			_loading["progress_bar"].gotoAndStop(n);
			_loading["progress_txt"].text = "资源加载中... " + String(n) + "%";
			_cur = n;
		}
		
		private var _bar1Time:Timer;
		private var _max:int ;
		private function setProgress1(n:int,max:int,setTime:Boolean,set:Boolean=true):void
		{
			if(_bar1Time == null)
			{
				_bar1Time = new Timer(int(Math.random() * 1000),1);
				_bar1Time.addEventListener(TimerEvent.TIMER,timerHandler);
			}
			if(set)
			{
				setProgress(n);
			}
			_max = max;
			if(!setTime)
			{
				_bar1Time.stop();
			}
			else
			{
				_bar1Time.reset();
				_bar1Time.start();
			}
			
			function timerHandler(evt:TimerEvent):void
			{
				addProgress(1);
				if(_cur >= _max && _bar1Time) _bar1Time.stop();
			}
		}
		
		
//		private function setProgress1(n:int,setTime:Boolean):void
//		{
//			if(_bar1Time == null)
//			{
//				_bar1Time = new Timer(int(Math.random() * 1000),1);
//				_bar1Time.addEventListener(TimerEvent.TIMER,timerHandler);
//			}
//			
//			if(!setTime)
//			{
//				_loading["progress_bar"].gotoAndStop(n > 95 ? 95 : n);
//				_bar1Time.stop();
//			}
//			else
//			{
//				_loading["progress_bar"].gotoAndStop(int(Math.random() * 40) + 5);
//				_bar1Time.reset();
//				_bar1Time.start();
//			}
//			function timerHandler(evt:TimerEvent):void
//			{
//				_loading["progress_bar"].gotoAndStop(int(Math.random() * 40) + 50);
//			}
//		}
		
		private function addProgress(index:int = 1):void
		{
			var currentFrame:int = _cur; 
			setProgress(currentFrame + index);
		}
		
//		private var _bar2Time:Timer;
//		private var _index:int;
//		private var _num:int;
//		private function addProgress1(num:int,setTime:Boolean):void
//		{
//			if(_bar2Time == null)
//			{
//				_bar2Time = new Timer(int(Math.random() * 1000),1);
//				_bar2Time.addEventListener(TimerEvent.TIMER,timerHandler);
//			}
//			
//			_index = 0;
//			_num = num;
//			if(!setTime)
//			{
//				_bar2Time.stop();
//			}
//			else
//			{
//				_bar2Time.reset();
//				_bar2Time.start();
//			}
//			
//			function timerHandler(evt:TimerEvent):void
//			{
//				addProgress(1);
//				_index++;
//				if(_index >= _num && _bar2Time) _bar2Time.stop();
//			}
//		}
		
		
		
		private function addRandom(path:String):String
		{
			if(path.indexOf("?") == -1)
			{
				return path + "?" + Math.random();
			}
			else
			{
				
				return path + "&rnd=" + Math.random();
			}
			return path;
		}
		
		public function dispose():void
		{
			if(_parentsp)
			{
				_parentsp.stage.removeEventListener(Event.RESIZE,stageResizeHandler);
				_parentsp = null;
			}
			_decoder = null;
			_cache = null;
			if(_loading && _loading.parent)
			{
				_loading.parent.removeChild(_loading);
			}
			_loaderApi = null;
			_movieWrapperApi = null;
			if(_createPlug)
			{
				try
				{
					_createPlug["dispose"]();
				}
				catch(e:Error){}
				_createPlug = null;
			}
			if(_choisePlug)
			{
				try
				{
					_choisePlug["dispose"]();
				}
				catch(e:Error){}
				_choisePlug = null;
			}
			_ssztgame = null;
			_completeHandler = null;
		}
	}
}


import flash.utils.ByteArray;

import sszt.interfaces.decode.IDecode;

class Decode implements IDecode
{
	private var _codes1:Array = [22,10,1,11,12,12,13,1,4,15,16,1,7,18,1,2,33,4,5,6,7,8,19,20,2,1,3,23,23,25,26,27];
	private var _codes2:Array = [27,28,29,21,5,31,32,34,0,41,42,4,44,4,46,47,48,49,2,34,35,67,36,38,6,50,51,52];
	private var _codes3:Array = [52,53,54,62,5,64,69,7,71,72,73,74,55,56,45,58,59,50,65,66,4,68,6,0,61,75,76];
	
	public function Decode()
	{
	}
	
	public function decode(data:ByteArray,type:int):ByteArray
	{
		if(type ==0)
			return data;
		var t:ByteArray = new ByteArray();
		data.position = 0;
		data.readBytes(t);
		var codes:Array = _codes2.concat(_codes3,_codes1);
		for(var i:int = 0,j:int = 0; i < codes.length; i++,j+=4)
		{
			t[j] = t[j] ^ codes[i];
		}
		return t;
	}
}
