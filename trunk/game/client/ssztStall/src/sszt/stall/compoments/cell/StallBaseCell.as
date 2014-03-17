package sszt.stall.compoments.cell
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class StallBaseCell extends BaseCell implements IDoubleClick, IDragable
	{
		private var _stallBuyInfo:StallBuyCellInfo;
		private var _clickHandler:Function;
		private var _doubleClickHandler:Function;
		public var _countField:TextField;
		
		public function StallBaseCell(argClickHandler:Function = null,argDoubleClickHandler:Function = null)
		{
			_clickHandler = argClickHandler;
			_doubleClickHandler = argDoubleClickHandler;
			
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
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countField);
		}
		
		public function get stallBuyInfo():StallBuyCellInfo
		{
			return _stallBuyInfo;
		}
		
		public function set stallBuyInfo(value:StallBuyCellInfo):void
		{
			if(_stallBuyInfo == value)
			{
				if(value != null)
				{
					_countField.text = _stallBuyInfo.num.toString();
				}
				return ;
			}
			_stallBuyInfo = value;
			if(_stallBuyInfo)
			{
				info = _stallBuyInfo.getTemplateById();
				_countField.text = _stallBuyInfo.num.toString();
			}
			else
			{
				info = null;
				_countField.text ="";
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)
			{
				TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,_stallBuyInfo.price);
			}
			
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(_stallBuyInfo || info)TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			_countField = null;
			super.dispose();
		}
	}
}