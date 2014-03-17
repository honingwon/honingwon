package sszt.scene.mediators
{
	import fl.controls.ScrollPolicy;
	
	import sszt.ui.container.MTile;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.QuickIconInfo;
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.socketHandlers.club.ClubInviteResponseSocketHandler;
	import sszt.core.socketHandlers.im.FriendAcceptSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.quickIcon.ClubIconBtn;
	import sszt.scene.components.quickIcon.DoubleSitIconBtn;
	import sszt.scene.components.quickIcon.FriendIconBtn;
	import sszt.scene.components.quickIcon.QuickIconPanel;
	import sszt.scene.components.quickIcon.SkillIconBtn;
	import sszt.scene.components.quickIcon.TeamIconBtn;
	import sszt.scene.components.quickIcon.TradeIconBtn;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.PlayerInviteSitRelaySocketHandler;
	import sszt.scene.socketHandlers.TeamInviteMsgSocketHandler;
	import sszt.scene.socketHandlers.TradeAcceptSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class QuickIconMediator extends Mediator
	{
		public static const NAME:String = "quickIconMediator";
		public function QuickIconMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
						SceneMediatorEvent.QUICK_ICON_PANEL,
						SceneMediatorEvent.QUICK_ICON_DISPOSE
						];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.QUICK_ICON_PANEL:
					showQuickIconPanel();
					break;
				case SceneMediatorEvent.QUICK_ICON_DISPOSE:
					dispose();
			}
		}
		
		private function showQuickIconPanel():void
		{
			if(sceneModule.quickIconPanel == null)
			{
				sceneModule.quickIconPanel = new QuickIconPanel(this);
				GlobalAPI.layerManager.getTipLayer().addChild(sceneModule.quickIconPanel);
			}
		}
		
		/************点击图标事件*************************/
		public function sendFriendAccept(argUserId:Number,argAcceptTag:Boolean):void
		{
			FriendAcceptSocketHandler.sendAccept(argUserId,argAcceptTag);
		}
		
		public function sendTradeAccept(argUserId:Number,argAcceptTag:Boolean):void
		{
			TradeAcceptSocketHandler.sendAccept(argAcceptTag,argUserId);
		}
		
		public function sendDoubleSitAccept(userId:Number,argAcceptTag:Boolean):void
		{
			PlayerInviteSitRelaySocketHandler.send(argAcceptTag,userId);
		}
		
		public function sendTeamAccept(argUserId:Number,argAcceptTag:Boolean):void
		{
			TeamInviteMsgSocketHandler.send(argAcceptTag,argUserId);
		}
		
		public function sendClubAccept(argClubId:Number,argAcceptTag:Boolean):void
		{
			ClubInviteResponseSocketHandler.send(argAcceptTag,argClubId);
		}
		
		public function dispose():void
		{
			if(sceneModule.quickIconPanel)
			{
				sceneModule.quickIconPanel.dispose();
				sceneModule.quickIconPanel = null;
			}
			viewComponent = null;
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
	}
}