package sszt.furnace.components.cell
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class FurnaceQualityCell extends BaseItemInfoCell
	{
		public static var CELL_CLICK:String = "FURNACE_QUALITY_CELL_CLICK";
		private var _furnaceItemInfo:FurnaceItemInfo;
		public function FurnaceQualityCell(argFurnaceItemInfo:FurnaceItemInfo = null)
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
			if(_furnaceItemInfo == value)
			{
				if(!value){return ;}
			}
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
		override protected function clickHandler(evt:MouseEvent):void
		{
			dispatchEvent(new MouseEvent(FurnaceQualityCell.CELL_CLICK));
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_furnaceItemInfo = null;
		}

	}
}