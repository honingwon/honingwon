package sszt.openActivity.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.openActivity.OpenActivityModule;
	import sszt.openActivity.components.OpenActivityPanel;
	import sszt.openActivity.events.OpenActivityMediaEvents;
	
	public class OpenActivityMediator extends Mediator
	{
		public static const NAME:String = "openActivityMediator";
		
		public function OpenActivityMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case OpenActivityMediaEvents.OPEN_ACTIVITY_MEDIATOR_START:
					initialView(notification.getBody() as Number);
					break;
				case OpenActivityMediaEvents.OPEN_ACTIVITY_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [OpenActivityMediaEvents.OPEN_ACTIVITY_MEDIATOR_START,
				OpenActivityMediaEvents.OPEN_ACTIVITY_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(tempId:Number):void
		{
			if(activityModule.activityPanel == null)
			{
				activityModule.activityPanel= new OpenActivityPanel(this);
				GlobalAPI.layerManager.addPanel(activityModule.activityPanel);
				activityModule.activityPanel.addEventListener(Event.CLOSE,activityPanelCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() == activityModule.activityPanel)
				{
					activityModule.activityPanel.dispose();
				}
				else
				{
					activityModule.activityPanel.setToTop();
				}
			}
		}
		
		public function get activityModule():OpenActivityModule
		{
			return viewComponent as OpenActivityModule;
		}
		
		private function activityPanelCloseHandler(evt:Event):void
		{
			if(activityModule.activityPanel)
			{
				activityModule.activityPanel.removeEventListener(Event.CLOSE,activityPanelCloseHandler);
				activityModule.activityPanel = null;
				activityModule.dispose();
			}
		}  
		
		public function dispose():void
		{
			viewComponent = null;
		}
	} 
}