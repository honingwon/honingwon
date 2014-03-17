package sszt.stall.compoments.cell
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class StallBaseItemInfoCell extends BaseItemInfoCell implements IDoubleClick, IDragable
	{
		private var _clickHandler:Function;
		private var _doubleClickHandler:Function;
		public var _countField:TextField;
		
		public function StallBaseItemInfoCell(clickHandler:Function,doubleClickHandler:Function)
		{
			super(null, true, true, -1);
			_clickHandler = clickHandler;
			_doubleClickHandler = doubleClickHandler;
			
			_countField = new TextField();
			_countField.selectable = false;
			_countField.textColor = 0xFFFFFF;
			_countField.x = 23;
			_countField.y = 16;
			_countField.width = 25;
			_countField.height = 25;
			_countField.filters = [new GlowFilter(0x000000,1,2,2,10)];
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
			_iteminfo = value;
			if(_iteminfo)
			{
				info = _iteminfo.template;
				_countField.text = _iteminfo.count.toString();
			}
			else
			{
				info = null;
				_countField.text ="";
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			 if(info)TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,itemInfo.stallSellPrice);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(itemInfo || info)TipsUtil.getInstance().hide();
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countField);
		}
		
		override protected function setItemLock():void
		{
		}
		
		override public function dispose():void
		{
			_countField = null;
			super.dispose();
		}
	}
}