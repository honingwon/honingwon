package sszt.core.caches
{
	import flash.display.BitmapData;
	
	import sszt.core.utils.AssetUtil;

	public class ToolTipCaches
	{
		public function ToolTipCaches()
		{
		}
		
		public static var toolTipBgCache:Array = [];
		public static var tipBindingAsset:Array = [];
		
		public static var tipWidgetFitAsset:BitmapData;
		
		public static var tipStarAsset:BitmapData;
		public static var tipStarAsset1:BitmapData;
		public static var tipDescendIconAsset:BitmapData;
		public static var tipRiseIconAsset:BitmapData;
		
		public static var tipHoleOnAsset:BitmapData;
		public static var tipHoleOffAsset:BitmapData;
		//public static var tipSplitLineAsset:BitmapData;
		
		
		public static function setup():void
		{
			toolTipBgCache.push(null);
			toolTipBgCache.push(AssetUtil.getAsset("ssztui.common.TipQuality0Asset",BitmapData) as BitmapData);
			toolTipBgCache.push(AssetUtil.getAsset("ssztui.common.TipQuality1Asset",BitmapData) as BitmapData);
			toolTipBgCache.push(AssetUtil.getAsset("ssztui.common.TipQuality2Asset",BitmapData) as BitmapData);
			toolTipBgCache.push(AssetUtil.getAsset("ssztui.common.TipQuality3Asset",BitmapData) as BitmapData);
			toolTipBgCache.push(AssetUtil.getAsset("ssztui.common.TipQuality4Asset",BitmapData) as BitmapData);
			
			tipBindingAsset.push(AssetUtil.getAsset("ssztui.common.Tipbinding1Asset",BitmapData) as BitmapData);//装绑
			tipBindingAsset.push(AssetUtil.getAsset("ssztui.common.Tipbinding2Asset",BitmapData) as BitmapData);//非绑
			tipBindingAsset.push(AssetUtil.getAsset("ssztui.common.Tipbinding3Asset",BitmapData) as BitmapData);//已绑
			
			
			tipStarAsset = AssetUtil.getAsset("ssztui.common.TipStarAsset",BitmapData) as BitmapData;
			tipStarAsset1 = AssetUtil.getAsset("ssztui.common.TipStarAsset1",BitmapData) as BitmapData;
			
			tipWidgetFitAsset = AssetUtil.getAsset("ssztui.common.TipWidgetFitAsset",BitmapData) as BitmapData;
			
			tipRiseIconAsset = AssetUtil.getAsset("ssztui.common.TipWidgetUpAsset",BitmapData) as BitmapData;
			tipDescendIconAsset = AssetUtil.getAsset("ssztui.common.TipWidgetDownAsset",BitmapData) as BitmapData;
			
			
			tipHoleOnAsset = AssetUtil.getAsset("ssztui.common.TipWidgetHoleOnAsset",BitmapData) as BitmapData;
			tipHoleOffAsset = AssetUtil.getAsset("ssztui.common.TipWidgetHoleOffAsset",BitmapData) as BitmapData;
			//tipSplitLineAsset = = AssetUtil.getAsset("ssztui.ui.SplitLine2Asset",BitmapData) as BitmapData;
		}
		
	}
}