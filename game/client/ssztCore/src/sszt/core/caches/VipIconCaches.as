package sszt.core.caches
{
	import flash.display.BitmapData;
	
	import sszt.core.utils.AssetUtil;

	public class VipIconCaches
	{
		public static var vipCache:Array = [];
		
		public static function setup():void
		{
			vipCache.push(null);
//			vipCache.push(AssetUtil.getAsset("ssztui.common.Vip3Asset",BitmapData) as BitmapData);
//			vipCache.push(AssetUtil.getAsset("ssztui.common.Vip2Asset",BitmapData) as BitmapData);
//			vipCache.push(AssetUtil.getAsset("ssztui.common.Vip1Asset",BitmapData) as BitmapData);
		}
	}
}