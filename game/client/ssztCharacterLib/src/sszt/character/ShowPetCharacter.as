package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.PetCharacterLoader;
	import sszt.character.loaders.ShowPetCharacterLoader;
	import sszt.constData.LayerType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	
	public class ShowPetCharacter extends LayerCharacter 
	{
		
		public function ShowPetCharacter(info:ICharacterInfo)
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
			return LayerType.SHOW_PET;
		}
		override protected function getLoader():ICharacterLoader
		{
			return new ShowPetCharacterLoader(_info);
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
		
	}
}