package sszt.stall.compoments.emptyCell
{
	import flash.display.Shape;
	
	import sszt.ui.container.MAlert;
	
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.view.cell.CellType;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	
	public class StallBegBuyCellEmpty extends StallCellBaseEmpty
	{
		public function StallBegBuyCellEmpty()
		{
			super();
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.NONE;
			
			if(GlobalData.selfPlayer.stallName != "")
			{
				action = DragActionType.UNDRAG;
				return action;
			}
			
			if(!source)return action;
			var sourceItemInfo:ItemInfo = source.getSourceData() as ItemInfo;
			
			if(source == this){}
			else if(source.getSourceType() == CellType.BAGCELL)
			{
				if(!sourceItemInfo.template.canSell)
				{
					action = DragActionType.UNDRAG;
					MAlert.show("此物品不可售店！","警告");
				}
				else
				{
					action = DragActionType.DRAGIN;
					dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,sourceItemInfo));
				}
			}
			return action;
		}
	}
}