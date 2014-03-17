package sszt.bag.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import ssztui.bag.LockBtnAsset;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	
	public class BagLockCell extends MCacheAsset1Btn implements IDragable
	{
		private var _bg:BitmapData;
		
		public function BagLockCell()
		{
			_bg = new LockBtnAsset();
			super(1,LanguageManager.getWord("ssztl.bag.addLock"));
		}
		
		public function getSourceType():int
		{
			return CellType.LOCKCELL;
		}
		
		public function getDragImage():DisplayObject
		{
			return new Bitmap(_bg);
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
			_bg = null;
			super.dispose();
		}
	}
}