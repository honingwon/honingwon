package sszt.stall.compoments.cell
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import sszt.constData.DragActionType;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	
	public class StallShoppingBegBuyCell extends StallBaseCell
	{
		public function StallShoppingBegBuyCell(argClickHandler:Function = null,argDoubleClickHandler:Function = null)
		{
			super(argClickHandler,argDoubleClickHandler);
		}
		
		override public function dragStop(data:IDragData):void
		{

		}
		
		override public function getSourceType():int
		{
			return CellType.STALLSHOPPINGBEGBUYCELL;
		}
	}
}