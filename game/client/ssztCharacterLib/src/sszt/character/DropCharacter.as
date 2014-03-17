/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-19 下午1:57:00 
 * 
 */ 
package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.DropCharacterLoader;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;

	public class DropCharacter extends LayerCharacter 
	{
		public function DropCharacter(info:ICharacterInfo)
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
			return LayerType.SCENE_DROP;
		}
		override protected function getLoader():ICharacterLoader
		{
			return new DropCharacterLoader(_info);
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var arr:Array = new Array();
			if (_datas[0].datas && _datas[0].datas.length > frame && _datas[0].datas[frame] != null)
			{
				arr.push([new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY())], [_datas[0].datas[frame].getBD()]);
			}
			return (arr);
		}
		
		override protected function actionControllerStart(type:int):void
		{
			var frameRate:int = _info.getFrameRate(type);
			var obj:Object = this._datas[0];
			var start:int = (obj.actionSE[0]);
			var end:int = (obj.actionSE[1]);
			
			this._actionController.setDefaultAction(SceneCharacterActions.createActionInfo(this.getLayerType(),type,start,end,obj.directType,frameRate));
			
			this._actionController.start();
		}
	}
}