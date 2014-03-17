package sszt.bag.component.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ssztui.bag.SplitAsset;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class BagSplitBtnCell extends MCacheAssetBtn1 implements IDragable
	{
		private var _bd:BitmapData;
		
		public function BagSplitBtnCell()
		{
			super(0,1,LanguageManager.getWord("ssztl.bag.split"));
			_bd = new SplitAsset();
		}
		
		public function getSourceType():int
		{
			return CellType.SPLIT;
		}
		
		public function getDragImage():DisplayObject
		{
			return new Bitmap(_bd);
		}
		
		public function dragStop(data:IDragData):void
		{
		}
		
		public function getSourceData():Object
		{
			return null;
		}
		
		override public function dispose():void
		{
			_bd = null;
			super.dispose();
		}
	}
}