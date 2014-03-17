package sszt.firstRecharge
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.firstRecharge.components.FirstRechargePanel;
	import sszt.firstRecharge.events.FirstRechargeMediaEvents;
	import sszt.firstRecharge.socketHandlers.FirstRechargeSetSocketHandlers;

	/**
	 * 首冲 
	 * @author chendong
	 * 
	 */	
	public class FirstRechargeModule extends BaseModule
	{
		public var firstRechargeFacade:FirstRechargeFacade;
		public var firstRechargePanel:FirstRechargePanel;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(firstRechargePanel)
			{
				firstRechargePanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			if(firstRechargePanel)
				firstRechargePanel.dispose();
			else
				firstRechargeFacade.sendNotification(FirstRechargeMediaEvents.FIRSTRECH_MEDIATOR_START);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			FirstRechargeSetSocketHandlers.remove();
			if(firstRechargePanel)
			{
				firstRechargePanel.dispose();
				firstRechargePanel = null;
			}
			if(firstRechargeFacade)
			{
				firstRechargeFacade.dispose();
				firstRechargeFacade = null;
			}
			super.dispose();
			
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.FIRSTRECHARGE;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			FirstRechargeSetSocketHandlers.add(this);
			firstRechargeFacade = FirstRechargeFacade.getInstance(moduleId.toString());
			firstRechargeFacade.setup(this);
		}
	}
}