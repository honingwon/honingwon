package sszt.pvp.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.pvp.PVPModule;
	import sszt.pvp.components.PVP1Panel;
	import sszt.pvp.components.PVPCluePanel;
	import sszt.pvp.components.PVPResultPanel;
	import sszt.pvp.events.PVPMediatorEvent;
	
	public class PVPMediator extends Mediator
	{
		public static const NAME:String = "pvpMediator";
		
		public function PVPMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				PVPMediatorEvent.PVP_MEDIATOR_START,
				PVPMediatorEvent.PVP_MEDIATOR_DISPOSE,
				PVPMediatorEvent.PVP_RESULT_PANEL_INIT,
				PVPMediatorEvent.PVP_CLUE_PANEL_INIT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case PVPMediatorEvent.PVP_MEDIATOR_START:
					initPVPPanel(notification.getBody());
					break;
				case PVPMediatorEvent.PVP_MEDIATOR_DISPOSE:
					dispose();
					break;
				case PVPMediatorEvent.PVP_RESULT_PANEL_INIT:
					initPVPResultPanel(notification.getBody());
					break;
				case PVPMediatorEvent.PVP_CLUE_PANEL_INIT:
					initPVPCluePanel(notification.getBody());
					break;
			}
		}
		
		private function initPVPPanel(data:Object):void
		{
			if(pvpModule.pvp1Panel == null)
			{
				pvpModule.pvp1Panel = new PVP1Panel(this);
				GlobalAPI.layerManager.addPanel(pvpModule.pvp1Panel);
				pvpModule.pvp1Panel.addEventListener(Event.CLOSE,pvp1CloseHandler);
			}
		}
		
		private function pvp1CloseHandler(evt:Event):void
		{
			if(pvpModule.pvp1Panel)
			{
				pvpModule.pvp1Panel.removeEventListener(Event.CLOSE,pvp1CloseHandler);
				pvpModule.pvp1Panel = null;
				pvpModule.dispose();
			}
		}
		/**
		 * PVPResultPanel
		 * @param data
		 * 
		 */
		private function initPVPResultPanel(data:Object):void
		{
			if(pvpModule.pvpResultPanel == null)
			{
				pvpModule.pvpResultPanel = new PVPResultPanel(data);
				GlobalAPI.layerManager.addPanel(pvpModule.pvpResultPanel);
				pvpModule.pvpResultPanel.addEventListener(Event.CLOSE,pvpReCloseHandler);
			}
			else
			{
				pvpModule.pvpResultPanel.removeEventListener(Event.CLOSE,pvpReCloseHandler);
				pvpModule.pvpResultPanel = null;
				pvpModule.dispose();
			}
		}
		
		private function pvpReCloseHandler(evt:Event):void
		{
			if(pvpModule.pvpResultPanel)
			{
				pvpModule.pvpResultPanel.removeEventListener(Event.CLOSE,pvpReCloseHandler);
				pvpModule.pvpResultPanel = null;
				pvpModule.dispose();
			}
		}
		
		/**
		 *  PVPCluePanel
		 * @param data
		 * 
		 */
		private function initPVPCluePanel(data:Object):void
		{
			if(pvpModule.pvpCluePanel == null)
			{
				pvpModule.pvpCluePanel = new PVPCluePanel();
				GlobalAPI.layerManager.addPanel(pvpModule.pvpCluePanel);
				pvpModule.pvpCluePanel.addEventListener(Event.CLOSE,pvpCluCloseHandler);
			}
			else
			{
				pvpModule.pvpCluePanel.removeEventListener(Event.CLOSE,pvpCluCloseHandler);
				pvpModule.pvpCluePanel.dispose();
				pvpModule.pvpCluePanel = null;
				pvpModule.dispose();
			}
		}
		
		private function pvpCluCloseHandler(evt:Event):void
		{
			if(pvpModule.pvpCluePanel)
			{
				pvpModule.pvpCluePanel.removeEventListener(Event.CLOSE,pvpCluCloseHandler);
				pvpModule.pvpCluePanel.dispose();
				pvpModule.pvpCluePanel = null;
				pvpModule.dispose();
			}
		}
		
		public function get pvpModule():PVPModule
		{
			return viewComponent as PVPModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}