package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class WalkDeployHandler extends BaseDeployHandler
	{
		public function WalkDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.WALK;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT,{sceneId:info.param1}));
		}
	}
}