package sszt.midAutumnActivity
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.midAutumnActivity.components.MidAutumnActivityPanel;
	import sszt.midAutumnActivity.event.MidAutumnActivityMediatorEvent;
	
	public class MidAutumnActivityModule extends BaseModule
	{
		public var facade:MidAutumnActivityFacade;
		public var mainPanel:MidAutumnActivityPanel
		
		public function MidAutumnActivityModule()
		{
			super();
		}
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(mainPanel)
			{
				mainPanel.assetsCompleteHandler();
			}
		}
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			facade = MidAutumnActivityFacade.getInstance(String(moduleId));
			facade.startup(this,data);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			if(mainPanel)
				mainPanel.dispose();
			else
				facade.sendNotification(MidAutumnActivityMediatorEvent.MID_AUTUMN_ACTIVITY_START);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.MID_AUTUMN_ACTIVITY;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
		}
	}
}