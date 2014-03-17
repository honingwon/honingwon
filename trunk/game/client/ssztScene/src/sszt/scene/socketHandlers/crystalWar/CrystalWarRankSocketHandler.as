package sszt.scene.socketHandlers.crystalWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.crystalWar.scoreInfo.CrystalWarScoreItemInfo;
	
	public class CrystalWarRankSocketHandler extends BaseSocketHandler
	{
		public function CrystalWarRankSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CRYSTAL_WAR_RANK;
		}
		
		override public function handlePackage():void
		{
			var tmpList:Array = [];
			var tmpInfo:CrystalWarScoreItemInfo;
			var len:int = _data.readInt();
			for(var i:int = 0;i < len;i++)
			{
				tmpInfo = new CrystalWarScoreItemInfo();
				tmpInfo.userId = _data.readNumber();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.playerLevel = _data.readInt();
				tmpInfo.career = _data.readInt();
				tmpInfo.killCount = _data.readInt();
				tmpInfo.playerScore = _data.readInt();
				tmpInfo.campName = tmpInfo.serverId.toString();
				tmpList.push(tmpInfo);
			}
			
			sceneModule.crystalWarInfo.crystalWarScoreInfo.itemInfoList = tmpList;
			sceneModule.crystalWarInfo.crystalWarScoreInfo.update();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CRYSTAL_WAR_RANK);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}