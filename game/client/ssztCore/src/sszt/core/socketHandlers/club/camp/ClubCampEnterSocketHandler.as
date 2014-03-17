package sszt.core.socketHandlers.club.camp
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubCampEnterSocketHandler extends BaseSocketHandler
	{
		public function ClubCampEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ENTER_SCENCE;
		}
		
		override public function handlePackage():void
		{
		}
		
		public static function send():void
		{
			if(GlobalData.currentMapId >= 1001 && GlobalData.currentMapId <= 1999)
			{				
				var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ENTER_SCENCE);
				GlobalAPI.socketManager.send(pkg);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveCurrentScene"));
			}
		}
	}
}