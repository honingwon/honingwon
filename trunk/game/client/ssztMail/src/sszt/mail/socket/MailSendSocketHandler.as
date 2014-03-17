package sszt.mail.socket
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mail.MailModule;
	
	public class MailSendSocketHandler extends BaseSocketHandler
	{
		public function MailSendSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAIL_SEND;
		}
		
		override public function handlePackage():void
		{
			GlobalData.mailInfo.updateSuccess(_data.readBoolean());
			
			handComplete();
		}
		
		public function get module():MailModule
		{
			return _handlerData as MailModule;
		}
		
		public static function sendMail(serverId:int,nickName:String,title:String,context:String,copper:int,len:int,data:Object = null):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MAIL_SEND);
//			pkg.writeShort(serverId);
			pkg.writeString(nickName);
			pkg.writeString(title);
			pkg.writeString(context);
			pkg.writeInt(copper);
			pkg.writeInt(len);
			for(var i:int = 0;i<len;i++)
			{
				pkg.writeInt(data[i]);
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}