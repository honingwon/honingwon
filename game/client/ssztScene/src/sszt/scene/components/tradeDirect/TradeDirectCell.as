package sszt.scene.components.tradeDirect
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonBagType;
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class TradeDirectCell extends BaseItemInfoCell
	{
		private var _countField:TextField;
		
		public function TradeDirectCell()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_countField = new TextField();
			_countField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countField.autoSize = TextFormatAlign.RIGHT;
			_countField.x = 4;
			_countField.y = 22;
			_countField.width = 33;
			_countField.height = 14;
			_countField.mouseEnabled = _countField.mouseWheelEnabled = false;
			_countField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			addChild(_countField);
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.UNDRAG;
			if(!source)return action;
			var bagItemInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(source == this){}
			else if(source.getSourceType() == CellType.BAGCELL)
			{
				if(bagItemInfo.template.canTrade == false)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotTradeItem"));
					return action;
				}
				if(bagItemInfo.isBind)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotTradeBindItem"));
					return action;
				}
				dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,{fromType:CommonBagType.BAG,place:bagItemInfo.place}));
				action = DragActionType.DRAGIN;
			}
			return action;
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			setChildIndex(_countField,numChildren - 1);
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(value)
			{
				_countField.text = String(value.count);
			}
			else
			{
				_countField.text = "";
			}
		}
		
		override protected function lockUpdateHandler(evt:ItemInfoUpdateEvent):void{}
		override protected function setItemLock():void{}
		
		override public function getSourceType():int
		{
			return CellType.TRADEDIRECTCELL;
		}
	}
}