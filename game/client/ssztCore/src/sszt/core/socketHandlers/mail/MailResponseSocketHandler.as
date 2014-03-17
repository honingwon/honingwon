package sszt.core.socketHandlers.mail
{
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.MailIcon;
	import sszt.module.ModuleEventDispatcher;
	
	public class MailResponseSocketHandler extends BaseSocketHandler
	{
		public function MailResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
//			return ProtocolType.MAIL_RESPONSE;
			return 0;
		}
		
		override public function handlePackage():void
		{
			GlobalData.mailIcon.move(910,131);
//			GlobalData.mailIcon.show();
			handComplete();
		}
	}
}