package sszt.furnace.components.cell
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.utils.ColorUtils;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	
	public class FurnaceCell extends BaseItemInfoCell implements IAcceptDrag
	{
		private var _furnaceItemInfo:FurnaceItemInfo;
		public function FurnaceCell(argFurnaceItemInfo:FurnaceItemInfo = null)
		{
			super();
			furnaceItemInfo = argFurnaceItemInfo;
		}
		
		public function get furnaceItemInfo():FurnaceItemInfo
		{
			return _furnaceItemInfo;
		}

		public function set furnaceItemInfo(value:FurnaceItemInfo):void
		{
			if(_furnaceItemInfo == value)return ;
			_furnaceItemInfo = value;
			if(_furnaceItemInfo)
			{
				itemInfo = _furnaceItemInfo.bagItemInfo;
			}
			else
			{
				itemInfo = null;
			}
		}
		
		override public function dispose():void
		{
			_furnaceItemInfo = null;
			super.dispose();
		}
	}
}