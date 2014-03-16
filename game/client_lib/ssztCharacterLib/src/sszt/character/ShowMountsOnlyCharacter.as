/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-12-21 上午10:17:41 
 * 
 */ 
package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.ShowMountsOnlyCharacterLoader;
	import sszt.constData.ActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;

	public class ShowMountsOnlyCharacter extends LayerCharacter 
	{
		public function ShowMountsOnlyCharacter(info:ICharacterInfo)
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
			return LayerType.SHOW_MOUNTS;
		}
		
		override protected function getLoader():ICharacterLoader
		{
			return new ShowMountsOnlyCharacterLoader(_info);
		}
		
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var arr:Array = new Array();
			if (_datas[0].datas && _datas[0].datas.length > frame  && _datas[0].datas[frame] != null)
			{
				arr.push([new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY())], [_datas[0].datas[frame].getBD()]);
			}
			return (arr);
		}
		
		override protected function canChange():Boolean
		{
			return true;
		}
		
		override protected function characterUpdateHandler(evt:CharacterEvent):void
		{
			show(_dir);
		}
	}
}