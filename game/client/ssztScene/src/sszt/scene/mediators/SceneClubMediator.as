package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.clubFire.ClubFireIconView;
	import sszt.scene.events.SceneClubUpdateEvent;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SceneClubMediator extends Mediator
	{
		public static const NAME:String = "sceneClubMediator";
		
		public function SceneClubMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
							SceneClubUpdateEvent.CLUB_FIRE_ICON_UPDATE,
							SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
						];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneClubUpdateEvent.CLUB_FIRE_ICON_UPDATE:
					showClubFireIconView(notification.getBody() as int);
					break
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
				break;
			}
		}
		
		private function showClubFireIconView(argShowTime:int):void
		{
			if(sceneModule.clubFireIconView == null)
			{
				sceneModule.clubFireIconView = new ClubFireIconView(this);
				sceneModule.clubFireIconView.addEventListener(Event.CLOSE,hideClubFireIconView);
				sceneModule.clubFireIconView.show(argShowTime);
			}
		}
		
		public function hideClubFireIconView(e:Event):void
		{
			if(sceneModule.clubFireIconView)
			{
				sceneModule.clubFireIconView.removeEventListener(Event.CLOSE,hideClubFireIconView);
				sceneModule.clubFireIconView.dispose();
				sceneModule.clubFireIconView = null;
			}
		}
		
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}