package sszt.swordsman.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToSwordsmanData;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.swordsman.SwordsmanModule;
	import sszt.swordsman.components.SwordsmanPanel;
	
	public class SwordsmanMediator extends Mediator
	{
		public static const NAME:String = "swordsmanMediator";
		
		public function SwordsmanMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case SwordsmanMediaEvents.TEMPLATE_MEDIATOR_START:
					initialView(notification.getBody() as ToSwordsmanData);
					break;
				case SwordsmanMediaEvents.TEMPLATE_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [SwordsmanMediaEvents.TEMPLATE_MEDIATOR_START,
				SwordsmanMediaEvents.TEMPLATE_MEDIATOR_DISPOSE
			];
		}
		
		private function initialView(toSD:ToSwordsmanData):void
		{
			if(swordsmanModule.swordsmanPanel == null)
			{
				swordsmanModule.swordsmanPanel=new SwordsmanPanel(this,toSD.tabIndex);
				GlobalAPI.layerManager.addPanel(swordsmanModule.swordsmanPanel);
				swordsmanModule.swordsmanPanel.addEventListener(Event.CLOSE,swordsmanPanelCloseHandler);
			}
		}
		
		public function get swordsmanModule():SwordsmanModule
		{
			return viewComponent as SwordsmanModule;
		}
		
		private function swordsmanPanelCloseHandler(evt:Event):void
		{
			if(swordsmanModule.swordsmanPanel)
			{
				swordsmanModule.swordsmanPanel.removeEventListener(Event.CLOSE,swordsmanPanelCloseHandler);
				swordsmanModule.swordsmanPanel = null;
				swordsmanModule.dispose();
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}