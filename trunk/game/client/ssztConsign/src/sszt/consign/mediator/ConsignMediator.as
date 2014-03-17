package sszt.consign.mediator
{
	import flash.events.Event;
	
	import sszt.consign.ConsignModule;
	import sszt.consign.components.SearchConsignPanel;
	import sszt.consign.components.popupPanel.YuanBaoPopUpPanel;
	import sszt.consign.components.quickConsign.QuickConsignPanel;
	import sszt.consign.data.ConsignInfo;
	import sszt.consign.data.GoldConsignItem;
	import sszt.consign.events.ConsignMediatorEvents;
	import sszt.consign.socket.BillDealSocketHandler;
	import sszt.consign.socket.BillDeleteSocketHandler;
	import sszt.consign.socket.GoldDealSockectHandler;
	import sszt.consign.socket.GoldListUpdateSocketHandler;
	import sszt.consign.socketHandlers.ConsignAddConsignHandler;
	import sszt.consign.socketHandlers.ConsignAddYuanBaoHandler;
	import sszt.consign.socketHandlers.ConsignBuyHandler;
	import sszt.consign.socketHandlers.ConsignContinueHandler;
	import sszt.consign.socketHandlers.ConsignDeleteConsignHandler;
	import sszt.consign.socketHandlers.ConsignQueryHandler;
	import sszt.consign.socketHandlers.ConsignQuerySelfHandler;
	import sszt.core.data.GlobalAPI;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ConsignMediator extends Mediator
	{
		public static const NAME:String = "consignMediator";
		public function ConsignMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ConsignMediatorEvents.SHOW_SEARCH_PANEL,
				ConsignMediatorEvents.SHOW_QUICKCONSIGN_PANEL,
				ConsignMediatorEvents.CONSIGN_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ConsignMediatorEvents.SHOW_SEARCH_PANEL:
					initialView();
					break;
				case ConsignMediatorEvents.SHOW_QUICKCONSIGN_PANEL:
					showQuickPanel(int(notification.getBody()));
					break;
				case ConsignMediatorEvents.CONSIGN_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		public function initialView():void
		{
			if(module.consignPanel == null)
			{
				module.consignPanel = new SearchConsignPanel(this);
				GlobalAPI.layerManager.addPanel(module.consignPanel);
				module.consignPanel.addEventListener(Event.CLOSE,consignPanelCloseHandlers);
			}
		}
		
		public function consignPanelCloseHandlers(e:Event):void
		{
			if(module.consignPanel)
			{
				module.consignPanel.removeEventListener(Event.CLOSE,consignPanelCloseHandlers);
				module.consignPanel = null;
			}
			if(module && module.consignPanel == null && module.quickPanel == null)
			{
				module.dispose();
			}
		}
		
		
		public function showQuickPanel(index:int):void
		{
			if(module.quickPanel == null)
			{
				module.quickPanel = new QuickConsignPanel(this);
				module.quickPanel.addEventListener(Event.CLOSE,quickPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.quickPanel);
				if(module.assetsComplete)
				{
					module.quickPanel.assetsCompleteHandler();
				}
			}
			module.quickPanel.setIndex(index);
			module.quickPanel.setToTop();
		}
		
		private function quickPanelCloseHandler(evt:Event):void
		{
			if(module && module.quickPanel)
			{
				module.quickPanel.removeEventListener(Event.CLOSE,quickPanelCloseHandler);
				module.quickPanel = null;
			}
			if(module && module.consignPanel == null && module.quickPanel == null)
			{
				module.dispose();
			}
		}
		
		public function sendAddConsign(argPlace:int,argPriceType:int,argPrice:int,argTime:int):void
		{
			ConsignAddConsignHandler.sendAddConsign(argPlace,argPriceType,argPrice,argTime);
		}
		
		public function sendDeleteConsign(argListId:Number,argCurrrentPage:int):void
		{
			ConsignDeleteConsignHandler.sendDelete(argListId,argCurrrentPage);
		}
		
		public function sendBuyConsign(argListId:Number):void
		{
			ConsignBuyHandler.sendBuy(argListId);
		}
		
//		public function sendSearchQuery(type:int,argCareer:int,argQuality:int,argMinLevel:int,argMaxLevel:int,argTypeVector:Vector.<int>,argKeyWord:String,argCurrentPage:int):void
		public function sendSearchQuery(type:int,argCareer:int,argQuality:int,argMinLevel:int,argMaxLevel:int,argTypeVector:Array,argKeyWord:String,argCurrentPage:int):void
		{
			ConsignQueryHandler.sendQuery(type,argCareer,argQuality,argMinLevel,argMaxLevel,argTypeVector,argKeyWord,argCurrentPage);
		}
		
		//再售
		public function sendContinueConsign(argListId:Number):void
		{
			ConsignContinueHandler.sendContinueConsign(argListId);
		}
		
		public function sendGoldConsignQuery():void
		{
			GoldListUpdateSocketHandler.sendYuanbaoListQuery();
//			GoldInfoListSocketHandler.sendGetInfo(1);
//			var list:Vector.<GoldConsignItem> = new Vector.<GoldConsignItem>();
//			for(var i:int =0;i<10;i++)
//			{
//				var item:GoldConsignItem = new GoldConsignItem(i,10,3,0);
//				list.push(item);
//			}
//			module.goldConsignInfo.updates(list);
		}
		/**
		 * 新增货币寄售
		 * coinType:货币类型
		 * count：数量
		 * price：价格
		 * time：有效期
		 */
		public function sendAddYuanBaoConsign(coinType:int, count:int, price:int, time:int,isSendChat:int):void
		{
			ConsignAddYuanBaoHandler.sendAddYuanBaoConsign(coinType, count, price, time,isSendChat);
		}
		
		public function sendGoldDeal(argListId:Number,argGlodNum:int):void
		{
			GoldDealSockectHandler.sendDeal(argListId,argGlodNum);
		}
		
		public function sendBillDeal(argNum:int,argPrice:int,argType:int):void
		{
			BillDealSocketHandler.sendBillDeal(argNum,argPrice,argType);
		}
		
		public function sendDeleteBill(argListId:Number):void
		{
			BillDeleteSocketHandler.sendBill(argListId);
		}
		
		public function get module():ConsignModule
		{
			return viewComponent as ConsignModule;
		}
		
		public function get consignInfo():ConsignInfo
		{
			return module.consignInfo;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}