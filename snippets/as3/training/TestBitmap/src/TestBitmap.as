package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class TestBitmap extends Sprite
	{
		public function TestBitmap()
		{
			var data:BitmapData =  new BitmapData(100, 100, true, 0xffff0000);//透明度为1，红色，尺寸100px*100px
			var bitmap:Bitmap = new Bitmap(data);
			var bitmap2:Bitmap = new Bitmap(data.clone());//位图复制
			bitmap2.y = 120;
			//位图变形
			bitmap2.rotation = 45;
			bitmap2.scaleX = 0.5;
			bitmap2.scaleY = 0.5;
			addChild(bitmap);
			addChild(bitmap2);
			//把data中心20*20的像素改为绿色
			for(var i:int = 40; i<60; i++){
				for(var j:int = 40; j<60; j++){
					data.setPixel(i, j, 0x00FF00);
				}
			}
		}
	}
}