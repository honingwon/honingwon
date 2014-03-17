package sszt.scene.mediators
{
	import flash.events.Event;
	import flash.utils.Timer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateType;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.camp.ClubCampEnterSocketHandler;
	import sszt.core.socketHandlers.club.camp.ClubCampLeaveSocketHandler;
	import sszt.core.socketHandlers.copy.CopyEnterCountSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	import sszt.scene.components.copyGroup.CopyDetailView;
	import sszt.scene.components.copyGroup.CopyEnterAlert;
	import sszt.scene.components.copyGroup.CopyGroupPanel;
	import sszt.scene.components.copyGroup.NpcCopyPanel;
	import sszt.scene.components.copyIsland.beforeEnter.CopyIslandEnterPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.copyIsland.CopyIslandInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.CopyEnterSocketHandler;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.scene.socketHandlers.CopyTowerEnterSocketHandler;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	import sszt.scene.socketHandlers.TeamCreateSocketHandler;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	import sszt.scene.socketHandlers.TeamKickSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaveSocketHandler;
	import sszt.scene.socketHandlers.TeamNofullMsgSocketHandler;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandLeaderEnterSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class CopyGroupMediator extends Mediator
	{
		public static const NAME:String = "copyGroupMediator";
		
		private var _doubleSitAlert:MAlert;
		
		public function CopyGroupMediator(viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYGROUP,
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWNPCCOPY,
				SceneMediatorEvent.COPY_ACTION,
				SceneMediatorEvent.CLUB_SCENE_LEAVE,
				SceneMediatorEvent.CLUB_SCENE_ENTER,
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYALERT,
				SceneMediatorEvent.COPY_ENTER,
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYISLAND
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYGROUP:
					showCopyGroupPanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWNPCCOPY:
					var data:Object = notification.getBody();
					if(data.copyType == 2)
					{
						if(sceneInfo.teamData.leadId == 0)
						{
							MAlert.show(LanguageManager.getWord("ssztl.scene.createTeamNow"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,enterAlertHandler);
							return;
						}
						else
						{
							if(sceneInfo.teamData.leadId != GlobalData.selfPlayer.userId)
							{
								QuickTips.show(LanguageManager.getWord("ssztl.scene.teamLeaderCanApplyEnter"));
								return;
							}
						}
						if(sceneInfo.teamData.teamPlayers.length > 3)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.scene.overTeamMaxMember"));
							return;
						}
						var copy:CopyTemplateItem = CopyTemplateList.getCopyByNpc(data.npcId);
//						sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYISLAND,copy.id);
						CopyIslandLeaderEnterSocketHandler.send(copy.id);
					}
					else
					{
						showNpcCopyPanel(data.npcId,data.levelId);
					}
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYISLAND:
					showCopyIslandEnterPanel(notification.getBody() as int);
					break;
				case SceneMediatorEvent.COPY_ACTION:
					showCopyAction(notification.getBody() as int);
					break;
				case SceneMediatorEvent.CLUB_SCENE_LEAVE:
					showClubSceneLeave(notification.getBody() as int);
					break;
				case SceneMediatorEvent.CLUB_SCENE_ENTER:
					showClubSceneEnter(notification.getBody() as int);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYALERT:
					showCopyEnterAlert();
					break;
				case SceneMediatorEvent.COPY_ENTER:
					enterCopy(int(notification.getBody()));
					break;
			}	
		}
		
		private function enterAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				TeamCreateSocketHandler.send();
			}
		}
		
		public function showCopyAction(type:int):void
		{
			if(type == 1)
			{
				var message:String;
				if(GlobalData.copyEnterCountList.isPKCopy()&& GlobalData.selfPlayer.pkState == 0) message = LanguageManager.getWord("ssztl.scene.isSureBeLoser");
				else message = LanguageManager.getWord("ssztl.scene.isSureLeaveCopy");
				MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
				function leaveAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						CopyLeaveSocketHandler.send();
					}
				}
			}
		}
		
		public function showClubSceneLeave(type:int):void
		{
			if(type == 1)
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.isSureLeaveScene"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
				function leaveAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						ClubCampLeaveSocketHandler.send();
					}
				}
			}
		}
		
		public function showClubSceneEnter(type:int):void
		{
			if(GlobalData.selfPlayer && GlobalData.selfPlayer.clubId == 0)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.hasNoClub'));
				return;
			}
			if(type == 1)
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.isSureEnterScene"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
				function leaveAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						ClubCampEnterSocketHandler.send();
					}
				}
			}
		}
		
		public function showCopyGroupPanel():void
		{
			if(sceneModule.copyGroupPanel == null)
			{
				sceneModule.copyGroupPanel = new CopyGroupPanel(this);
				sceneModule.copyGroupPanel.addEventListener(Event.CLOSE,copyPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.copyGroupPanel);
			}
		}
		
		private function copyPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.copyGroupPanel)
			{
				sceneModule.copyGroupPanel.removeEventListener(Event.CLOSE,copyPanelCloseHandler);
				sceneModule.copyGroupPanel = null;
			}
		}
		
		public function showCopyDetailView():void
		{
			if(sceneModule.copyDetailView == null)
			{
				sceneModule.copyDetailView = new CopyDetailView(this);
				sceneModule.copyDetailView.addEventListener(Event.CLOSE,copyDetailViewCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.copyDetailView);
			}
		}
		
		private function copyDetailViewCloseHandler(evt:Event):void
		{
			if(sceneModule.copyDetailView)
			{
				sceneModule.copyDetailView.removeEventListener(Event.CLOSE,copyDetailViewCloseHandler);
				sceneModule.copyDetailView = null;
			}
		}
		
		public function showCopyEnterAlert():void
		{
			if(sceneModule.copyEnterAlert == null)
			{
				sceneModule.copyEnterAlert = new CopyEnterAlert(this);
				sceneModule.copyEnterAlert.addEventListener(Event.CLOSE,CopyEnterAlertCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.copyEnterAlert);
			}
		}
		
		private function CopyEnterAlertCloseHandler(evt:Event):void
		{
			if(sceneModule.copyEnterAlert)
			{
				sceneModule.copyEnterAlert.removeEventListener(Event.CLOSE,CopyEnterAlertCloseHandler);
				sceneModule.copyEnterAlert = null;
			}
		}
		/**copyType = 0普通副本，copyType = 1等级副本限制 copyType = 2人数副本限制**/
		public function showNpcCopyPanel(id:int,level:int = 0):void
		{
			if(level > 0)
			{
				if(GlobalData.selfPlayer.level < 50)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.challenge40NeedOverLevel50"));
					return;
				}
			}
			var copy:CopyTemplateItem = CopyTemplateList.getCopyByNpc(id);
			if(copy.taskId > 0)
			{
				var info:TaskItemInfo = GlobalData.taskInfo.getTask(copy.taskId);
				if(info && info.isExist && info.taskState == TaskStateType.ACCEPTNOTFINISH)
				{
					if(copy.maxPlayer == 1)
					{
						if(GlobalData.selfPlayer.level < copy.minLevel) 
						{
							QuickTips.show(LanguageManager.getWord("ssztl.scene.levelNoAchieveCopyValue",copy.minLevel));
							return ;
						}
						if(GlobalData.selfPlayer.level > copy.maxLevel)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.scene.overMaxLevelLimited"));
							return ;
						}
						var count:int = GlobalData.copyEnterCountList.getItemCount(copy.id);
						if(count >= copy.dayTimes)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.scene.copyLeftZero"));
							return;
						}
						GlobalData.selfPlayer.scenePath = null;
						GlobalData.selfPlayer.scenePathTarget = null;
						GlobalData.selfPlayer.scenePathCallback = null;
						sceneModule.sceneInit.playerListController.getSelf().stopMoving();
						if(sceneModule.sceneInfo.teamData.leadId > 0)
						{
							MAlert.show(LanguageManager.getWord("ssztl.common.isSureEnterCopy"),
								LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
						}
						else
							CopyEnterSocketHandler.send(copy.id);
						return;
					}
					if(sceneModule.npcCopyPanel == null)
					{
						sceneModule.npcCopyPanel = new NpcCopyPanel(this,copy,level);
						sceneModule.npcCopyPanel.addEventListener(Event.CLOSE,npcCopyCloseHandler);
						GlobalAPI.layerManager.addPanel(sceneModule.npcCopyPanel);
					}

				}else
				{
					var message:String = TaskTemplateList.getTaskTemplate(copy.taskId).title;
					QuickTips.show(LanguageManager.getWord("ssztl.scene.noTaskForCopy",message));
				}
			}else
			{
				if(copy.maxPlayer == 1 || copy.id == 1100000 )
				{
//					if(sceneInfo.teamData.leadId != 0 && sceneInfo.teamData.teamPlayers.length > 1)
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.scene.copyMustSingleEnter"));
//						return ;
//					}
					if(GlobalData.selfPlayer.level < copy.minLevel) 
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.levelNoAchieveCopyValue",copy.minLevel));
						return ;
					}
					if(GlobalData.selfPlayer.level > copy.maxLevel)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.overMaxLevelLimited"));
						return ;
					}
					count = GlobalData.copyEnterCountList.getItemCount(copy.id);
					if(count >= copy.dayTimes)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.copyLeftZero"));
						return;
					}
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					sceneModule.sceneInit.playerListController.getSelf().stopMoving();
					if(level>0) CopyTowerEnterSocketHandler.send(copy.id);
					else
					{
						if(sceneModule.sceneInfo.teamData.leadId > 0)
						{
							MAlert.show(LanguageManager.getWord("ssztl.common.isSureEnterCopy"),
								LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
						}
						else
							CopyEnterSocketHandler.send(copy.id);
					}
						
					return;
				}
				if(sceneModule.npcCopyPanel == null)
				{
					sceneModule.npcCopyPanel = new NpcCopyPanel(this,copy,level);
					sceneModule.npcCopyPanel.addEventListener(Event.CLOSE,npcCopyCloseHandler);
					GlobalAPI.layerManager.addPanel(sceneModule.npcCopyPanel);
				}
			}
			function leaveCloseHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					TeamLeaveSocketHandler.sendLeave();
					var ti:Timer = new Timer(1000,1);
					ti.start();
					CopyEnterSocketHandler.send(copy.id);
				}
			}
			
		}
		
		private function npcCopyCloseHandler(evt:Event):void
		{
			if(sceneModule.npcCopyPanel)
			{
				sceneModule.npcCopyPanel.removeEventListener(Event.CLOSE,npcCopyCloseHandler);
				sceneModule.npcCopyPanel = null;
			}
		}
		
		/**神魔岛副本进入弹窗**/
		private function showCopyIslandEnterPanel(id:int):void
		{
			if(sceneModule.copyIslandEnterPanel == null)
			{
				var copy:CopyTemplateItem = CopyTemplateList.getCopy(id);
				sceneModule.copyIslandEnterPanel = new CopyIslandEnterPanel(this,copy);
				sceneModule.copyIslandEnterPanel.addEventListener(Event.CLOSE,hideCopyIslandEnterPanel);
				GlobalAPI.layerManager.addPanel(sceneModule.copyIslandEnterPanel);
			}
		}
		
		private function hideCopyIslandEnterPanel(e:Event):void
		{
			if(sceneModule.copyIslandEnterPanel)
			{
				sceneModule.copyIslandEnterPanel.removeEventListener(Event.CLOSE,hideCopyIslandEnterPanel);
				sceneModule.copyIslandEnterPanel = null;
			}
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function kickPlayer(id:Number):void
		{
			TeamKickSocketHandler.sendTeamKick(id);
		}
		
		public function addTeam(serverId:int,name:String):void
		{
			if(GlobalData.copyEnterCountList.isInCopy || sceneInfo.mapInfo.isShenmoDouScene() || sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			TeamInviteSocketHandler.sendInvite(serverId,name);
		}
		
		public function getNearlyData():void
		{
			TeamNofullMsgSocketHandler.send();
		}
		
		public function invite(serverId:int,name:String):void
		{
			if(GlobalData.copyEnterCountList.isInCopy || sceneInfo.mapInfo.isShenmoDouScene() || sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			TeamInviteSocketHandler.sendInvite(serverId,name);
		}
		
		public function enterCopy(id:int,level:int = 0):void
		{
			if(GlobalData.copyEnterCountList.isInCopy || sceneInfo.mapInfo.isShenmoDouScene() || sceneInfo.mapInfo.isClubPointWarScene() || sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			if(!sceneInfo.playerList.self)return;
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotUseTransfer"));
				return;
			}
			if(!sceneInfo.playerList.self.getIsCommon())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.inWarState"));
				return;
			}
			if(sceneInfo.playerList.isDoubleSit() && _doubleSitAlert == null)
			{
				_doubleSitAlert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,stopDoubleSit);
			}
			else
			{
				doEnter();
			}
			function stopDoubleSit(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					PlayerSitSocketHandler.send(false);
					sceneInfo.playerList.clearDoubleSit();
					doEnter();
				}
				_doubleSitAlert = null;
			}
			function doEnter():void
			{
				GlobalData.selfPlayer.scenePath = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathCallback = null;
				sceneModule.sceneInit.playerListController.getSelf().stopMoving();
				if(level == 0) CopyEnterSocketHandler.send(id);
				else CopyTowerEnterSocketHandler.send(id);
			}
		}
		
		public function getCopyEnterCount():void
		{
			CopyEnterCountSocketHandler.send();
		}
		
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
		
		public function get copyIslandInfo():CopyIslandInfo
		{
			return sceneModule.copyIslandInfo;
		}
	}
}