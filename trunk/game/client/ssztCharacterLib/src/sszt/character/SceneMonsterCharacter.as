/**
 * 怪物 
 */
package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.SceneMonsterCharacterLoader;
	import sszt.constData.ActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	

	public class SceneMonsterCharacter extends LayerCharacter 
	{
		
		public function SceneMonsterCharacter(info:ICharacterInfo)
		{
			super(info);
		}
		override protected function init():void
		{
			var i:Bitmap;
			super.init();
			_layers = [new Bitmap()];
			for each (i in _layers) 
			{
				addChild(i);
			}
			_datas = [];
		}
		override protected function getLayerType():String
		{
			return LayerType.SCENE_MONSTER;
		}
		override protected function getLoader():ICharacterLoader
		{
			return new SceneMonsterCharacterLoader(_info);
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var arr:Array = new Array();
			if (_datas[0].datas && _datas[0].datas[frame] != null)
			{
				arr.push([new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY())], [_datas[0].datas[frame].getBD()]);
			}
			return arr;
		}
		
	}
}
