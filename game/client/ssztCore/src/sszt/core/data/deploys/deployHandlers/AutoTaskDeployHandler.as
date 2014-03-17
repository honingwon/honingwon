/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-9 下午3:41:29 
 * 
 */ 
package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class AutoTaskDeployHandler extends BaseDeployHandler
	{
		public function AutoTaskDeployHandler()
		{
		}
		
		override public function getType() : int
		{
			return DeployEventType.AUTO_TASK;
		}
		
		override public function handler(info:DeployItemInfo) : void
		{
			var eventName:String = SceneModuleEvent.AUTO_TASK_START;
			if (info.param1 == 0)
			{
				eventName = SceneModuleEvent.AUTO_TASK_DISPOSE;
			}
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(eventName, info.param1));
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY));
		}
		
	}
}