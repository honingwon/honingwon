package sszt.consign.components
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class ConsignItemCell extends BaseItemInfoCell implements IDoubleClick
	{
		private var _countTextField:TextField;
		private var _clickHandler:Function;
		private var _doubleClickHandler:Function;
		public function ConsignItemCell(clickHandler:Function,doubleClickHandler:Function)
		{
			super();
			_clickHandler = clickHandler;
			_doubleClickHandler = doubleClickHandler;
			
			_countTextField = new TextField();
			_countTextField.textColor = 0xFFFFFF;
			_countTextField.selectable = false;
			_countTextField.x = 4;
			_countTextField.y = 22;
			_countTextField.width = 33;
			_countTextField.height = 15;
			_countTextField.mouseEnabled = _countTextField.mouseWheelEnabled = false;
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countTextField.defaultTextFormat = t;
			_countTextField.filters = [new GlowFilter(0x000000,1,2,2,10)];
		}
		
		public function click():void
		{
			if(_clickHandler != null)
			{
				_clickHandler(this);
			}
		}
		
		public function doubleClick():void
		{
			if(_doubleClickHandler != null)
			{
				_doubleClickHandler(this);
			}
		}
		
		override protected function lockUpdateHandler(evt:ItemInfoUpdateEvent):void
		{
		}
		
		override public function getSourceType():int
		{
			return CellType.CONSIGNCELL;
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
//			if(_iteminfo == value)
//			{
//				if(value != null)
//				{
//					_countTextField.text = _iteminfo.count.toString();
//				}
//				return;
//			}
//			if(_iteminfo)
//			{
//				_iteminfo.lock = false;
//			}
//			_iteminfo = value;
//			if(_iteminfo)
//			{
//				_countTextField.text = _iteminfo.count.toString();
//				info = _iteminfo.template;
//			}
//			else
//			{
//				_countTextField.text = "";
//				info = null;
//			}
			
			if(_iteminfo == value)
			{
				if(value)
				{
					if(CategoryType.isEquip(_iteminfo.template.categoryId))
					{
						if(_iteminfo.strengthenLevel > 0)
							_countTextField.text = "+" + String(_iteminfo.strengthenLevel);
					}
					else
					{
						_countTextField.text = String(_iteminfo.count>1?_iteminfo.count:"");
					}
				}
			}
			else
			{
				if(_iteminfo)
				{
					_iteminfo.lock = false;
				}
				_iteminfo = value;
				if(_iteminfo)
				{
					info = _iteminfo.template;
					if(CategoryType.isEquip(_iteminfo.template.categoryId))
					{
						if(_iteminfo.strengthenLevel > 0)
							_countTextField.text = "+" + String(_iteminfo.strengthenLevel);
					}
					else
					{
						_countTextField.text = String(_iteminfo.count>1?_iteminfo.count:"");
					}
				}
				else
				{
					_countTextField.text = "";
					info = null;
				}
			}
		}
		
//		override public function dragDrop(data:IDragData):int
//		{
//			var action:int = DragActionType.UNDRAG;
//			var source:IDragable = data.dragSource;
//			var sourceInfo:ItemInfo = source.getSourceData() as ItemInfo;
//			if(source == this)return action;
//			if(!sourceInfo) return action;
//			if(source.getSourceType() == CellType.BAGCELL)
//			{
//				if(sourceInfo.isBind)
//				{
//					QuickTips.show(LanguageManager.getWord("ssztl.consign.consignBindItem"));
//				}
//				else
//				{
//					sourceInfo.lock = true;
//					action = DragActionType.DRAGIN;
//					dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,sourceInfo));
//				}
//			}
//			return action;
//		}
		
		override public function dragStop(data:IDragData):void
		{
			var action:int = data.action;
			if(action == DragActionType.DRAGIN)
			{
				itemInfo = null;
			}
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countTextField);
		}
		
		override protected function setItemLock():void
		{
		}
		
		override public function dispose():void
		{
			_countTextField = null;
			_clickHandler = null;
			_doubleClickHandler = null;
			super.dispose();
		}
	}
}