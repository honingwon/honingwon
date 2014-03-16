package sszt.character.loaders
{
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.character.CharacterManager;
	
	public class LayerCharacterLoader extends BaseCharacterLoader 
	{
		
		protected var _loaders:Array;
		protected var _completeCount:int;
		protected var _totalCount:int;
		protected var _pathList:Array;
		private var _clearType:int;
		private var _clearTime:int;
		private var _priority:int;
		
		public function LayerCharacterLoader(info:ICharacterInfo, clearType:int=3, clearTime:int=214783647, priority:int=1)
		{
			this._clearType = clearType;
			this._clearTime = clearTime;
			this._priority = priority;
			super(info);
		}
		override protected function init():void
		{
			super.init();
			this._completeCount = 0;
			this._totalCount = 0;
		}
		protected function initLoaders():void
		{
			this._pathList = [];
			var idList:Array = [];
			var needSexList:Array = [];
			this.initList(this._pathList, idList, needSexList);
			
			this._loaders = new Array(this._pathList.length);
			if (this._pathList == null)
			{
				this._pathList = [];
			}
			var len:int = this._pathList.length;
			var i:int;
			while (i < len) {
				if (this._pathList && this._pathList[i] && this._pathList[i] != "")
				{
					this._totalCount++;
				}
				i++;
			}
			i = 0;
			while (i < len) {
				if (this._pathList && this._pathList[i] && this._pathList[i] != "")
				{
					CharacterManager.loaderApi.getFanmFile(this._pathList[i], this.layerCompleteHandler, this._clearType, this._clearTime, this._priority);
				}
				i++;
			}
		}
		protected function initList(list:Array, idList:Array, needSexList:Array):void
		{
		}
		protected function getLayerType():String
		{
			return ("");
		}
		override public function load(callBack:Function=null):void
		{
			this._completeCount = 0;
			this._totalCount = 0;
			super.load(callBack);
			if (_info == null){
				trace("BaseCharacterLoader: info is null");
				loadComplete();
				return;
			};
			this.initLoaders();
		}
		protected function layerCompleteHandler(layer:Object):void
		{
		}
		override public function getContent():Array
		{
			return this._loaders;
		}
		override public function clearContent():void
		{
			var len:int;
			var i:int;
			if (this._loaders)
			{
				len = this._pathList.length;
				i = 0;
				while (i < len) {
					if (this._pathList[i]){
						CharacterManager.loaderApi.removeFanmAQuote(this._pathList[i]);
					}
					i++;
				}
				this._loaders = null;
			}
		}
		protected function getSex():int
		{
			return (_info.getSex());
		}
		override public function dispose():void
		{
			this.clearContent();
			this._loaders = null;
			this._pathList = null;
			super.dispose();
		}
		
	}
}