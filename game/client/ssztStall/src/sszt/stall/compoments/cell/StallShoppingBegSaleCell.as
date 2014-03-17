package sszt.stall.compoments.cell
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.view.cell.BaseCompareItemInfoCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.events.CellEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	
	public class StallShoppingBegSaleCell extends StallBaseItemInfoCell
	{		
		public function StallShoppingBegSaleCell(clickHandler:Function,doubleClickHandler:Function)
		{
			super(clickHandler,doubleClickHandler);
		}
		
		override public function getSourceType():int
		{
			return CellType.STALLSHOPPINGBEGSALECELL;
		}
		
		override public function dragStop(data:IDragData):void
		{

		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			if(_iteminfo == value)
			{
				if(value != null)
				{
					_countField.text = _iteminfo.count.toString();
				}
				return ;
			}
			if(_iteminfo)
			{
				_iteminfo.removeEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,lockUpdateHandler);
			}
			_iteminfo = value;
			if(_iteminfo)
			{
				_iteminfo.addEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,lockUpdateHandler);
				info = _iteminfo.template;
				_countField.text = _iteminfo.count.toString();
			}
			else
			{
				info = null;
				_countField.text ="";
			}
		}
		
		override protected function setItemLock():void
		{
			locked = _iteminfo.lock;
		}
	}
}