package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.war.ClubWarItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubWarEnemyQueryListSockethandler extends BaseSocketHandler
	{
		public function ClubWarEnemyQueryListSockethandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_WAR_ENEMY_INIT;
		}
		
		override public function handlePackage():void
		{
			var tmpList:Array = [];
			var tmpItemInfo:ClubWarItemInfo;
			var total:int = _data.readInt();
			var len:int = _data.readInt();
			for(var i:int = 0;i < len;i++)
			{
				tmpItemInfo = new ClubWarItemInfo();
				tmpItemInfo.clubListId = _data.readNumber();
				tmpItemInfo.clubName = _data.readString();
				tmpItemInfo.masterName = _data.readString();
				tmpItemInfo.level = _data.readInt();
				tmpItemInfo.clubCurrentNum = _data.readInt();
				tmpItemInfo.clubTotalNum = _data.readInt();
//				tmpItemInfo.warState = _data.readInt();
				tmpList.push(tmpItemInfo);
			}
			if(clubModule.clubInfo.clubWarInfo)
			{
				clubModule.clubInfo.clubWarInfo.enemyListTotalNum = total;
				clubModule.clubInfo.clubWarInfo.setWarEnemyList(tmpList);
			}
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function sendQuery(page:int,pagesize:int = 11,name:String = ""):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_WAR_ENEMY_INIT);
			pkg.writeShort(page);
			pkg.writeByte(pagesize);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}