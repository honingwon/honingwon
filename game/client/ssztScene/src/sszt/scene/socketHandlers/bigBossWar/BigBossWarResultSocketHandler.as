package sszt.scene.socketHandlers.bigBossWar
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class BigBossWarResultSocketHandler extends BaseSocketHandler
	{
		public function BigBossWarResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BIG_BOSS_WAR_RESULT;
		}
		
		override public function handlePackage():void
		{
			var sceneModule:SceneModule = _handlerData as SceneModule;
			var isLive:Boolean = _data.readBoolean();
			var itemId:int = _data.readInt();
			sceneModule.bigBossWarInfo.updateResultInfo(isLive,itemId);
			handComplete();
		}
		
		
	}
}