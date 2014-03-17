package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	import sszt.scene.components.tradeDirect.TradeDirectPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.TradeAcceptSocketHandler;
	import sszt.scene.socketHandlers.TradeCancelSocketHandler;
	import sszt.scene.socketHandlers.TradeCopperSocketHandler;
	import sszt.scene.socketHandlers.TradeLockSocketHandler;
	import sszt.scene.socketHandlers.TradeRequestSocketHandler;
	import sszt.scene.socketHandlers.TradeSureSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class TradeDirectMediator extends Mediator
	{
		public static const NAME:String = "TradeDirectMediator";
		
		public function TradeDirectMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SEND_TRADEDIRECT,
//				SceneMediatorEvent.GET_TRADEDIRECT,
				SceneMediatorEvent.SHOW_TRADEDIRECT,
				SceneMediatorEvent.SELF_BEHIT,
				SceneMediatorEvent.SELF_HIT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SEND_TRADEDIRECT:
					sendTradeDirect(Number(notification.getBody()));
					break;
				case SceneMediatorEvent.GET_TRADEDIRECT:
					var data:Object = notification.getBody();
					getTradeDirect(data["id"],data["nick"],data["serverId"]);
					break;
				case SceneMediatorEvent.SHOW_TRADEDIRECT:
					var data1:Object = notification.getBody();
					showTradeDirectPanel(data1["id"],data1["nick"],data1["serverId"]);
//					showTradeDirectPanel(data1["id"]);
					break;
				case SceneMediatorEvent.SELF_BEHIT:
					selfAttackState();
					break;
				case SceneMediatorEvent.SELF_HIT:
					selfAttackState();
					break;
			}
		}
		
		private function sendTradeDirect(id:Number):void
		{
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.crossServerForbidAction"));
				return;
			}
			TradeRequestSocketHandler.sendTrade(id);
		}
		
		private function getTradeDirect(id:Number,nick:String,serverId:int):void
		{
			if(sceneModule.getTradeAlert != null)
			{
				sceneModule.getTradeAlert.dispose();
			}
//			sceneModule.getTradeAlert = MTimerAlert.show(15,MAlert.REFUSE,"[" + serverId + "]" + nick + "邀请你进行交易，是否同意?",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,getTradeAlertCloseHandler);
			sceneModule.getTradeAlert = MTimerAlert.show(15,MAlert.REFUSE, nick + LanguageManager.getWord("ssztl.scene.inviteTrade"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,getTradeAlertCloseHandler);
			function getTradeAlertCloseHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.AGREE)
				{
					TradeAcceptSocketHandler.sendAccept(true,id);
				}
				else
				{
					TradeAcceptSocketHandler.sendAccept(false,id);
				}
				sceneModule.getTradeAlert = null;
			}
		}
		
		private function showTradeDirectPanel(id:Number,nick:String=null,serverId:int=0):void
		{
			if(sceneModule.tradeDirectPanel == null)
			{
				sceneModule.tradeDirectPanel = new TradeDirectPanel(this,id,nick,serverId);
				sceneModule.tradeDirectPanel.addEventListener(Event.CLOSE,tradeDirectPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.tradeDirectPanel);
			}
		}
		private function tradeDirectPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.tradeDirectPanel)
			{
				sceneModule.tradeDirectPanel.removeEventListener(Event.CLOSE,tradeDirectPanelCloseHandler);
				sceneModule.tradeDirectPanel = null;
			}
		}
		private function selfAttackState():void
		{
			if(sceneModule.tradeDirectPanel)
			{
				sceneModule.sceneInfo.tradeDirectInfo.doClear();
				sceneModule.tradeDirectPanel.dispose();
			}
		}
		
		public function selfLock():void
		{
			TradeLockSocketHandler.sendLock();
			sceneInfo.tradeDirectInfo.setSelfLock(true);
		}
		public function selfTrade():void
		{
			TradeSureSocketHandler.send();
			sceneInfo.tradeDirectInfo.setSelfSure(true);
		}
		public function selfCancel():void
		{
			TradeCancelSocketHandler.send();
			sceneInfo.tradeDirectInfo.doCancel(0);
//			sceneInfo.tradeDirectInfo.doCancel();
		}
		public function selfSetCopper(value:int):void
		{
			TradeCopperSocketHandler.sendCopper(value);
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
	}
}