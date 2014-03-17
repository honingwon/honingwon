package sszt.payTagView
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.openActivity.OpenActivityInfoSocketHandler;
	import sszt.interfaces.module.IModule;
	import sszt.payTagView.components.PayTagViewPanel;
	import sszt.payTagView.events.PayTagViewMediaEvents;
	import sszt.payTagView.socketHandlers.PayTagViewSetSocketHandlers;

	public class PayTagViewModule extends BaseModule
	{
		public var payTagViewFacade:PayTagViewFacade;
		public var payTagViewPanel:PayTagViewPanel;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(payTagViewPanel)
			{
				payTagViewPanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			if(payTagViewPanel)
				payTagViewPanel.dispose();
			else
				payTagViewFacade.sendNotification(PayTagViewMediaEvents.PTW_MEDIATOR_START);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			PayTagViewSetSocketHandlers.remove();
			if(payTagViewPanel)
			{
				payTagViewPanel.dispose();
				payTagViewPanel = null;
			}
			if(payTagViewFacade)
			{
				payTagViewFacade.dispose();
				payTagViewFacade = null;
			}
			super.dispose();
			
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.PAYTAGVIEW;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			PayTagViewSetSocketHandlers.add(this);
			OpenActivityInfoSocketHandler.send();
			payTagViewFacade = PayTagViewFacade.getInstance(moduleId.toString());
			payTagViewFacade.setup(this);
		}
	}
}