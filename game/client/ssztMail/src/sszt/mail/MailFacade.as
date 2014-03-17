package sszt.mail
{
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.mail.command.MailEndCommand;
	import sszt.mail.command.MailStartCommand;
	import sszt.mail.event.MailMediatorEvent;
	import sszt.mail.mediator.MailMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class MailFacade extends Facade
	{
		private var _key:String;
		private var _mailModule:MailModule;
		public function MailFacade(key:String)
		{
			super(key);
			_key = key;
		}
		
		public static function getInstance(key:String):MailFacade
		{
			if(!instanceMap[key])
			{
				instanceMap[key] = new MailFacade(key);
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(MailMediatorEvent.MAILSTARTCOMMAND,MailStartCommand);
			registerCommand(MailMediatorEvent.MAILENDCOMMAND,MailEndCommand);
		}
		
		public function startup(module:MailModule,data:Object):void
		{
			_mailModule = module;
			sendNotification(MailMediatorEvent.MAILSTARTCOMMAND,module);
			var value:ToMailData = data as ToMailData;
			if(value.isMainPanel)
			{
				if(value.nick != "")
				{
					sendNotification(MailMediatorEvent.SHOWWRITEPANEL,{nick:value.nick,serverId:value.serverId});
				}else
				{
					sendNotification(MailMediatorEvent.MAILSTART);
				}
			}
		}
		
		public function dispose():void
		{
			sendNotification(MailMediatorEvent.MAILENDCOMMAND);
			sendNotification(MailMediatorEvent.MAILDISPOSE);
			removeCommand(MailMediatorEvent.MAILSTARTCOMMAND);
			removeCommand(MailMediatorEvent.MAILENDCOMMAND);
			_mailModule = null;
			instanceMap[_key] = null;
		}
		
	}
}