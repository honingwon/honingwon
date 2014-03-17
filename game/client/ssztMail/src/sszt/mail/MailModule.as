package sszt.mail
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.module.BaseModule;
	import sszt.events.FriendModuleEvent;
	import sszt.events.MailModuleEvent;
	import sszt.interfaces.module.IModule;
	import sszt.mail.component.MailPanel;
	import sszt.mail.socket.MailSetSocketHandler;
	import sszt.module.ModuleEventDispatcher;
	
	public class MailModule extends BaseModule
	{
		public var mailPanel:MailPanel;
		public var facade:MailFacade;

		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			GlobalData.mailIcon.mailOpen = true;
			MailSetSocketHandler.add(this);
			facade = MailFacade.getInstance(String(moduleId));
			facade.startup(this,data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			if(mailPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel() != mailPanel)
				{
					mailPanel.setToTop();
				}
				else
				{
					if(data && ToMailData(data).forciblyOpen)
					{
						
					}
					else
					{
						mailPanel.dispose();
					}
				}
			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addMailEventListener(MailModuleEvent.NEW_MAIL,newMailHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			ModuleEventDispatcher.removeMailEventListener(MailModuleEvent.NEW_MAIL,newMailHandler);
		}
		
		private function newMailHandler(evt:MailModuleEvent):void
		{
			mailPanel.load();
		}
		
		override public function get moduleId():int
		{
			return ModuleType.MAIL;	
		}
		
		override public function dispose():void
		{
			if(mailPanel)
			{
				mailPanel.dispose();
				mailPanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			GlobalData.mailIcon.mailOpen = false;
			MailSetSocketHandler.remove();
			super.dispose();
		}
	}
}