package sszt.character
{
	import sszt.interfaces.character.ICharacterInfo;
	import flash.display.Bitmap;
	import sszt.constData.LayerType;
	import sszt.character.loaders.SpaCharacterLoader;
	import sszt.interfaces.character.ICharacterLoader;
	import flash.geom.Point;
	
	public class SpaCharacter extends LayerCharacter 
	{
		
		public function SpaCharacter(info:ICharacterInfo)
		{
			super(info);
		}
		override protected function init():void
		{
			var i:Bitmap;
			super.init();
			_layers = [new Bitmap()];
			for each (i in _layers) {
				addChild(i);
			};
			_datas = [];
		}
		override protected function getFrameLen():int
		{
			return (70);
		}
		override protected function getLayerType():String
		{
			return (LayerType.SPA);
		}
		override protected function getLoader():ICharacterLoader
		{
			return (new SpaCharacterLoader(_info));
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var arr:Array = new Array();
			if (((((_datas[0].datas) && ((_datas[0].datas.length > frame)))) && (!((_datas[0].datas[frame] == null))))){
				arr.push([new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY())], [_datas[0].datas[frame].getBD()]);
			};
			return (arr);
		}
		
	}
}
