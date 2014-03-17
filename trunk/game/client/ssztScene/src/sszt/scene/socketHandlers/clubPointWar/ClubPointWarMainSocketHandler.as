package sszt.scene.socketHandlers.clubPointWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarClubItemInfo;
	
	public class ClubPointWarMainSocketHandler extends BaseSocketHandler
	{
		public function ClubPointWarMainSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_POINT_SCENE_INFO;
		}
		
		override public function handlePackage():void
		{
			var tmpClubInfoList:Array = [];
			var tmpClubInfo:ClubPointWarClubItemInfo;
			var len:int = _data.readInt();
			for(var i:int = 0;i < len;i++)
			{
				tmpClubInfo = new ClubPointWarClubItemInfo();
				tmpClubInfo.rankNum = _data.readInt();
				tmpClubInfo.clubName = _data.readString();
				tmpClubInfo.clubScore = _data.readInt();
				tmpClubInfoList.push(tmpClubInfo);
			}
			if(!sceneModule || !sceneModule.clubPointWarInfo || !sceneModule.clubPointWarInfo.clubPointWarMainInfo)return;
			sceneModule.clubPointWarInfo.clubPointWarMainInfo.itemInfoList = tmpClubInfoList;
			sceneModule.clubPointWarInfo.clubPointWarMainInfo.update();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_POINT_SCENE_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}