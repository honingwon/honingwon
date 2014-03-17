package sszt.mail.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.mail.MailClearSocketHandler;

	public class MailSetSocketHandler
	{				
		public static function add(handlerData:Object=null):void
		{
			//邮件
			GlobalAPI.socketManager.addSocketHandler(new MailSendSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new MailReceiveSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new MailReadSocketHandler(handlerData));
			GlobalAPI.socketManager.addSocketHandler(new MailDeleteSocketHandler(handlerData));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAIL_DELETE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAIL_READ);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAIL_RECEIVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAIL_SEND);
		}
	}
}