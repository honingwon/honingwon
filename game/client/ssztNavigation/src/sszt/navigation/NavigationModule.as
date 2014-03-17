package sszt.navigation
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.events.NavigationModuleEvent;
	import sszt.interfaces.module.IModule;
	import sszt.module.ModuleEventDispatcher;
	import sszt.navigation.components.NavigationBar;
	import sszt.navigation.events.NavigationMediatorEvent;
	
	public class NavigationModule extends BaseModule
	{
		public var facade:NavigationFacade;
		public var navigationBar:NavigationBar;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			facade = NavigationFacade.getInstance(String(moduleId));
			facade.startup(this);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.NAVIGATION;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addNavigationEventListener(NavigationModuleEvent.SHOW_NAVIGATION,showNavigationHandler);
			ModuleEventDispatcher.addNavigationEventListener(NavigationModuleEvent.HIDE_NAVIGATION,hideNavigationHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			ModuleEventDispatcher.removeNavigationEventListener(NavigationModuleEvent.SHOW_NAVIGATION,showNavigationHandler);
			ModuleEventDispatcher.removeNavigationEventListener(NavigationModuleEvent.HIDE_NAVIGATION,hideNavigationHandler);
		}
		
		private function showNavigationHandler(evt:NavigationModuleEvent):void
		{
			facade.sendNotification(NavigationMediatorEvent.NAVIGATION_MEDIATOR_START);
		}
		
		private function hideNavigationHandler(evt:NavigationModuleEvent):void
		{
			facade.sendNotification(NavigationMediatorEvent.NAVIGATION_MEDIATOR_HIDE);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}