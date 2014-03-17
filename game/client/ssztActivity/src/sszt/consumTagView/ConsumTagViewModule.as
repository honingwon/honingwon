package sszt.consumTagView
{
	import sszt.consumTagView.components.ConsumTagViewPanel;
	import sszt.consumTagView.events.ConsumTagViewMediaEvents;
	import sszt.consumTagView.socketHandlers.ConsumTagViewSetSocketHandlers;
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.openActivity.OpenActivityInfoSocketHandler;
	import sszt.interfaces.module.IModule;

	public class ConsumTagViewModule extends BaseModule
	{
		public var consumTagViewFacade:ConsumTagViewFacade;
		public var consumTagViewPanel:ConsumTagViewPanel;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(consumTagViewPanel)
			{
				consumTagViewPanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			if(consumTagViewPanel)
				consumTagViewPanel.dispose();
			else
				consumTagViewFacade.sendNotification(ConsumTagViewMediaEvents.CON_MEDIATOR_START);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			ConsumTagViewSetSocketHandlers.remove();
			if(consumTagViewPanel)
			{
				consumTagViewPanel.dispose();
				consumTagViewPanel = null;
			}
			if(consumTagViewFacade)
			{
				consumTagViewFacade.dispose();
				consumTagViewFacade = null;
			}
			super.dispose();
			
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.CONSUMTAGVIEW;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			ConsumTagViewSetSocketHandlers.add(this);
			OpenActivityInfoSocketHandler.send();
			consumTagViewFacade = ConsumTagViewFacade.getInstance(moduleId.toString());
			consumTagViewFacade.setup(this);
		}
	}
}