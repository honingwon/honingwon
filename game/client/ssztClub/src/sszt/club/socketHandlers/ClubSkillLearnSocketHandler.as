package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubSkillLearnSocketHandler extends BaseSocketHandler
	{
		public function ClubSkillLearnSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_SKILL_LEARN;
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_SKILL_LEARN);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}