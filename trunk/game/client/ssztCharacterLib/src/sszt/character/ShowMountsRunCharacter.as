package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.ShowMountsCharacterLoader;
	import sszt.character.loaders.ShowMountsRunCharacterLoader;
	import sszt.constData.LayerType;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	
	public class ShowMountsRunCharacter extends BaseMountsRunCharacter 
	{
		protected var _mountsStrengthLevel:int;
		public function ShowMountsRunCharacter(info:ICharacterInfo)
		{
			this.mouseChildren = this.mouseEnabled =false;
			this._mountsStrengthLevel = info.getMountsStrengthLevel();
			super(info);
		}
		override protected function getLayerType():String
		{
			return LayerType.SHOW_MOUNTS;
		}
		override protected function getLoader():ICharacterLoader
		{
			return new ShowMountsRunCharacterLoader(_info);
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
					switch(index)
					{
						case 3:
							tf = frame1;
							break;
					}
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
		
		override protected function setListType():void
		{
			var index:int;
			if (this._currentStyle && this._currentStyle[1] != 0)
			{
				index = int(this._currentStyle[1]/1000);
				switch (index){
					case 211:
						this._currentListType =  [3,2,1,0];
						return;
					default:
						this._currentListType =  [3,2,0, 1];
						return;
						
				}
			} 
			else 
			{
				this._currentListType = [3,2,0, 1];
			}
		}
		
//		override protected function characterUpdateHandler(evt:CharacterEvent):void
//		{
//			if (_info == null || this._getMounts != _info.getMounts())
//			{
//				return;
//			}
//			if (this._currentStyle[0] == _info.style[0] 
//				&& this._currentStyle[1] == _info.style[1]
//				&& this._currentStyle[2] == _info.style[2] 
//				&& this._currentStyle[3] == _info.style[3] 
//				&& this._strengthLevel == _info.getWeaponStrength() 
//				&& this._windStrengthLevel == _info.getWindStrength()
//				&& this._mountsStrengthLevel == _info.getMountsStrengthLevel()
//				&& this._hideWeapon == _info.getHideWeapon()
//				&& this._hideSuit == _info.getHideSuit() ){
//				return;
//			}
//			this._currentStyle = _info.style.slice(0);
//			this._strengthLevel = _info.getWeaponStrength();
//			this._windStrengthLevel = _info.getWindStrength();
//			this._mountsStrengthLevel = _info.getMountsStrengthLevel();
//			this._hideWeapon = _info.getHideWeapon();
//			this._hideSuit = _info.getHideSuit();
//			this.setListType();
//			_actionController.stop();
//			clearDatas();
//			initLoadingAsset();
//			_loader.load(showComplete);
//		}
		
		
	}
}
