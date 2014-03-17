package sszt.core.caches
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import sszt.core.utils.AssetUtil;

	public class PlayerIconCaches
	{
		public static const SMALL:int = 0;
		public static const BIG:int = 1;
		public static const MEDIUM:int = 2;
		
		private static var _bigIcons:Array = [];
		private static var _smallIcons:Array = [];
		private static var _mediumlIcons:Array = [];
		
		public static function setup():void
		{
			var nullData:BitmapData = new BitmapData(43,43,true,0x70000000);
			var snullData:BitmapData = new BitmapData(24,24,true,0x70000000);
			var mnullData:BitmapData = new BitmapData(32,32,true,0x70000000);
			var matrix:Matrix = new Matrix(0.75,0,0,0.75);
			var mmatrix:Matrix = new Matrix(1,0,0,1);
			
			var normalIcon:BitmapData = AssetUtil.getAsset("ssztui.common.ImMsgPlayerAsset") as BitmapData;
			if(normalIcon)
			{
				_bigIcons.push(normalIcon);
				
				var snormalIcon:BitmapData = new BitmapData(24,24,true,0);
				snormalIcon.draw(normalIcon);
				_smallIcons.push(snormalIcon);
				
				var mnormalIcon:BitmapData = new BitmapData(32,32,true,0);
				mnormalIcon.draw(normalIcon);
				_mediumlIcons.push(mnormalIcon);
			}
			else
			{
				_bigIcons.push(nullData);
				_smallIcons.push(snullData);
				_mediumlIcons.push(null);
			}
//			_bigIcons.push(null);
//			_smallIcons.push(null);
//			_mediumlIcons.push(null);
			//岳王
			var shangwub1:BitmapData = AssetUtil.getAsset("ssztui.common.HeadCell1Asset") as BitmapData;
//			matrix.scale(24/shangwub1.width,24/shangwub1.height);
//			mmatrix.scale(32/shangwub1.width,32/shangwub1.height);
//			var shangwub1:BitmapData = AssetUtil.getAsset("ssztui.common.ImMsgPlayerAsset") as BitmapData;
			if(shangwub1)
			{
				_bigIcons.push(shangwub1);
				
				var sshangwub1:BitmapData = new BitmapData(24,24,true,0);
				sshangwub1.draw(shangwub1,matrix);
				_smallIcons.push(sshangwub1);
				
				var mshangwub1:BitmapData = new BitmapData(32,32,true,0);
				mshangwub1.draw(shangwub1,mmatrix);
				_mediumlIcons.push(mshangwub1);
			}
			else
			{
				_bigIcons.push(nullData);
				_smallIcons.push(snullData);
				_mediumlIcons.push(null);
			}
			var shangwug1:BitmapData = AssetUtil.getAsset("ssztui.common.HeadCell2Asset") as BitmapData;
//			var shangwug1:BitmapData = AssetUtil.getAsset("ssztui.common.ImMsgPlayerAsset") as BitmapData;
			if(shangwug1)
			{
				_bigIcons.push(shangwug1);
				
				var sshangwug1:BitmapData = new BitmapData(24,24,true,0);
				sshangwug1.draw(shangwug1,matrix);
				_smallIcons.push(sshangwug1);
				
				var mshangwug1:BitmapData = new BitmapData(32,32,true,0);
				mshangwug1.draw(shangwug1,mmatrix);
				_mediumlIcons.push(mshangwug1);
			}
			else
			{
				_bigIcons.push(nullData);
				_smallIcons.push(snullData);
				_mediumlIcons.push(null);
			}
			//百花谷
			var xiaoyaob1:BitmapData = AssetUtil.getAsset("ssztui.common.HeadCell3Asset") as BitmapData;
//			var xiaoyaob1:BitmapData = AssetUtil.getAsset("ssztui.common.ImMsgPlayerAsset") as BitmapData;
			if(xiaoyaob1)
			{
				_bigIcons.push(xiaoyaob1);
				
				var sxiaoyaob1:BitmapData = new BitmapData(24,24,true,0);
				sxiaoyaob1.draw(xiaoyaob1,matrix);
				_smallIcons.push(sxiaoyaob1);
				
				var mxiaoyaob1:BitmapData = new BitmapData(32,32,true,0);
				mxiaoyaob1.draw(xiaoyaob1,mmatrix);
				_mediumlIcons.push(mxiaoyaob1);
			}
			else 
			{
				_bigIcons.push(nullData);
				_smallIcons.push(snullData);
				_mediumlIcons.push(null);
			}
			var xiaoyaog1:BitmapData = AssetUtil.getAsset("ssztui.common.HeadCell4Asset") as BitmapData;
//			var xiaoyaog1:BitmapData = AssetUtil.getAsset("ssztui.common.ImMsgPlayerAsset") as BitmapData;
			if(xiaoyaog1)
			{
				_bigIcons.push(xiaoyaog1);
				
				var sxiaoyaog1:BitmapData = new BitmapData(24,24,true,0);
				sxiaoyaog1.draw(xiaoyaog1,matrix);
				_smallIcons.push(sxiaoyaog1);
				
				var mxiaoyaog1:BitmapData = new BitmapData(32,32,true,0);
				mxiaoyaog1.draw(xiaoyaog1,mmatrix);
				_mediumlIcons.push(mxiaoyaog1);
			}
			else 
			{
				_bigIcons.push(nullData);
				_smallIcons.push(snullData);
				_mediumlIcons.push(null);
			}
			//唐门
			var liuxingb1:BitmapData = AssetUtil.getAsset("ssztui.common.HeadCell5Asset") as BitmapData;
//			var liuxingb1:BitmapData = AssetUtil.getAsset("ssztui.common.ImMsgPlayerAsset") as BitmapData;
			if(liuxingb1)
			{
				_bigIcons.push(liuxingb1);
				
				var sliuxingb1:BitmapData = new BitmapData(24,24,true,0);
				sliuxingb1.draw(liuxingb1,matrix);
				_smallIcons.push(sliuxingb1);
				
				var mliuxingb1:BitmapData = new BitmapData(32,32,true,0);
				mliuxingb1.draw(liuxingb1,mmatrix);
				_mediumlIcons.push(mliuxingb1);
			}
			else 
			{
				_bigIcons.push(nullData);
				_smallIcons.push(snullData);
				_mediumlIcons.push(null);
			}
			var liuxingg1:BitmapData = AssetUtil.getAsset("ssztui.common.HeadCell6Asset") as BitmapData;
//			var liuxingg1:BitmapData = AssetUtil.getAsset("ssztui.common.ImMsgPlayerAsset") as BitmapData;
			if(liuxingg1)
			{
				_bigIcons.push(liuxingg1);
				
				var sliuxingg1:BitmapData = new BitmapData(24,24,true,0);
				sliuxingg1.draw(liuxingg1,matrix);
				_smallIcons.push(sliuxingg1);
				
				var mliuxingg1:BitmapData = new BitmapData(32,32,true,0);
				mliuxingg1.draw(liuxingg1,mmatrix);
				_mediumlIcons.push(mliuxingg1);
			}
			else 
			{
				_bigIcons.push(nullData);
				_smallIcons.push(snullData);
				_mediumlIcons.push(null);
			}
			
			
		}
		
		public static function getIcon(type:int,index:int):BitmapData
		{
			if(type == SMALL)
				return _smallIcons[index];
			if(type == MEDIUM)
				return _mediumlIcons[index];
			return _bigIcons[index];
		}
	}
}