package sszt.mail.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mail.MailModule;
	
	public class MailReceiveSocketHandler extends BaseSocketHandler
	{
		public function MailReceiveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAIL_RECEIVE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var attachFetch:int = _data.readInt();
			GlobalData.mailInfo.changeAttach(id,attachFetch);
			
			handComplete();
		}
		
		public function get module():MailModule
		{
			return _handlerData as MailModule;
		}
		
		public static function sendReceive(id:Number,type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MAIL_RECEIVE);
			pkg.writeNumber(id);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}