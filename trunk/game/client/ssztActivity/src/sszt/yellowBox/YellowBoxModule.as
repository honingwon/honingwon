package sszt.yellowBox
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.openActivity.YellowBoxInfoSocketHandler;
	import sszt.interfaces.module.IModule;
	import sszt.yellowBox.components.YellowBoxPanel;
	import sszt.yellowBox.events.YellowBoxMediaEvents;
	import sszt.yellowBox.socketHandlers.YellowBoxSetSocketHandlers;

	public class YellowBoxModule extends BaseModule
	{
		public var yellowBoxFacade:YellowBoxFacade;
		public var yellowBoxPanel:YellowBoxPanel;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(yellowBoxPanel)
			{
				yellowBoxPanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			if(yellowBoxPanel)
				yellowBoxPanel.dispose();
			else
				yellowBoxFacade.sendNotification(YellowBoxMediaEvents.YELLOW_MEDIATOR_START);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			YellowBoxSetSocketHandlers.remove();
			if(yellowBoxPanel)
			{
				yellowBoxPanel.dispose();
				yellowBoxPanel = null;
			}
			if(yellowBoxFacade)
			{
				yellowBoxFacade.dispose();
				yellowBoxFacade = null;
			}
			super.dispose();
			
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.YELLOWBOX;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			YellowBoxSetSocketHandlers.add(this);
			YellowBoxInfoSocketHandler.send();
			yellowBoxFacade = YellowBoxFacade.getInstance(moduleId.toString());
			yellowBoxFacade.setup(this);
		}
	}
}