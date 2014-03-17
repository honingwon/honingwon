package sszt.core.caches
{
	import flash.display.BitmapData;
	
	import sszt.core.utils.AssetUtil;

	public class CellAssetCaches
	{
		public static var cellCloseAsset:BitmapData;
		
		public static function setup():void
		{
			cellCloseAsset = AssetUtil.getAsset("ssztui.common.CellCloseAsset",BitmapData) as BitmapData;
		}
	}
}