package sszt.common.wareHouse.component
{
	import flash.display.Sprite;
	
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	
	public class WarehouseEmptyCell extends Sprite
	{
		private var tempItem:ItemInfo;
		
		public function WarehouseEmptyCell()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,316,305);
			graphics.endFill();
		}
		
		public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.NONE;
			if(!source)return action;
			tempItem = source.getSourceData() as ItemInfo;
			if(source.getSourceType() == CellType.BAGCELL)
			{

			}
			return 0;
		}
		
		
		public function dispose():void
		{
			tempItem = null;
			if(parent) parent.removeChild(this);
		}
	}
}