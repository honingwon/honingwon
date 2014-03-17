package sszt.core.view.paopao
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import sszt.core.utils.AssetUtil;

	public class PaopaoSoure
	{
		public var bgAsset1:BitmapData;
		public var bgAsset2:BitmapData;
		public var bgAsset3:BitmapData;
		public var bgAsset4:BitmapData;
		
		public function PaopaoSoure()
		{
			init();
		}
		
		private function init():void
		{
			var bp:BitmapData;
			var asset:MovieClip = AssetUtil.getAsset("ssztui.common.PaopaoAsset",MovieClip) as MovieClip;

			var tmp:Sprite = new Sprite();
			tmp.addChild(asset);
			asset.width = 150;
			asset.height = 55;
			bgAsset1 = new BitmapData(150,55,true,0);
			bgAsset1.draw(tmp);

			asset.height = 75;
			bgAsset2 = new BitmapData(150,75,true,0);
			bgAsset2.draw(tmp);
			
			asset.height = 104;
			bgAsset3 = new BitmapData(150,104,true,0);
			bgAsset3.draw(tmp);

			asset.height = 135;
			bgAsset4 = new BitmapData(150,135,true,0);
			bgAsset4.draw(tmp);
		}
	}
}