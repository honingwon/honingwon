/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-29 上午11:33:41 
 * 
 */ 
package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class BloodBars2  extends Sprite
	{
		private var lifeArtBar:LifeArticle;
		
		
		
		private static var _bitmapData:BitmapData = new BitmapData(62, 5, true, 0x66000000);
		private static var _bitmapData1:BitmapData = new BitmapData(60, 3, true, 0xFFFF0000);
		private static var _bitmapData2:BitmapData = new BitmapData(60, 3, true, 0xffff9900);
		
		
		public function BloodBars2()
		{
			initView();
		}
		
		private function initView():void
		{
			var _bitmapDataBar:Bitmap = new Bitmap(_bitmapData)
			_bitmapDataBar.x = _bitmapDataBar.y = -1;
			this.addChild(_bitmapDataBar);
			lifeArtBar = new LifeArticle(60, 3,new Bitmap(_bitmapData1),new Bitmap(_bitmapData2));
			lifeArtBar.x = 0;
			lifeArtBar.y = 0;
			addChild(lifeArtBar);
		}
		
		
		public function setLife(life:int, maxLife:int):void{
			var w:int = ((life / maxLife) * this.lifeArtBar.lifeW);
			this.lifeArtBar.lifeValue = w;
		}
		public function updateLife(life:int, maxLife:int):void{
			var w:int = ((life / maxLife) * this.lifeArtBar.lifeW);
			this.lifeArtBar.lifeX = w;
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
	}
}