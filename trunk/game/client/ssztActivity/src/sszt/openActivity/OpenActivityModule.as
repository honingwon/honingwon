package sszt.openActivity
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.openActivity.OpenActivityInfoSocketHandler;
	import sszt.interfaces.module.IModule;
	import sszt.openActivity.components.OpenActivityPanel;
	import sszt.openActivity.events.OpenActivityMediaEvents;
	import sszt.openActivity.socketHandlers.OpenActivitySetSocketHandlers;

	public class OpenActivityModule extends BaseModule
	{
		public var activityFacade:OpenActivityFacade;
		public var activityPanel:OpenActivityPanel;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(activityPanel)
			{
				activityPanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
//			OpenActivitySetSocketHandlers.add(this);
//			OpenActivityInfoSocketHandler.send();
			if(activityPanel)
				activityPanel.dispose();
			else
				activityFacade.sendNotification(OpenActivityMediaEvents.OPEN_ACTIVITY_MEDIATOR_START);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			OpenActivitySetSocketHandlers.remove();
			if(activityPanel)
			{
				activityPanel.dispose();
				activityPanel = null;
			}
			if(activityFacade)
			{
				activityFacade.dispose();
				activityFacade = null;
			}
			super.dispose();
			
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.OPENACTIVITY;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			OpenActivitySetSocketHandlers.add(this);
			OpenActivityInfoSocketHandler.send();
			activityFacade = OpenActivityFacade.getInstance(moduleId.toString());
			activityFacade.setup(this);
		}
	}
}