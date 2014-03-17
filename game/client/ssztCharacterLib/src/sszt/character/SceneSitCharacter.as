package sszt.character
{
	import sszt.interfaces.character.ICharacterInfo;
	import flash.display.Bitmap;
	import sszt.constData.LayerType;
	import sszt.character.loaders.SceneSitCharacterLoader;
	import sszt.interfaces.character.ICharacterLoader;
	import flash.geom.Point;
	
	public class SceneSitCharacter extends LayerCharacter 
	{
		
		public function SceneSitCharacter(info:ICharacterInfo)
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
			}
			_datas = [];
		}
		override protected function getLayerType():String
		{
			return (LayerType.SCENE_SIT);
		}
		override protected function getLoader():ICharacterLoader
		{
			return (new SceneSitCharacterLoader(_info));
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			
			var rects:Array = [];
			var datas:Array = [];
			var index:int;
			
			for(index = 0; index < this._datas.length ; index++)
			{
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
		override protected function getFrameLen():int
		{
			return (5);
		}
		
	}
}
