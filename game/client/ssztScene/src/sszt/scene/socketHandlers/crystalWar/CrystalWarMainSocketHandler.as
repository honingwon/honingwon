package sszt.scene.socketHandlers.crystalWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.crystalWar.mainInfo.CrystalWarClubItemInfo;
	
	public class CrystalWarMainSocketHandler extends BaseSocketHandler
	{
		public function CrystalWarMainSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CRYSTAL_WAR_SCENE_INFO;
		}
		
		override public function handlePackage():void
		{
			var tmpClubInfoList:Array = [];
			var tmpClubInfo:CrystalWarClubItemInfo;
			var len:int = _data.readInt();
			for(var i:int = 0;i < len;i++)
			{
				tmpClubInfo = new CrystalWarClubItemInfo();
//				tmpClubInfo.rankNum = _data.readInt();
				tmpClubInfo.campName = _data.readInt().toString();
				tmpClubInfo.campScore = _data.readInt();
				tmpClubInfoList.push(tmpClubInfo);
			}
			if(!sceneModule || !sceneModule.crystalWarInfo || !sceneModule.crystalWarInfo.crystalWarMainInfo)return;
			sceneModule.crystalWarInfo.crystalWarMainInfo.itemInfoList = tmpClubInfoList;
			sceneModule.crystalWarInfo.crystalWarMainInfo.update();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CRYSTAL_WAR_SCENE_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}