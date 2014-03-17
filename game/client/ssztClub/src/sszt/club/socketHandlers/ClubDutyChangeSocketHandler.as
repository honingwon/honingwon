package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubDutyChangeSocketHandler extends BaseSocketHandler
	{
		public function ClubDutyChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_DUTY_CHANGE;
		}
		
		public static function send(id:Number,duty:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_DUTY_CHANGE);
			pkg.writeNumber(id);
			pkg.writeByte(duty);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}