package sszt.mail.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mail.MailModule;
	
	public class MailReadSocketHandler extends BaseSocketHandler
	{
		public function MailReadSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAIL_READ;
		}
		
		override public function handlePackage():void
		{
			var num:Number = _data.readNumber();
			if(_data.readBoolean())
			{
				GlobalData.mailInfo.change(num);
			}			
			handComplete();
		}
		
		public function get module():MailModule
		{
			return _handlerData as MailModule;
		}
		
		public static function sendRead(mailId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MAIL_READ);
			pkg.writeNumber(mailId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}