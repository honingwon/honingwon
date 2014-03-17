package sszt.payTagView.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.payTagView.PayTagViewModule;
	import sszt.payTagView.components.PayTagViewPanel;
	import sszt.payTagView.events.PayTagViewMediaEvents;
	
	public class PayTagViewMediator extends Mediator
	{
		public static const NAME:String = "payTagViewMediator";
		
		public function PayTagViewMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case PayTagViewMediaEvents.PTW_MEDIATOR_START:
					initialView(notification.getBody() as Number);
					break;
				case PayTagViewMediaEvents.PTW_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [PayTagViewMediaEvents.PTW_MEDIATOR_START,
				PayTagViewMediaEvents.PTW_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(tempId:Number):void
		{
			if(payTagViewModule.payTagViewPanel == null)
			{
				payTagViewModule.payTagViewPanel=new PayTagViewPanel(this);
				GlobalAPI.layerManager.addPanel(payTagViewModule.payTagViewPanel);
				payTagViewModule.payTagViewPanel.addEventListener(Event.CLOSE,templatePanelCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() ==  payTagViewModule.payTagViewPanel)
				{
					payTagViewModule.payTagViewPanel.dispose();
				}
				else
				{
					payTagViewModule.payTagViewPanel.setToTop();
				}
			}
		}
		
		public function get payTagViewModule():PayTagViewModule
		{
			return viewComponent as PayTagViewModule;
		}
		
		private function templatePanelCloseHandler(evt:Event):void
		{
			if(payTagViewModule.payTagViewPanel)
			{
				payTagViewModule.payTagViewPanel.removeEventListener(Event.CLOSE,templatePanelCloseHandler);
				payTagViewModule.payTagViewPanel = null;
				payTagViewModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}