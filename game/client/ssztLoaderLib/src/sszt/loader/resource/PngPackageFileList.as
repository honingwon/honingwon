package sszt.loader.resource
{
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	import sszt.loader.PngPackageLoader;
	import sszt.loader.LoaderManager;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import sszt.interfaces.loader.ILoader;
	import flash.geom.Rectangle;
	
	public class PngPackageFileList extends BaseDataFileList 
	{
		
		private var _id:int;
		private var _layerType:String;
		private var _sex:String;
		private var _parseTimer:Timer;
		private var _picCount:int;
		private var _className:String;
		private var _currentCount:int = 0;
		private var _dataSource:ByteArray;
		private var _tmpDatas:Array;
		private var _tmpRects:Array;
		
		public function PngPackageFileList(path:String, id:int, layerType:String, playerSex:int, callback:Function, clearType:int)
		{
			this._id = id;
			this._layerType = layerType;
			this._sex = (((playerSex == 0)) ? "" : (((playerSex == 1)) ? "01" : "02"));
			super(path, callback, clearType);
		}
		override protected function initLoad():void
		{
			_loader = new PngPackageLoader(path, this._id, this._layerType, this._sex, this.loadComplete, 3);
			_loader.loadSync();
		}
		override protected function loadComplete(loader:ILoader):void
		{
			var dataCl:BitmapData = (new (LoaderManager.domain.getDefinition(((this._layerType + this._sex) + this._id)) as Class)(1, 1) as BitmapData);
			this._dataSource = dataCl["boundSource"];
			this._picCount = this._dataSource.readUnsignedByte();
			this._className = this._dataSource.readUTF();
			this._tmpDatas = new Array(this._picCount);
			this._tmpRects = new Array(this._picCount);
			this._parseTimer = new Timer(40);
			this._parseTimer.addEventListener(TimerEvent.TIMER, this.onTimeHandler);
			this._parseTimer.start();
		}
		private function onTimeHandler(evt:TimerEvent):void
		{
			var j:Function;
			var complete:Boolean;
			var i:int;
			while (i < 10) {
				this._tmpRects[this._currentCount] = new Rectangle(this._dataSource.readShort(), this._dataSource.readShort(), this._dataSource.readShort(), this._dataSource.readShort());
				this._tmpDatas[this._currentCount] = (new ((LoaderManager.domain.getDefinition((this._className + this._currentCount)) as Class))() as BitmapData);
				this._currentCount++;
				if (this._currentCount >= this._picCount){
					complete = true;
					break;
				};
				i++;
			};
			if (complete){
				_fileDatas = new DataFileInfo(path, null);
				_fileDatas.rects = this._tmpRects;
				_fileDatas.datas = this._tmpDatas;
				this._parseTimer.stop();
				this._parseTimer.removeEventListener(TimerEvent.TIMER, this.onTimeHandler);
				this._parseTimer = null;
				for each (j in callbacks) {
					if (j != null){
						(j(_fileDatas));
					};
				};
				callbacks.length = 0;
			};
		}
		override public function dispose():void
		{
			var i:int;
			if (this._dataSource){
				this._dataSource.length = 0;
			};
			if (this._parseTimer){
				this._parseTimer.stop();
				this._parseTimer.removeEventListener(TimerEvent.TIMER, this.onTimeHandler);
				this._parseTimer = null;
			};
			if (_fileDatas == null){
				if (this._tmpDatas){
					i = 0;
					while (i < this._tmpDatas.length) {
						if (this._tmpDatas[i]){
							this._tmpDatas[i].dispose();
						};
						i++;
					};
				};
			};
			this._tmpRects = null;
			this._tmpDatas = null;
			super.dispose();
		}
		
	}
}
