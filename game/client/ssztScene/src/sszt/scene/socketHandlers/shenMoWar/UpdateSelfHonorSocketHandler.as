package sszt.scene.socketHandlers.shenMoWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	
	public class UpdateSelfHonorSocketHandler extends BaseSocketHandler
	{
		public function UpdateSelfHonorSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.UPDATE_SELF_HONOR;
		}
		
		override public function handlePackage():void
		{
			var totalHonor:int = _data.readInt();
			var todayHonor:int = _data.readInt();
			var totalKillNum:int = _data.readInt();
			var todayKillNum:int = _data.readInt();
			
			if(sceneModule.shenMoWarInfo.shenMoWarHonorInfo)
			{
				sceneModule.shenMoWarInfo.shenMoWarHonorInfo.todayHonorNum = todayHonor;
				sceneModule.shenMoWarInfo.shenMoWarHonorInfo.todayKillNum = todayKillNum;
				sceneModule.shenMoWarInfo.shenMoWarHonorInfo.totalHonorNum = totalHonor;
				sceneModule.shenMoWarInfo.shenMoWarHonorInfo.totalkillNum = totalKillNum;
				sceneModule.shenMoWarInfo.shenMoWarHonorInfo.updateInfo();
			}
			
			GlobalData.selfPlayer.updateHonor(totalHonor);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.UPDATE_SELF_HONOR);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}