package sszt.bag.component.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ssztui.bag.RecycleBtnAsset;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class BagDropBtnCell extends MCacheAssetBtn1 implements IDragable
	{
		private var _bd:BitmapData;
		
		public function BagDropBtnCell()
		{
			_bd = new RecycleBtnAsset;
			super(0,1,LanguageManager.getWord("ssztl.bag.sell"));
		}
		
		public function getSourceType():int
		{
			return CellType.RECYCLE;
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