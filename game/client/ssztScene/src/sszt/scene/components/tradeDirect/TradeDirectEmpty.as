package sszt.scene.components.tradeDirect
{
	import flash.display.Sprite;
	
	import sszt.constData.CommonBagType;
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.scene.mediators.TradeDirectMediator;
	
	public class TradeDirectEmpty extends Sprite implements IAcceptDrag
	{
		private var _mediator:TradeDirectMediator;
		
		public function TradeDirectEmpty(mediator:TradeDirectMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,160,122);
			graphics.endFill();
		}
		
		public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.UNDRAG;
			if(!source)return action;
			var bagItemInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(source == this){}
			else if(source.getSourceType() == CellType.BAGCELL)
			{
				if(!_mediator.sceneInfo.tradeDirectInfo.selfLock)
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
			}
			return action;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			_mediator = null;
			if(parent)parent.removeChild(this);
		}
	}
}