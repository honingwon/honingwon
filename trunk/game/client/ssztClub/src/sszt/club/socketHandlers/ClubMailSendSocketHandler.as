package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubMailSendSocketHandler extends BaseSocketHandler
	{
		public function ClubMailSendSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAIL_GUILD;
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				clubModule.clubInfo.sendMailSuccess();
			}
			
			handComplete();
		}
		
		public static function sendMail(title:String,context:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MAIL_GUILD);
			pkg.writeString(title);
			pkg.writeString(context);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}