package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.ModuleEventDeployType;
	import sszt.events.ClubModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class ModuleEventDeployHandler extends BaseDeployHandler
	{
		public function ModuleEventDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.MODULE_EVENT;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			switch(info.param1)
			{
				//进入副本
				case 1:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.COPY_ENTER,info.param2));
					break;
				case 2:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_SHENMO_SHOP));
					break;
				case 3:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TO_SWIM,{side:1,index:info.param2}));
					break;
				case 4:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TO_SWIM,{side:2,index:info.param2}));
					break;
			}
		}
	}
}