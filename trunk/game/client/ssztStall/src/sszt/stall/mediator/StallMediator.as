package sszt.stall.mediator
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallInfo;
	import sszt.core.utils.SetModuleUtils;
	import sszt.stall.StallFacade;
	import sszt.stall.StallModule;
	import sszt.stall.compoments.StallPanel;
	import sszt.stall.compoments.StallShopPanel;
	import sszt.stall.compoments.popUpPanel.StallBuyPopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallSalePopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallShopBegSalePopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallShopBuyPopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallShopSalePopUpPanel;
	import sszt.stall.events.StallMediatorEvents;
	import sszt.stall.proxy.StallProxy;
	import sszt.stall.socketHandlers.StallOKSocketHandler;
	import sszt.stall.socketHandlers.StallPauseSocketHandler;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopBuySocketHandler;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopDataSocketHandler;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopMessageSocketHandler;
	import sszt.stall.socketHandlers.stallShopSocketHandlers.StallShopSaleSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class StallMediator extends Mediator
	{
		public static const NAME:String = "stallMediator";
		public function StallMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [StallMediatorEvents.STALL_MEDIATOR_START,
						 StallMediatorEvents.STALL_MEDIATOR_DISPOSE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case  StallMediatorEvents.STALL_MEDIATOR_START:
						  initialView();
					break;
				case StallMediatorEvents.STALL_MEDIATOR_DISPOSE:
					dispose();
					break;
				default:
					break;
			}
		}
		
		public function initialView():void
		{
			if(stallModule.isMyselfTag)
			{
				if(stallModule.stallPanel ==null)
				{
					stallModule.stallPanel = new StallPanel(this);
					stallModule.stallPanel.setData();
					GlobalAPI.layerManager.addPanel(stallModule.stallPanel);
					stallModule.stallPanel.addEventListener(Event.CLOSE,closeStallPanelHandlers);
				}
			}
			else
			{
				if(stallModule.stallShopPanel == null)
				{
					stallModule.stallShopPanel = new StallShopPanel(this);
					setStallShopData(stallModule.userId);
					GlobalAPI.layerManager.addPanel(stallModule.stallShopPanel);
					stallModule.stallShopPanel.addEventListener(Event.CLOSE,closeStallShopPanelHandler);
					SetModuleUtils.addBag();
				}
			}
		}
		
		private function closeStallPanelHandlers(e:Event):void
		{
			if(stallModule.stallPanel)
			{
				stallModule.stallPanel.removeEventListener(Event.CLOSE,closeStallPanelHandlers);
				stallModule.stallPanel = null;
				stallModule.dispose();
			}
		}
		
		
		private function closeStallShopPanelHandler(e:Event):void
		{
			if(stallModule.stallShopPanel)
			{
				stallModule.stallShopPanel.removeEventListener(Event.CLOSE,closeStallShopPanelHandler);
				stallModule.stallShopPanel = null;
				stallModule.dispose();
			}
		}
		
		
		
		public function showStallShopBegSalePopUpPanel(argItemInfo:ItemInfo):void
		{
			if(stallModule.stallShopBegSalePopUpPanel == null)
			{
				stallModule.stallShopBegSalePopUpPanel = new StallShopBegSalePopUpPanel(this,argItemInfo);
				GlobalAPI.layerManager.addPanel(stallModule.stallShopBegSalePopUpPanel);
				stallModule.stallShopBegSalePopUpPanel.addEventListener(Event.CLOSE,closeStallShopBegSalePopUpPanelHandler);
			}
		}
		
		private function closeStallShopBegSalePopUpPanelHandler(e:Event):void
		{
			if(stallModule.stallShopBegSalePopUpPanel)
			{
				stallModule.stallShopBegSalePopUpPanel.removeEventListener(Event.CLOSE,closeStallShopBegSalePopUpPanelHandler);
				stallModule.stallShopBegSalePopUpPanel = null;
			}
			
		}
		
		
		public function showStallShopBuyPopUpPanel(itemInfo:ItemInfo):void
		{
			if(stallModule.stallShopBuyPopUpPanel == null)
			{
				stallModule.stallShopBuyPopUpPanel = new StallShopBuyPopUpPanel(this,itemInfo);
				GlobalAPI.layerManager.addPanel(stallModule.stallShopBuyPopUpPanel);
				stallModule.stallShopBuyPopUpPanel.addEventListener(Event.CLOSE,closeStallShopBuyPopUpPanelHandler);
			}
		}
		
		private function closeStallShopBuyPopUpPanelHandler(e:Event):void
		{
			if(stallModule.stallShopBuyPopUpPanel)
			{
				stallModule.stallShopBuyPopUpPanel.removeEventListener(Event.CLOSE,closeStallShopBuyPopUpPanelHandler);
				stallModule.stallShopBuyPopUpPanel = null;
			}
			
		}
		
		
		public function showStallShopSalePopUpPanel(itemInfo:ItemInfo):void
		{
			if(stallModule.stallShopSalePopUpPanel == null)
			{
				stallModule.stallShopSalePopUpPanel = new StallShopSalePopUpPanel(this,itemInfo);
				GlobalAPI.layerManager.addPanel(stallModule.stallShopSalePopUpPanel);
				stallModule.stallShopSalePopUpPanel.addEventListener(Event.CLOSE,closeStallShopSalePopUpPanelHandler);
			}
		}
		
		private function closeStallShopSalePopUpPanelHandler(e:Event):void
		{
			if(stallModule.stallShopSalePopUpPanel)
			{
				stallModule.stallShopSalePopUpPanel.removeEventListener(Event.CLOSE,closeStallShopSalePopUpPanelHandler);
				stallModule.stallShopSalePopUpPanel = null;
			}
			
		}

		public function showStallBuyPopPanel(itemInfo:ItemInfo):void
		{
			if(stallModule.stallBuyPopUpPanel == null)
			{
				stallModule.stallBuyPopUpPanel = new StallBuyPopUpPanel(this,itemInfo);
				GlobalAPI.layerManager.addPanel(stallModule.stallBuyPopUpPanel);
				stallModule.stallBuyPopUpPanel.addEventListener(Event.CLOSE,closeStallBuyPopPanelHandler);
			}
		}
		
		public function closeStallBuyPopPanelHandler(e:Event):void
		{
			if(stallModule.stallBuyPopUpPanel)
			{
				stallModule.stallBuyPopUpPanel.removeEventListener(Event.CLOSE,closeStallBuyPopPanelHandler);
				stallModule.stallBuyPopUpPanel = null;
			}
		}
		
		public function showStallSalePopPanel(itemInfo:ItemInfo):void
		{
			if(stallModule.stallSalePopUpPanel == null)
			{
				stallModule.stallSalePopUpPanel = new StallSalePopUpPanel(this,itemInfo);
				GlobalAPI.layerManager.addPanel(stallModule.stallSalePopUpPanel);
				stallModule.stallSalePopUpPanel.addEventListener(Event.CLOSE,closeStallSalePopPanelHandler);
			}
		}
		
		public function closeStallSalePopPanelHandler(e:Event):void
		{
			if(stallModule.stallSalePopUpPanel)
			{
				stallModule.stallSalePopUpPanel.removeEventListener(Event.CLOSE,closeStallSalePopPanelHandler);
				stallModule.stallSalePopUpPanel = null;
			}
		}
		
		public function sendStallPause():void
		{
			StallPauseSocketHandler.sendPause();
		}
		
		public function sendStallStart(stallName:String):void
		{
			StallOKSocketHandler.sendStallOK(stallName);
		}
		
		private function setStallShopData(userId:Number):void
		{
			StallShopDataSocketHandler.sendInitialData(userId);
		}
		
		public function sendStallShopBuy():void
		{
			StallShopBuySocketHandler.sendShopBuy(stallModule.userId,stallModule.stallShopInfo.shoppingBuyVector);
		}
		
		public function sendStallShopSale():void
		{
			StallShopSaleSocketHandler.sendShopSale(stallModule.userId,GlobalData.clientBagInfo.stallShoppingSaleVector);
		}
		
		public function sendStallShopMessage(messageContent:String):void
		{
			StallShopMessageSocketHandler.sendStallShopMessage(stallModule.userId,messageContent);
		}
		
		public function setData():void
		{
			proxy.setStallData();
		}
		
		public function get proxy():StallProxy
		{
			return facade.retrieveProxy(StallProxy.NAME) as StallProxy;
		}
		
		public function get stallModule():StallModule
		{
			return viewComponent as StallModule;
		}
		
		public function dispose():void
		{
			viewComponent  = null;
		}
	}
}