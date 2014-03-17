package sszt.firebox.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.firebox.FireBoxModule;
	import sszt.firebox.components.FireBoxPanel;
	import sszt.firebox.events.FireBoxMediatorEvent;
	import sszt.firebox.socketHandlers.FireBoxBuildSocketHandler;
	import sszt.firebox.socketHandlers.FireBoxMultiBuildSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class FireBoxMediator extends Mediator
	{
		public static const NAME:String = "FireBoxMediator";
		public function FireBoxMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [FireBoxMediatorEvent.FIREBOX_MEDIATOR_START,
						 FireBoxMediatorEvent.FIREBOX_MEDIATOR_DISPOSE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case FireBoxMediatorEvent.FIREBOX_MEDIATOR_START:
					showFireBoxPanel();
					break;
				case FireBoxMediatorEvent.FIREBOX_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function showFireBoxPanel():void
		{
			if(fireboxModule.fireBoxPanel == null)
			{
				fireboxModule.fireBoxPanel = new FireBoxPanel(this);
				fireboxModule.fireBoxPanel.addEventListener(Event.CLOSE,fireBoxPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(fireboxModule.fireBoxPanel);
			}
		}
		
		private function fireBoxPanelCloseHandler(e:Event):void
		{
			if(fireboxModule.fireBoxPanel)
			{
				fireboxModule.fireBoxPanel.removeEventListener(Event.CLOSE,fireBoxPanelCloseHandler);
				fireboxModule.fireBoxPanel = null;
			}
		}
		
		public function sendFire(argFormulaId:int, composeNum:int):void
		{
			FireBoxBuildSocketHandler.sendFire(argFormulaId,composeNum);
		}
		
		public function sendMultiFire(argFormulaId:int):void
		{
			FireBoxMultiBuildSocketHandler.sendMultiFire(argFormulaId);
		}
		
		public function get fireboxModule():FireBoxModule
		{
			return viewComponent as FireBoxModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}