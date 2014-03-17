package sszt.consumTagView.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.consumTagView.ConsumTagViewModule;
	import sszt.consumTagView.components.ConsumTagViewPanel;
	import sszt.consumTagView.events.ConsumTagViewMediaEvents;
	
	public class ConsumTagViewMediator extends Mediator
	{
		public static const NAME:String = "consumTagViewMediator";
		
		public function ConsumTagViewMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case ConsumTagViewMediaEvents.CON_MEDIATOR_START:
					initialView(notification.getBody() as Number);
					break;
				case ConsumTagViewMediaEvents.CON_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [ConsumTagViewMediaEvents.CON_MEDIATOR_START,
				ConsumTagViewMediaEvents.CON_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(tempId:Number):void
		{
			if(consumTagViewModule.consumTagViewPanel == null)
			{
				consumTagViewModule.consumTagViewPanel=new ConsumTagViewPanel(this);
				GlobalAPI.layerManager.addPanel(consumTagViewModule.consumTagViewPanel);
				consumTagViewModule.consumTagViewPanel.addEventListener(Event.CLOSE,templatePanelCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() ==  consumTagViewModule.consumTagViewPanel)
				{
					consumTagViewModule.consumTagViewPanel.dispose();
				}
				else
				{
					consumTagViewModule.consumTagViewPanel.setToTop();
				}
			}
		}
		
		public function get consumTagViewModule():ConsumTagViewModule
		{
			return viewComponent as ConsumTagViewModule;
		}
		
		private function templatePanelCloseHandler(evt:Event):void
		{
			if(consumTagViewModule.consumTagViewPanel)
			{
				consumTagViewModule.consumTagViewPanel.removeEventListener(Event.CLOSE,templatePanelCloseHandler);
				consumTagViewModule.consumTagViewPanel = null;
				consumTagViewModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}