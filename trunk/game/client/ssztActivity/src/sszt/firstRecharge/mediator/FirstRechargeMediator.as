package sszt.firstRecharge.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.firstRecharge.FirstRechargeModule;
	import sszt.firstRecharge.components.FirstRechargePanel;
	import sszt.firstRecharge.events.FirstRechargeMediaEvents;
	
	public class FirstRechargeMediator extends Mediator
	{
		public static const NAME:String = "firstRechargeMediator";
		
		public function FirstRechargeMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case FirstRechargeMediaEvents.FIRSTRECH_MEDIATOR_START:
					initialView(notification.getBody() as Number);
					break;
				case FirstRechargeMediaEvents.FIRSTRECH_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [FirstRechargeMediaEvents.FIRSTRECH_MEDIATOR_START,
				FirstRechargeMediaEvents.FIRSTRECH_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(tempId:Number):void
		{
			if(firstRechargeModule.firstRechargePanel == null)
			{
				firstRechargeModule.firstRechargePanel=new FirstRechargePanel(this);
				GlobalAPI.layerManager.addPanel(firstRechargeModule.firstRechargePanel);
				firstRechargeModule.firstRechargePanel.addEventListener(Event.CLOSE,templatePanelCloseHandler);
			}
		}
		
		public function get firstRechargeModule():FirstRechargeModule
		{
			return viewComponent as FirstRechargeModule;
		}
		
		private function templatePanelCloseHandler(evt:Event):void
		{
			if(firstRechargeModule.firstRechargePanel)
			{
				firstRechargeModule.firstRechargePanel.removeEventListener(Event.CLOSE,templatePanelCloseHandler);
				firstRechargeModule.firstRechargePanel = null;
				firstRechargeModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}