package sszt.mergeServer
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.mergeServer.components.MergeServerPanel;
	import sszt.mergeServer.event.MergeServerMediatorEvent;
	
	public class MergeServerModule extends BaseModule
	{
		public var facade:MergeServerFacade;
		public var mainPanel:MergeServerPanel
		
		public function MergeServerModule()
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
			facade = MergeServerFacade.getInstance(String(moduleId));
			facade.startup(this,data);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			if(mainPanel)
				mainPanel.dispose();
			else
				facade.sendNotification(MergeServerMediatorEvent.MERGE_SERVER_START);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.MERGE_SERVER;
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