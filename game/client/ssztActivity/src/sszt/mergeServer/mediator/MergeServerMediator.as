package sszt.mergeServer.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.mergeServer.MergeServerModule;
	import sszt.mergeServer.components.MergeServerPanel;
	import sszt.mergeServer.event.MergeServerMediatorEvent;
	import sszt.ui.container.MAlert;
	
	public class MergeServerMediator extends Mediator
	{
		public static const NAME:String = "mergeServerMediator";
		
		public function MergeServerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				MergeServerMediatorEvent.MERGE_SERVER_START,
				MergeServerMediatorEvent.MERGE_SERVER_DISPOSE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MergeServerMediatorEvent.MERGE_SERVER_START:
					showMainPanel();
					break;
				case MergeServerMediatorEvent.MERGE_SERVER_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function showMainPanel():void
		{
			if(!module.mainPanel)
			{
				module.mainPanel = new MergeServerPanel();
				GlobalAPI.layerManager.addPanel(module.mainPanel);
				module.mainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
			}
		}
		
		private function mainPanelCloseHandler(event:Event):void
		{
			module.mainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
			module.mainPanel = null;
		}
		
		public function get module():MergeServerModule
		{
			return viewComponent as MergeServerModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}