package sszt.mail.mediator
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.mail.MailInfo;
	import sszt.core.data.mail.MailItemInfo;
	import sszt.mail.MailModule;
	import sszt.mail.component.MailPanel;
	import sszt.mail.event.MailMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MailMediator extends Mediator
	{
		public static const NAME:String = "mailMediator";
		
		public function MailMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get mailModule():MailModule
		{
			return viewComponent as MailModule;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				MailMediatorEvent.MAILSTART,
				MailMediatorEvent.SHOWWRITEPANEL,
				MailMediatorEvent.MAILDISPOSE,
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case MailMediatorEvent.MAILSTART:
					initMail();
					break;
				case MailMediatorEvent.SHOWWRITEPANEL:
					showWrite(notification.getBody());
					break;
				case MailMediatorEvent.MAILDISPOSE:
					dispose();
					break;
			}
		}
				
		public function initMail():void
		{
			if(mailModule.mailPanel == null)
			{
				mailModule.mailPanel = new MailPanel(this);
				GlobalAPI.layerManager.addPanel(mailModule.mailPanel);
				mailModule.mailPanel.addEventListener(Event.CLOSE,mailPanelCloseHandler);
			}
		}
		
		private function mailPanelCloseHandler(evt:Event):void
		{
			if(mailModule.mailPanel)
			{
				mailModule.mailPanel.removeEventListener(Event.CLOSE,mailPanelCloseHandler);
				mailModule.mailPanel = null;
				mailModule.dispose();
			}
		}
		
		public function showWritePanel(serverId:int,nick:String = ""):void
		{
			mailModule.mailPanel.showWritePanel(serverId,nick);
		}
		
		public function showReadPanel(item:MailItemInfo):void
		{
			mailModule.mailPanel.showReadPanel(item);
		}
					
		private function showWrite(obj:Object):void
		{
			initMail();
			var serverId:int = int(obj.serverId);
			if(serverId == 0)serverId = GlobalData.selfPlayer.serverId;
			showWritePanel(serverId,String(obj.nick));
		}
		
		public function getMailList():void
		{
			mailModule.mailPanel.load();
		}
		
		public function closeMailSystem():void
		{
			mailModule.dispose();
		}
		
		public function clearReadPanel():void
		{
			mailModule.mailPanel.clearReadPanel();
		}
		
		public function dispose():void
		{
			viewComponent = null;	
		}
	}
}