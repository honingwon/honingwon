package sszt.scene.socketHandlers.clubPointWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;

	public class ClubPointWarPersonalUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubPointWarPersonalUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_POINT_PERSONINFO;
		}
		
		override public function handlePackage():void
		{
			var perKillNum:int = _data.readInt();
			var perScore:int = _data.readInt();
			var clubRankNum:int = _data.readInt();
			var allhonorNum:int = _data.readInt();
			
			if(sceneModule.clubPointWarInfo.clubPointWarMainInfo)
			{
				sceneModule.clubPointWarInfo.clubPointWarMainInfo.personalKillNum = perKillNum;
				sceneModule.clubPointWarInfo.clubPointWarMainInfo.personalScore = perScore;
				sceneModule.clubPointWarInfo.clubPointWarMainInfo.personalContribute = perScore/10 + (11 - clubRankNum) * 10;
				if(sceneModule.clubPointWarInfo.clubPointWarMainInfo.personalContribute > 300)
				{
					sceneModule.clubPointWarInfo.clubPointWarMainInfo.personalContribute = 300;
				}
				sceneModule.clubPointWarInfo.clubPointWarMainInfo.todayHonorNum = perScore/5;
				if(sceneModule.clubPointWarInfo.clubPointWarMainInfo.todayHonorNum > 150)
				{
					sceneModule.clubPointWarInfo.clubPointWarMainInfo.todayHonorNum = 150;
				}
				sceneModule.clubPointWarInfo.clubPointWarMainInfo.allHonorNum = allhonorNum;
				sceneModule.clubPointWarInfo.clubPointWarMainInfo.updateInfo();
			}
			GlobalData.selfPlayer.updateHonor(allhonorNum);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_POINT_PERSONINFO);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}