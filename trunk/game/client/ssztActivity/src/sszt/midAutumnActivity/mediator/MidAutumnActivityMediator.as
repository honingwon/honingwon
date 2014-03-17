package sszt.midAutumnActivity.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.midAutumnActivity.MidAutumnActivityModule;
	import sszt.midAutumnActivity.components.MidAutumnActivityPanel;
	import sszt.midAutumnActivity.event.MidAutumnActivityMediatorEvent;
	import sszt.ui.container.MAlert;
	
	public class MidAutumnActivityMediator extends Mediator
	{
		public static const NAME:String = "midAutumnActivityMediator";
		
		public function MidAutumnActivityMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_START,
				MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_DISPOSE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_START:
					showMainPanel();
					break;
				case MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function showMainPanel():void
		{
			if(!module.mainPanel)
			{
				module.mainPanel = new MidAutumnActivityPanel();
				GlobalAPI.layerManager.addPanel(module.mainPanel);
				module.mainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
			}
		}
		
		private function mainPanelCloseHandler(event:Event):void
		{
			module.mainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
			module.mainPanel = null;
		}
		
		public function get module():MidAutumnActivityModule
		{
			return viewComponent as MidAutumnActivityModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}