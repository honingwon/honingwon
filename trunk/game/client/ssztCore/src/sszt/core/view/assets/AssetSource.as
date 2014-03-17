package sszt.core.view.assets
{
	import flash.display.BitmapData;
	
	import sszt.core.utils.AssetUtil;

	public class AssetSource
	{
		/**
		 * 小飞鞋
		 */		
		private static var _taskTransfer:BitmapData;
		
		public static function setup():void
		{
			_taskTransfer = AssetUtil.getAsset("ssztui.common.TaskTransferAsset",BitmapData) as BitmapData;
		}
		
		public static function getTransferShoes():BitmapData
		{
			return _taskTransfer;
		}
	}
}