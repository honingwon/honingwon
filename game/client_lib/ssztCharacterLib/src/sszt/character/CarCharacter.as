package sszt.character
{
	import sszt.interfaces.character.ICharacterInfo;
	import flash.display.Bitmap;
	import sszt.constData.LayerType;
	import sszt.character.loaders.CarCharacterLoader;
	import sszt.interfaces.character.ICharacterLoader;
	import flash.geom.Point;
	
	public class CarCharacter extends LayerCharacter 
	{
		
		public function CarCharacter(info:ICharacterInfo)
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
		
		override protected function getLayerType():String
		{
			return LayerType.CAR;
		}
		override protected function getLoader():ICharacterLoader
		{
			return (new CarCharacterLoader(_info));
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var arr:Array = new Array();
			if (((((_datas[0].datas) && ((_datas[0].datas.length > frame)))) && (_datas[0].datas[frame]))){
				arr.push([new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY())], [_datas[0].datas[frame].getBD()]);
			};
			return (arr);
		}
		
	}
}
