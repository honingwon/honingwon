package sszt.core.socketHandlers.mail
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mail.MailItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class MailUpdateSocketHandler extends BaseSocketHandler
	{
		public function MailUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAIL_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var unRead:Boolean = false;
			var len:int=_data.readShort();
			var mails:Array = [];
			for(var i:int=0;i<len;i++)
			{
				var mail:MailItemInfo = new MailItemInfo(_data);
				if(!mail.isRead) unRead = true;
				mails.push(mail);					
			}
			GlobalData.mailInfo.updates(mails);
			if(unRead)
			{
				var count:int = GlobalData.mailInfo.getUnReadCount();
				GlobalData.mailIcon.show(count);
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.MAIL_REFRESH));
			}
			
			handComplete();
		}
	}
}