package sszt.mail.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mail.MailModule;
	
	public class MailDeleteSocketHandler extends BaseSocketHandler
	{
		public function MailDeleteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public function get module():MailModule
		{
			return _handlerData as MailModule;
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAIL_DELETE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			if(_data.readBoolean())
			{
				GlobalData.mailInfo.removeItem(id);
			}
//			var len:int = _data.readInt();
//			for(var i:int = 0;i<_data.length;i++)
//			{
//				GlobalData.mailInfo.removeItem(_data.readNumber());
//			}
			
			handComplete();
		}
		
		public static function sendDelete(mailId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MAIL_DELETE);
			pkg.writeNumber(mailId);
//			pkg.writeInt(data.length);
//			for(var i:int = 0;i<data.length;i++)
//			{
//				pkg.writeNumber(data[i]);
//			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}