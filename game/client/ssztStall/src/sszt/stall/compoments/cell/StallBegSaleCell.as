package sszt.stall.compoments.cell
{
	import sszt.ui.container.MAlert;
	
	import sszt.constData.DragActionType;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;

	public class StallBegSaleCell extends StallBaseItemInfoCell
	{
		public function StallBegSaleCell(clickHandler:Function, doubleClickHandler:Function)
		{
			super(clickHandler, doubleClickHandler);
		}
		
		override public function dragStop(data:IDragData):void
		{
//			if(data.action == DragActionType.NONE||data.action == DragActionType.ONSELF)
//			{
//				locked = false;
//				return;
//			}
//			else if(data.action == DragActionType.DRAGIN)
//			{
//				StallRemoveSocketHandler.sendRemove(this.itemInfo.place,true);
//			}
			if(data.action == DragActionType.NONE)
			{
				MAlert.show("拖动失败","警告");
			}
				
		}
		
		override public function getSourceType():int
		{
			return CellType.STALLBEGSALECELL;
		}
	}
}