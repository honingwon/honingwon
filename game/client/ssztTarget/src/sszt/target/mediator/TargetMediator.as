package sszt.target.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.events.TargetMediaEvents;
	import sszt.target.TargetModule;
	import sszt.target.components.TargetPanel;
	
	public class TargetMediator extends Mediator
	{
		public static const NAME:String = "targetMediator";
		
		public function TargetMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case TargetMediaEvents.TARGET_MEDIATOR_START:
					initialView(notification.getBody() as ToTargetData);
					break;
				case TargetMediaEvents.TARGET_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [TargetMediaEvents.TARGET_MEDIATOR_START,
				TargetMediaEvents.TARGET_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(toTD:ToTargetData):void
		{
			if(targetModule.targetPanel == null)
			{
				targetModule.targetPanel=new TargetPanel(this,toTD);
				GlobalAPI.layerManager.addPanel(targetModule.targetPanel);
				targetModule.targetPanel.addEventListener(Event.CLOSE,templatePanelCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() == targetModule.targetPanel)
				{
					targetModule.targetPanel.dispose();
				}
				else
				{
					targetModule.targetPanel.setToTop();
				}
			}
		}
		
		public function get targetModule():TargetModule
		{
			return viewComponent as TargetModule;
		}
		
		private function templatePanelCloseHandler(evt:Event):void
		{
			if(targetModule.targetPanel)
			{
				targetModule.targetPanel.removeEventListener(Event.CLOSE,templatePanelCloseHandler);
				targetModule.targetPanel = null;
				targetModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}