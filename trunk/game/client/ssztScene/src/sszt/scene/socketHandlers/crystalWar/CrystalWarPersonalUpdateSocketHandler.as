package sszt.scene.socketHandlers.crystalWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.crystalWar.mainInfo.CrystalWarMainInfo;

	public class CrystalWarPersonalUpdateSocketHandler extends BaseSocketHandler
	{
		public function CrystalWarPersonalUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CRYSTAL_WAR_PERSONINFO;
		}
		
		override public function handlePackage():void
		{
			var perKillNum:int = _data.readInt();
			var perScore:int = _data.readInt();
			var todayHonorNum:int = _data.readInt();
			var allhonorNum:int = _data.readInt();
			
			var tmpInfo:CrystalWarMainInfo  = sceneModule.crystalWarInfo.crystalWarMainInfo;
			if(tmpInfo)
			{
				tmpInfo.personalKillNum = perKillNum;
				tmpInfo.personalScore = perScore;
				tmpInfo.todayHonorNum = todayHonorNum;
				tmpInfo.allHonorNum = allhonorNum;
				tmpInfo.updateInfo();
			}
			GlobalData.selfPlayer.updateHonor(allhonorNum);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CRYSTAL_WAR_PERSONINFO);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}