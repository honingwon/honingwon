package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class ItemTipDeployHandler extends BaseDeployHandler
	{
		public function ItemTipDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.ITEMTIP;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			var posX:int = Math.floor(info.param4 / 100000);
			var posY:int = info.param4 % 100000;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.SHOW_ITEMTIP,{userId:info.param1,itemId:info.param2,itemTempId:info.param3,posX:posX,posY:posY}));
		}
	}
}