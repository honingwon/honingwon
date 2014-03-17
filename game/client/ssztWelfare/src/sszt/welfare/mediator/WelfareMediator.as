package sszt.welfare.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.welfare.WelfareModule;
	import sszt.welfare.component.WelfarePanel;
	import sszt.welfare.event.WelfareMediatorEvent;
	
	public class WelfareMediator extends Mediator
	{
		public static const NAME:String="welfareMediator";
		
		public function WelfareMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName()){
				case WelfareMediatorEvent.INIT:
					initWelfare();
					break;
				case WelfareMediatorEvent.DISPOSE:
					dispose();
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [WelfareMediatorEvent.INIT,
				WelfareMediatorEvent.DISPOSE
			];
		}
		
		
		private function initWelfare():void
		{
			if(welfareModule.welfarePanel == null)
			{
				welfareModule.welfarePanel = new WelfarePanel(this);
				GlobalAPI.layerManager.addPanel(welfareModule.welfarePanel);
				welfareModule.welfarePanel.addEventListener(Event.CLOSE,closeHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() == welfareModule.welfarePanel)
				{
					welfareModule.welfarePanel.dispose();
				}
				else
				{
					welfareModule.welfarePanel.setToTop();
				}
			}
		}
		
		private function closeHandler(evt:Event):void
		{
			if(welfareModule.welfarePanel)
			{
				welfareModule.welfarePanel.removeEventListener(Event.CLOSE,closeHandler);
				welfareModule.welfarePanel = null;
				welfareModule.dispose();
			}
		}
		
		public function get welfareModule():WelfareModule
		{
			return viewComponent as WelfareModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}