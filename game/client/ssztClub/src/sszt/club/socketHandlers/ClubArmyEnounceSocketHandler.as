package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubArmyEnounceSocketHandler extends BaseSocketHandler
	{
		public function ClubArmyEnounceSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ARMY_ENOUNCE;
		}
		
		public static function send(enounce:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ARMY_ENOUNCE);
			pkg.writeString(enounce);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}