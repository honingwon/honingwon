package sszt.consign.components
{
	import flash.display.Shape;
	
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.CellType;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	
	public class ConsignCellEmpty extends Shape implements IAcceptDrag
	{
		public var _itemInfo:ItemInfo;
		public function ConsignCellEmpty()
		{
			super();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,38,38);
			graphics.endFill();
		}
		
		public function dragDrop(data:IDragData):int
		{
			var action:int = DragActionType.UNDRAG;
			var _source:IDragable = data.dragSource;
			var _tmpItemInfo:ItemInfo = _source.getSourceData() as ItemInfo;
			if(_source == this)return action;
			if(!_tmpItemInfo) return action;
			if(_source.getSourceType() == CellType.BAGCELL)
			{
				_itemInfo = _tmpItemInfo;
				_tmpItemInfo.lock = true;
				action = DragActionType.DRAGIN;
				dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,_tmpItemInfo));
			}
			return action;
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}
	}
}