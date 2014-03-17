package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubLevelUpSocketHandler extends BaseSocketHandler
	{
		public function ClubLevelUpSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_LEVELUP;
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		override public function handlePackage():void
		{
//			if(_data.readBoolean())
//			{
//				clubModule.clubInfo.clubLevelUpInfo.update();
//			}
			QuickTips.show(_data.readString());
			handComplete();
		}
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_LEVELUP);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}