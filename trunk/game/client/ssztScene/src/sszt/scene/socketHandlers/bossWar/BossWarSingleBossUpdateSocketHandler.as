package sszt.scene.socketHandlers.bossWar
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class BossWarSingleBossUpdateSocketHandler extends BaseSocketHandler
	{
		public function BossWarSingleBossUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BOSS_WAR_SINGLE_BOSS_UPDATE;
		}
		
		override public function handlePackage():void
		{
//			sceneModule.bossWarInfo.updateSingleBoss(_data.readInt(),_data.readInt());
			var tmpBossId:int = _data.readInt();
			var tmpTime:int = _data.readInt();
			if(sceneModule.bossWarInfo.selectId == tmpBossId)
			{
				sceneModule.bossWarInfo.updateSelect(-1);
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}