package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubTransferResponseSocketHandler extends BaseSocketHandler
	{
		public function ClubTransferResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_TRANSFER_RESPONSE;
		}
		
		public static function send(result:Boolean,userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_TRANSFER_RESPONSE);
			pkg.writeBoolean(result);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}