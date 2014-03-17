package sszt.scene.socketHandlers.clubPointWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.clubPointWar.scoreInfo.ClubPointWarScoreItemInfo;
	
	public class ClubPointWarRankSocketHandler extends BaseSocketHandler
	{
		public function ClubPointWarRankSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_POINT_RANK;
		}
		
		override public function handlePackage():void
		{
			var tmpList:Array = [];
			var tmpInfo:ClubPointWarScoreItemInfo;
			var len:int = _data.readInt();
			for(var i:int = 0;i < len;i++)
			{
				tmpInfo = new ClubPointWarScoreItemInfo();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.playerLevel = _data.readInt();
				tmpInfo.clubName = _data.readString();
				tmpInfo.career = _data.readInt();
				tmpInfo.killCount = _data.readInt();
				tmpInfo.playerScore = _data.readInt();
				tmpInfo.clubRankNum = _data.readInt();
				tmpInfo.clubContribute = tmpInfo.playerScore/10 + (11 - tmpInfo.clubRankNum)*10;
				if(tmpInfo.clubRankNum == 0)
				{
					tmpInfo.clubContribute = 0;
				}
				else if(tmpInfo.clubContribute > 300)
				{
					tmpInfo.clubContribute = 300;
				}	
				tmpList.push(tmpInfo);
			}
			
			sceneModule.clubPointWarInfo.clubPointWarScoreInfo.itemInfoList = tmpList;
			sceneModule.clubPointWarInfo.clubPointWarScoreInfo.update();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_POINT_RANK);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}