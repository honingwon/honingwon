package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.SceneCharacterLoader;
	import sszt.constData.ActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	
	public class SceneCharacter extends BaseSceneCharacter 
	{
		
		
		public function SceneCharacter(info:ICharacterInfo)
		{
			super(info);
			this._currentCareerSortType = _layerSort2;
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
		override protected function getLayerType():String
		{
			return LayerType.SCENE_PLAYER;
		}
		override protected function getLoader():ICharacterLoader
		{
			return new SceneCharacterLoader(_info);
		}
		
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
					if (_datas[index].datas && _datas[index].datas.length > tf && _datas[index].datas[tf] != null){
						rects.push(new Point(_datas[index].datas[tf].getX(), _datas[index].datas[tf].getY()));
						datas.push(_datas[index].datas[tf].getBD());
					}
				}
			}
			
			return [rects, datas];
		}

		override protected function canChange():Boolean
		{
			return true;
		}
		
		
		
	}
}
