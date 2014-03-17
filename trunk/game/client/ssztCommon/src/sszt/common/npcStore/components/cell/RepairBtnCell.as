package sszt.common.npcStore.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	
	public class RepairBtnCell extends MCacheAsset3Btn implements IDragable
	{
		private var _bg:BitmapData;
		public function RepairBtnCell()
		{
			_bg = AssetUtil.getAsset("mhsm.common.RepairBtnAsset",BitmapData) as BitmapData;
			super(2,LanguageManager.getWord("ssztl.common.fix"));
		}
		
		public function getSourceType():int
		{
			return CellType.REPAIR;
		}
		
		public function getDragImage():DisplayObject
		{
			return new Bitmap(_bg);;
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
			super.dispose();
			_bg = null;
		}
	}
}