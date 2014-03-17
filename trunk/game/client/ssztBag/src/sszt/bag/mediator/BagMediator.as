package sszt.bag.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.bag.BagModule;
	import sszt.bag.component.BagPanel;
	import sszt.bag.component.BagSplitPanel;
	import sszt.bag.event.BagMediatorEvent;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToBagData;

	public class BagMediator extends Mediator
	{
		public static const NAME:String = "bagMediator";
		
		public function BagMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				BagMediatorEvent.BAG_START,
				BagMediatorEvent.BAG_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:ToBagData = notification.getBody() as ToBagData;
			switch(notification.getName())
			{
				case BagMediatorEvent.BAG_START:
					initBag(data);
					break;
				case BagMediatorEvent.BAG_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function initBag(data:ToBagData):void
		{
			if(bagModule.bagPanel == null)
			{
				bagModule.bagPanel=new BagPanel(this,data);
				GlobalAPI.layerManager.addPanel(bagModule.bagPanel);
				bagModule.bagPanel.addEventListener(Event.CLOSE,bagPanelCloseHandler);
			}		
		}
		
		private function bagPanelCloseHandler(evt:Event):void
		{
			if(bagModule.bagPanel)
			{
				bagModule.bagPanel.removeEventListener(Event.CLOSE,bagPanelCloseHandler);
				bagModule.bagPanel = null;
				bagModule.dispose();
			}
		}
		
		public function showSplitPanel(info:ItemInfo):void
		{
			if(info == null)return;
			if(bagModule.splitPanel == null)
			{
				bagModule.splitPanel = new BagSplitPanel(info,this);
				GlobalAPI.layerManager.addPanel(bagModule.splitPanel);
				bagModule.splitPanel.addEventListener(Event.CLOSE,splitPanelCloseHandler);
			}
		}
		
		private function splitPanelCloseHandler(evt:Event):void
		{
			if(bagModule.splitPanel)
			{
				bagModule.splitPanel.removeEventListener(Event.CLOSE,splitPanelCloseHandler);
//				bagModule.splitPanel.dispose();
				bagModule.splitPanel = null;
			}
		}
			
		public function get bagModule():BagModule
		{
			return viewComponent as BagModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}