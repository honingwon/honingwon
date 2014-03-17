package sszt.sevenActivity.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.sevenActivity.SevenActivityModule;
	import sszt.sevenActivity.components.SevenActivityPanel;
	import sszt.sevenActivity.events.SevenActivityMediaEvents;
	
	public class SevenActivityMediator extends Mediator
	{
		public static const NAME:String = "sevenActivityMediator";
		
		public function SevenActivityMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case SevenActivityMediaEvents.SEVEN_MEDIATOR_START:
					initialView(notification.getBody() as Number);
					break;
				case SevenActivityMediaEvents.SEVEN_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [SevenActivityMediaEvents.SEVEN_MEDIATOR_START,
				SevenActivityMediaEvents.SEVEN_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(tempId:Number):void
		{
			if(sevenActivityModule.sevenActivityPanel == null)
			{
				sevenActivityModule.sevenActivityPanel=new SevenActivityPanel(this);
				GlobalAPI.layerManager.addPanel(sevenActivityModule.sevenActivityPanel);
				sevenActivityModule.sevenActivityPanel.addEventListener(Event.CLOSE,sevenActivityPanelCloseHandler);
			}
		}
		
		public function get sevenActivityModule():SevenActivityModule
		{
			return viewComponent as SevenActivityModule;
		}
		
		private function sevenActivityPanelCloseHandler(evt:Event):void
		{
			if(sevenActivityModule.sevenActivityPanel)
			{
				sevenActivityModule.sevenActivityPanel.removeEventListener(Event.CLOSE,sevenActivityPanelCloseHandler);
				sevenActivityModule.sevenActivityPanel = null;
				sevenActivityModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}