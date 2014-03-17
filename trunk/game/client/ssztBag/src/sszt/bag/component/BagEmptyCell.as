package sszt.bag.component
{
	import flash.display.Shape;
	
	import sszt.ui.container.MAlert;
	
	import sszt.constData.CommonBagType;
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;


	public class BagEmptyCell extends Shape implements IAcceptDrag
	{
		public function BagEmptyCell()
		{
			super();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,262,280);
			graphics.endFill();
		}
		
		public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var sourceData:ItemInfo = source.getSourceData() as ItemInfo;
			var action:int = DragActionType.NONE;
			if(source.getSourceType() == CellType.ROLECELL)
			{
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.BAG,1000,1);
				action = DragActionType.DRAGIN;
			}
			if(source.getSourceType() == CellType.BAGCELL)
			{
				action == DragActionType.UNDRAG;
			}
			if(source.getSourceType() == CellType.MAILCELL)
			{
				action = DragActionType.DRAGIN;
			}
			return action;
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
		}
	}
}