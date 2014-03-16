package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.MountsRunCharacterLoader;
	import sszt.constData.ActionType;
	import sszt.constData.DirectType;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	
	public class MountsRunCharacter extends BaseMountsRunCharacter
	{
		protected var _mountsStrengthLevel:int;
		
		public function MountsRunCharacter(info:ICharacterInfo)
		{
			super(info);
			this._currentCareerSortType = _layerSort1;
			this._mountsStrengthLevel = info.getMountsStrengthLevel();
			this.setListType();
		}
		
		
		override protected function getLayerType():String
		{
			return LayerType.MOUNTS_RUN;
		}
		
		override protected function getLoader():ICharacterLoader
		{
			return new MountsRunCharacterLoader(_info);
		}
		
		/**
		 * data [衣服，武器，翅膀，骑宠] 
		 * @param frame
		 * @return 
		 * 
		 */		
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var rects:Array = [];
			var datas:Array = [];
			var sortType:int;
			var i:int;
			while (i < 2) {
				if (this._currentListType[i].indexOf(frame) != -1)
				{
					sortType = i;
					break;
				}
				i++;
			}
			for(i = 0; i < this._currentCareerSortType[sortType].length ; ++i)
			{
				var index:int = this._currentCareerSortType[sortType][i];
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
			return [rects, datas];
		}
		
		override public function doActionType(actionType:int):void
		{
			if(actionType == ActionType.WALK )
				actionType = ActionType.STAND;
			super.doActionType(actionType);
		}
		
		override protected function canChange():Boolean
		{
			return true;
		}
		
		override protected function characterUpdateHandler(evt:CharacterEvent):void
		{
			if (_info == null || this._getMounts != _info.getMounts())
			{
				return;
			}
			if (this._currentStyle[0] == _info.style[0] 
				&& this._currentStyle[1] == _info.style[1]
				&& this._currentStyle[2] == _info.style[2] 
				&& this._currentStyle[3] == _info.style[3] 
				&& this._strengthLevel == _info.getWeaponStrength() 
				&& this._windStrengthLevel == _info.getWindStrength()
				&& this._mountsStrengthLevel == _info.getMountsStrengthLevel()
				&& this._hideWeapon == _info.getHideWeapon()
				&& this._hideSuit == _info.getHideSuit() ){
				return;
			}
			this._currentStyle = _info.style.slice(0);
			this._strengthLevel = _info.getWeaponStrength();
			this._windStrengthLevel = _info.getWindStrength();
			this._mountsStrengthLevel = _info.getMountsStrengthLevel();
			this._hideWeapon = _info.getHideWeapon();
			this._hideSuit = _info.getHideSuit();
			this.setListType();
			_actionController.stop();
			clearDatas();
			initLoadingAsset();
			_loader.load(showComplete);
		}
		
	}
}
