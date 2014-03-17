/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-14 上午9:53:16 
 * 
 */ 
package sszt.core.caches
{
	import flash.display.BitmapData;
	
	import sszt.core.utils.AssetUtil;

	public class MoneyIconCaches
	{
		public static var yuanBaoAsset:BitmapData;
		public static var bingYuanBaoAsset:BitmapData;
		public static var copperAsset:BitmapData;
		public static var bingCopperAsset:BitmapData;
		public static var qqMoneyAsset:BitmapData;
		
		public static function setup():void
		{
			yuanBaoAsset = AssetUtil.getAsset("ssztui.common.YuanBaoAsset",BitmapData) as BitmapData;
			bingYuanBaoAsset = AssetUtil.getAsset("ssztui.common.BindYuanBaoAsset",BitmapData) as BitmapData;
			copperAsset = AssetUtil.getAsset("ssztui.common.Copper",BitmapData) as BitmapData;
			bingCopperAsset = AssetUtil.getAsset("ssztui.common.BindCopper",BitmapData) as BitmapData;
			qqMoneyAsset = AssetUtil.getAsset("ssztui.common.QMoneyAsset",BitmapData) as BitmapData;
		}
		
	}
}