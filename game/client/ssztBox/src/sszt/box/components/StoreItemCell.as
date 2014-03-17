package sszt.box.components
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	
	public class StoreItemCell extends BaseItemInfoCell implements IAcceptDrag
	{
//		private var _itemInfo:ItemInfo;
		private var _place:int;
//		private var _isOpen:Boolean;
		private var _countLabel:TextField;
		
		public function StoreItemCell()
		{
			super();
			
			_countLabel = new TextField();
			_countLabel.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countLabel.selectable = false;
			_countLabel.mouseEnabled = false;
			_countLabel.x = 7;
			_countLabel.y = 22;
			_countLabel.width = 32;
			_countLabel.height = 14;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
//			addChild();
			
		}
		
		override public function getSourceType():int
		{
			return CellType.SHENMOSTORECELL;
		}
		
		override public function getSourceData():Object
		{
			return _iteminfo;
		}
		
		override public function set itemInfo(item:ItemInfo):void
		{
			if(_iteminfo == item)
				return;
			_iteminfo = item;
			if(_iteminfo)
			{
				info = _iteminfo.template;
				if(CategoryType.isEquip(_iteminfo.template.categoryId))
				{
					if(_iteminfo.strengthenLevel > 0)
					{
						_countLabel.text = "+" + _iteminfo.strengthenLevel.toString();
					}
					else 
						_countLabel.text = "";
				}
				else
				{
					_countLabel.text = _iteminfo.count==1?"":_iteminfo.count.toString();
				}
			}
			else
			{
				info = null;
				_countLabel.text = "";
			}
		}
		
		override public function get itemInfo():ItemInfo
		{
			return _iteminfo;
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var action:int = DragActionType.UNDRAG;
			var source:IDragable = data.dragSource;
			if(!source)
				return action;
			if(source.getSourceType() == CellType.SHENMOSTORECELL)
			{
				//操作
			}
			
			return action;
		}
		
		public function get templateId():int
		{
			return itemInfo ? itemInfo.templateId : 0;
		}
		
		public function updateCount():void
		{
			if(itemInfo)
				_countLabel.text = String(itemInfo.count);
			else _countLabel.text = "";
		}
		
		override public function dragStop(data:IDragData):void
		{
			//操作
		}
		
		override protected function createPicComplete(data:BitmapData):void
		{
			super.createPicComplete(data);
			addChild(_countLabel);
		}
		
		override public function dispose():void
		{
			_iteminfo = null;
			super.dispose();
		}
	}
}
