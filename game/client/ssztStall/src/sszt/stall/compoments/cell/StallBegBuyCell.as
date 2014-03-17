package sszt.stall.compoments.cell
{
	import sszt.constData.DragActionType;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;

	public class StallBegBuyCell extends StallBaseCell
	{
		public function StallBegBuyCell(argClickHandler:Function=null, argDoubleClickHandler:Function=null)
		{
			super(argClickHandler, argDoubleClickHandler);
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
//				StallRemoveSocketHandler.sendRemove(stallBuyInfo.templateId,false);
//			}
		}
		
		override public function getSourceType():int
		{
			return CellType.STALLBEGBUYCELL;
		}
	}
}