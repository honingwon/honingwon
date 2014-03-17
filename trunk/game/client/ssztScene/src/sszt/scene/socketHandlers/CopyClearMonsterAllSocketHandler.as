package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class CopyClearMonsterAllSocketHandler extends BaseSocketHandler
	{
		public function CopyClearMonsterAllSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_CLEAR_MOUNSTER_ALL;
		}
		
		override public function handlePackage():void
		{
			//击杀boss数加一并且需要暂停连斩的计时	（当收到 清除全部物品 时候恢复连斩）
			sceneModule.duplicateMonyeInfo.updateKillBoss(_data.readInt());
			sceneModule.sceneInfo.monsterList.removeSceneMonsterAll();		
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
	
}