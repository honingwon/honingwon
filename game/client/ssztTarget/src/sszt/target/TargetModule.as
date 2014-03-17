package sszt.target
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.target.TargetListUpdateSocketHandler;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.module.IModule;
	import sszt.target.components.TargetPanel;
	import sszt.target.socketHandlers.TargetSetSocketHandlers;

	public class TargetModule extends BaseModule
	{
		public var targetFacade:TargetFacade;
		public var targetPanel:TargetPanel;
		public var toTargetData:ToTargetData; 
		
		override public function assetsCompleteHandler():void
		{
			if(targetPanel)
			{
				targetPanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			toTargetData = data as ToTargetData;
			TargetSetSocketHandlers.add(this); 
//			TargetListUpdateSocketHandler.send();
			if(targetPanel)
				targetPanel.dispose();
			else
				targetFacade.sendNotification(TargetMediaEvents.TARGET_MEDIATOR_START,toTargetData);
		}
		
		override public function dispose():void
		{
			super.dispose();
			TargetSetSocketHandlers.remove();
			if(targetPanel)
			{
				targetPanel.dispose();
				targetPanel = null;
			}
			if(targetFacade)
			{
				targetFacade.dispose();
				targetFacade = null;
			}
			
			
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.TARGET;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			toTargetData = data as ToTargetData;
			TargetSetSocketHandlers.add(this);
//			TargetListUpdateSocketHandler.send();
			targetFacade = TargetFacade.getInstance(moduleId.toString());
			targetFacade.setup(this,toTargetData);
		}
	}
}