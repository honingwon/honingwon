package sszt.core.socketHandlers.mail
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MailClearSocketHandler extends BaseSocketHandler
	{
		public function MailClearSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAIL_CLEAR;
		}
		
//		public static function sendClear(data:Vector.<Number>):void
		public static function sendClear(data:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MAIL_CLEAR);
			pkg.writeShort(data.length);
			for(var i:int = 0;i<data.length;i++)
			{
				pkg.writeNumber(data[i]);
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}