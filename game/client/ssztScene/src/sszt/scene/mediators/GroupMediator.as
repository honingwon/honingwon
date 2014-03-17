package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	import sszt.scene.components.group.GroupChatPanel;
	import sszt.scene.components.group.GroupPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.PlayerFollowSocketHandler;
	import sszt.scene.socketHandlers.TeamChangeSettingSocketHandler;
	import sszt.scene.socketHandlers.TeamDisbandSocketHandler;
	import sszt.scene.socketHandlers.TeamInviteMsgSocketHandler;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	import sszt.scene.socketHandlers.TeamKickSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaderChangeSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaveSocketHandler;
	import sszt.scene.socketHandlers.TeamNofullMsgSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class GroupMediator extends Mediator
	{
		public static const NAME:String = "GroupMediator";
		
		public function GroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWGROUP,
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWGROUPINVITE,
				SceneMediatorEvent.SCENE_MEDIATOR_TEAMACTION,
				SceneMediatorEvent.TEAM_SETTING_CHANGE,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWGROUP:
					initView();
					break;
//				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWGROUPINVITE:
//					showGroupInvite(notification.getBody());
//					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_TEAMACTION:
					teamActionProcess(notification.getBody());
					break;
				case SceneMediatorEvent.TEAM_SETTING_CHANGE:
					teamSettingChange(notification.getBody());
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView():void
		{
//			if(sceneModule.groupPanel == null)
//			{
//				sceneModule.groupPanel = new CopyGroupPanel(this);
//				sceneModule.groupPanel.addEventListener(Event.CLOSE,groupPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(sceneModule.groupPanel);
//				
//			} 
			if(sceneModule.groupPanel1 == null)
			{
				sceneModule.groupPanel1 = new GroupPanel(this);
				sceneModule.groupPanel1.addEventListener(Event.CLOSE,groupPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.groupPanel1);
			}
			else
			{
				sceneModule.groupPanel1.dispose();
				sceneModule.groupPanel1 = null;
			}
		}
		private function groupPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.groupPanel)
			{
				sceneModule.groupPanel.removeEventListener(Event.CLOSE,groupPanelCloseHandler);
				sceneModule.groupPanel = null;
			}
			if(sceneModule.groupPanel1)
			{
				sceneModule.groupPanel1.removeEventListener(Event.CLOSE,groupPanelCloseHandler);
				sceneModule.groupPanel1 = null;
			}
		}
		
		public function showGroupChatPanel():void
		{
			if(sceneModule.groupChatPanel == null)
			{
				sceneModule.groupChatPanel = new GroupChatPanel(this);
				sceneModule.groupChatPanel.addEventListener(Event.CLOSE,groupChatPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.groupChatPanel);
			}
		}
		
		private function groupChatPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.groupChatPanel)
			{
				sceneModule.groupChatPanel.removeEventListener(Event.CLOSE,groupChatPanelCloseHandler);
				sceneModule.groupChatPanel = null;
			}
		}
		
		private function showGroupInvite(data:Object):void
		{
			//name,id
//			if((sceneInfo.playerList.self.attackState == 2 || sceneInfo.playerList.self.attackState == 3) && sceneInfo.hangupData.autoGroup)
			if(!sceneInfo.playerList.self)return;
//			if(PlayerHangupType.inHangup(sceneInfo.playerList.self.hangupState) && sceneInfo.hangupData.autoGroup)
			if(sceneInfo.playerList.self.getIsHangup() && sceneInfo.hangupData.autoGroup)
			{
				if(sceneInfo.hangupData.isAccept)
				{
					TeamInviteMsgSocketHandler.send(true,data["id"]);
				}else
				{
					TeamInviteMsgSocketHandler.send(false,data["id"]);
				}
			}else
			{
				var message:String;
				if(sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
				{
					message = LanguageManager.getWord("ssztl.scene.acceptRequireTeam");
				}else
				{
					message = LanguageManager.getWord("ssztl.scene.acceptInviteTeam");
				}
				
				if(sceneModule.groupAlert)
				{
					sceneModule.groupAlert.dispose();
					sceneModule.groupAlert = MAlert.show(data["name"] + message,LanguageManager.getAlertTitle(),MAlert.AGREE | MAlert.REFUSE,null,closeHandler);
				}else
				{
					sceneModule.groupAlert = MAlert.show(data["name"] + message,LanguageManager.getAlertTitle(),MAlert.AGREE | MAlert.REFUSE,null,closeHandler);
				}
				
				function closeHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.AGREE)
					{
						TeamInviteMsgSocketHandler.send(true,data["id"]);
					}
					else
					{
						TeamInviteMsgSocketHandler.send(false,data["id"]);
					}
					sceneModule.groupAlert = null;
				}
			}
		}
		
				
		/**
		 *teamAction类型 0邀请组队，1更换队长，2离队，3踢出队伍，4解散队伍 ,5队员跟随
		 */	
		private function teamActionProcess(data:Object):void
		{
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				return;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.crossServerForbidAction"));
				return;
			}
			var type:int = data["type"];
			switch (type)
			{
				case 0:
					if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
						return;
					}
					TeamInviteSocketHandler.sendInvite(data["serverId"],data["nick"]);
					break;
				case 1:
					if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
						return;
					}
					TeamLeaderChangeSocketHandler.sendLeaderChange(data["id"]);
					break;
				case 2:
					if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.isSureExitTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
						
					}else
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.noExtendAddExitTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
					}
					break;
				case 3:
					if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
						return;
					}
					TeamKickSocketHandler.sendTeamKick(data["id"]);
					break;
				case 4:
					if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
						return;
					}
					TeamDisbandSocketHandler.sendDisband();
					break;
//				case 5:
//					
//					PlayerFollowSocketHandler.send(data["id"]);
//					break;
			}
		}
		
		private function leaveCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				TeamLeaveSocketHandler.sendLeave();
			}
		}
		
		public function teamSettingChange(obj:Object):void
		{
			TeamChangeSettingSocketHandler.sendSetting(obj["inTeam"],obj["allocation"]);
		}
		
		public function sendInvite(name:String,serverId:int):void
		{
			TeamInviteSocketHandler.sendInvite(serverId,name);
		}
		
		public function kickPlayer(id:Number):void
		{
			TeamKickSocketHandler.sendTeamKick(id);
		}
		
		public function getNearlyData():void
		{
			TeamNofullMsgSocketHandler.send();
		}
		
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
		
		public function showNear():void
		{
			sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWNEARLY);
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