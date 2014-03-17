package sszt.navigation.mediators
{
	import sszt.core.data.GlobalAPI;
	import sszt.navigation.NavigationModule;
	import sszt.navigation.components.NavigationBar;
	import sszt.navigation.events.NavigationMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class NavigationMediator extends Mediator
	{
		public static const NAME:String = "NavigationMediator";
		
		public function NavigationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NavigationMediatorEvent.NAVIGATION_MEDIATOR_START,
				NavigationMediatorEvent.NAVIGATION_MEDIATOR_HIDE,
				NavigationMediatorEvent.NAVIGATION_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case NavigationMediatorEvent.NAVIGATION_MEDIATOR_START:
					initView();
					break;
				case NavigationMediatorEvent.NAVIGATION_MEDIATOR_HIDE:
					hideView();
					break;
				case NavigationMediatorEvent.NAVIGATION_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView():void
		{
			if(navigationModule.navigationBar == null)
			{
				navigationModule.navigationBar = new NavigationBar(this);
			}
			if(!navigationModule.navigationBar.parent)
				GlobalAPI.layerManager.getPopLayer().addChild(navigationModule.navigationBar);
		}
		
		private function hideView():void
		{
			if(navigationModule.navigationBar.parent)
				navigationModule.navigationBar.parent.removeChild(navigationModule.navigationBar);
		}
		
		public function get navigationModule():NavigationModule
		{
			return viewComponent as NavigationModule;
		}
		
		private function dispose():void
		{
			viewComponent = null;
		}
	}
}