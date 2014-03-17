package sszt.sevenActivity
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.sevenActivity.components.SevenActivityPanel;
	import sszt.sevenActivity.events.SevenActivityMediaEvents;
	import sszt.sevenActivity.socketHandlers.SevenActivitySetSocketHandlers;

	public class SevenActivityModule extends BaseModule
	{
		public var sevenActivityFacade:SevenActivityFacade;
		public var sevenActivityPanel:SevenActivityPanel;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(sevenActivityPanel)
			{
				sevenActivityPanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			SevenActivitySetSocketHandlers.add(this);
//			SevenActivityInfoSocketHandler.send();
			if(sevenActivityPanel)
				sevenActivityPanel.dispose();
			else
				sevenActivityFacade.sendNotification(SevenActivityMediaEvents.SEVEN_MEDIATOR_START);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			SevenActivitySetSocketHandlers.remove();
			if(sevenActivityPanel)
			{
				sevenActivityPanel.dispose();
				sevenActivityPanel = null;
			}
			if(sevenActivityFacade)
			{
				sevenActivityFacade.dispose();
				sevenActivityFacade = null;
			}
			super.dispose();
			
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.SEVENACTIVITY;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			SevenActivitySetSocketHandlers.add(this);
//			SevenActivityInfoSocketHandler.send();
			sevenActivityFacade = SevenActivityFacade.getInstance(moduleId.toString());
			sevenActivityFacade.setup(this);
		}
	}
}