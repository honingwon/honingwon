package sszt.character
{
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.constData.LayerType;
	import sszt.character.loaders.ShowCharacterLoader;
	import sszt.interfaces.character.ICharacterLoader;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import sszt.events.CharacterEvent;
	
	public class ShowCharacter extends LayerCharacter 
	{
		
		private var _currentStyle:Array;
		private var _getMounts:Boolean;
		
		private var _currentListType:Array;
		
		private static var _layerSort1:Array = [[2,1,0], [2,0, 1]];
		
		protected var _strengthLevel:int;
		protected var _windStrengthLevel:int;
		protected var _hideWeapon:Boolean;
		protected var _hideSuit:Boolean;
		
		
		public function ShowCharacter(info:ICharacterInfo)
		{
			super(info);
			this.mouseChildren = this.mouseEnabled =false;
			this._currentStyle = _info.style.slice(0);
			this._getMounts = _info.getMounts();
			this._strengthLevel = info.getWeaponStrength();
			this._windStrengthLevel = info.getWindStrength();
			this._hideWeapon = _info.getHideWeapon();
			this._hideSuit = _info.getHideSuit();
			
			this.setListType();
		}
		override protected function getLayerType():String
		{
			return (LayerType.SHOW_PLAYER);
		}
		override protected function getLoader():ICharacterLoader
		{
			return (new ShowCharacterLoader(_info));
		}
		override protected function init():void
		{
			var i:Bitmap;
			super.init();
			_layers = [new Bitmap(), new Bitmap(), new Bitmap()];
			for each (i in _layers) {
				addChild(i);
			}
			_datas = [];
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var rects:Array = [];
			var datas:Array = [];
			var sortType:int;
			var i:int;
			
			for(i = 0; i < this._currentListType.length ; ++i)
			{
				var index:int = this._currentListType[i];
				if (_datas.length > index && _datas[index])
				{
					var tf :int = frame;
					if (_datas[index].datas && _datas[index].datas.length > tf && _datas[index].datas[tf] != null){
						rects.push(new Point(_datas[index].datas[tf].getX(), _datas[index].datas[tf].getY()));
						datas.push(_datas[index].datas[tf].getBD());
					}
				}
			}
			return ([rects, datas]);
		}
		override protected function canChange():Boolean
		{
			return true;
		}
		
		private function setListType():void
		{
			var index:int;
			if (this._currentStyle && this._currentStyle[1] != 0)
			{
				index = int(this._currentStyle[1]/1000);
				switch (index){
					case 211:
						this._currentListType =  _layerSort1[0];
						return;
					default:
						this._currentListType =  _layerSort1[1];
						return;
						
				}
			} 
			else 
			{
				this._currentListType =  _layerSort1[1];
			}
		}
		
		override protected function characterUpdateHandler(evt:CharacterEvent):void
		{
			if (_info == null || !this._getMounts == _info.getMounts())
			{
				return;
			}
			if (this._currentStyle[0] == _info.style[0] 
				&& this._currentStyle[1] == _info.style[1]
				&& this._currentStyle[2] == _info.style[2] 
				&& this._currentStyle[3] == _info.style[3] 
				&& this._strengthLevel == _info.getWeaponStrength() 
				&& this._windStrengthLevel == _info.getWindStrength()
				&& this._hideWeapon == _info.getHideWeapon()
				&& this._hideSuit == _info.getHideSuit()
				
			){
				return;
			}
			this._currentStyle = _info.style.slice(0);
			this._strengthLevel = _info.getWeaponStrength();
			this._windStrengthLevel = _info.getWindStrength();
			this._hideWeapon = _info.getHideWeapon();
			this._hideSuit = _info.getHideSuit();
			this.setListType();
			_actionController.stop();
			clearDatas();
			initLoadingAsset();
			_loader.load(showComplete);
		}
//		override protected function characterUpdateHandler(evt:CharacterEvent):void
//		{
//			if (_info == null){
//				return;
//			}
//			if (this._getMounts != _info.getMounts()){
//				return;
//			}
//			if (this._currentStyle[0] == _info.style[0] && 
//				this._currentStyle[1] == _info.style[1] && 
//				this._currentStyle[2] == _info.style[2] && 
//				this._currentStyle[3] == _info.style[3]) {
//				return
//			}
//			this._currentStyle = _info.style.slice(0);
//			_actionController.stop();
//			clearDatas();
//			initLoadingAsset();
//			_loader.load(showComplete);
//		}
		
	}
}