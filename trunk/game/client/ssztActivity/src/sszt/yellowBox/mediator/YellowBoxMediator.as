package sszt.yellowBox.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.yellowBox.YellowBoxModule;
	import sszt.yellowBox.components.YellowBoxPanel;
	import sszt.yellowBox.events.YellowBoxMediaEvents;
	
	public class YellowBoxMediator extends Mediator
	{
		public static const NAME:String = "yellowBoxMediator";
		
		public function YellowBoxMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case YellowBoxMediaEvents.YELLOW_MEDIATOR_START:
					initialView(notification.getBody() as Number);
					break;
				case YellowBoxMediaEvents.YELLOW_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [YellowBoxMediaEvents.YELLOW_MEDIATOR_START,
				YellowBoxMediaEvents.YELLOW_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(tempId:Number):void
		{
			if(yellowBoxModule.yellowBoxPanel == null)
			{
				yellowBoxModule.yellowBoxPanel=new YellowBoxPanel(this);
				GlobalAPI.layerManager.addPanel(yellowBoxModule.yellowBoxPanel);
				yellowBoxModule.yellowBoxPanel.addEventListener(Event.CLOSE,templatePanelCloseHandler);
			}
		}
		
		public function get yellowBoxModule():YellowBoxModule
		{
			return viewComponent as YellowBoxModule;
		}
		
		private function templatePanelCloseHandler(evt:Event):void
		{
			if(yellowBoxModule.yellowBoxPanel)
			{
				yellowBoxModule.yellowBoxPanel.removeEventListener(Event.CLOSE,templatePanelCloseHandler);
				yellowBoxModule.yellowBoxPanel = null;
				yellowBoxModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}