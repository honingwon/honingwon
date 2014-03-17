package sszt.stall.compoments.emptyCell
{
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.CellType;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;

	public class StallShopBuyCellEmpty extends StallCellBaseEmpty
	{
		public function StallShopBuyCellEmpty()
		{
			super();
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var action:int = DragActionType.NONE;
			var source:IDragable = data.dragSource;
			if(!source)return action;
			if(source == this) return action;
			var sourceInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(source.getSourceType() == CellType.STALLSHOPPINGBEGSALECELL)
			{
				action = DragActionType.DRAGIN;
				dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,sourceInfo));
			}
			if(source.getSourceType() == CellType.BAGCELL)
			{
				action = DragActionType.UNDRAG;
			}
			return action;
		}
	}
}