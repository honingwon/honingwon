package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class CopyKillBossSocketHandler extends BaseSocketHandler
	{
		public function CopyKillBossSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
//			return ProtocolType.COPY_KILL_BOSS; 
			return 0;
		}
		
		override public function handlePackage():void
		{
			//击杀boss数加一并且需要暂停连斩的计时	（当收到 清除全部物品 时候恢复连斩）
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}



