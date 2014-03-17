package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class ChallengeNextBossSocketHandler extends BaseSocketHandler
	{
		public function ChallengeNextBossSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
		 	return ProtocolType.CHALLENGE_NEXT_BOSS;	
		}
		
		override public function handlePackage():void
		{
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		/**
		 * 进入试炼副本
		 * @param missionId 试炼序列号id 
		 * 
		 */		
		public static function send(missionId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CHALLENGE_NEXT_BOSS);
			pkg.writeInt(missionId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}