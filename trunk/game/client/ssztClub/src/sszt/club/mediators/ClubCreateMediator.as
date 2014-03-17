package sszt.club.mediators
{
	import flash.events.Event;
	
	import sszt.club.ClubModule;
	import sszt.club.components.create.ClubCreatePanel;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.socketHandlers.ClubCreateSocketHandler;
	import sszt.core.data.GlobalAPI;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ClubCreateMediator extends Mediator
	{
		public static const NAME:String = "clubCreateMediator";
		
		public function ClubCreateMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ClubMediatorEvent.SHOW_CREATEPANEL,
				ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ClubMediatorEvent.SHOW_CREATEPANEL:
					showCreatePanel();
					break;
				case ClubMediatorEvent.CLUB_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function showCreatePanel():void
		{
			if(clubModule.createPanel == null)
			{
				clubModule.createPanel = new ClubCreatePanel(this);
				clubModule.createPanel.addEventListener(Event.CLOSE,createCloseHandler);
				GlobalAPI.layerManager.addPanel(clubModule.createPanel);
			}
		}
		private function createCloseHandler(evt:Event):void
		{
			if(clubModule.createPanel)
			{
				clubModule.createPanel.removeEventListener(Event.CLOSE,createCloseHandler);
				clubModule.createPanel = null;
			}
		}
		
		public function sendCreate(name:String,declear:String,type:int):void
		{
			ClubCreateSocketHandler.send(name,declear,type);
		}
		
		public function get clubModule():ClubModule
		{
			return viewComponent as ClubModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}