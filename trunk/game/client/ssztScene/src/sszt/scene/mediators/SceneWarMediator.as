package sszt.scene.mediators
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	import sszt.scene.components.shenMoWar.ShenMoRewardsPanel;
	import sszt.scene.components.shenMoWar.ShenMoWarMainPanel;
	import sszt.scene.components.shenMoWar.clubWar.ClubPointWarIconView;
	import sszt.scene.components.shenMoWar.clubWar.ClubPointWarScorePanel;
	import sszt.scene.components.shenMoWar.clubWar.shop.ClubPointWarShopPanel;
	import sszt.scene.components.shenMoWar.crystalWar.CrystalWarIconView;
	import sszt.scene.components.shenMoWar.crystalWar.CrystalWarScorePanel;
	import sszt.scene.components.shenMoWar.myWar.ShenMoMyWarInfoPanel;
	import sszt.scene.components.shenMoWar.personalWar.PerWarIcon;
	import sszt.scene.components.shenMoWar.personalWar.PerWarMyWarInfoPanel;
	import sszt.scene.components.shenMoWar.personalWar.PerWarRewardsPanel;
	import sszt.scene.components.shenMoWar.ranking.ShenMoRankingPanel;
	import sszt.scene.components.shenMoWar.ranking.ShenMoRankingTimePanel;
	import sszt.scene.components.shenMoWar.shenMoIcon.ShenMoIconView;
	import sszt.scene.components.shenMoWar.shop.ShenMoWarShopPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.clubPointWar.ClubPointWarInfo;
	import sszt.scene.data.clubPointWar.scoreInfo.ClubPointWarScoreItemInfo;
	import sszt.scene.data.crystalWar.CrystalWarInfo;
	import sszt.scene.data.personalWar.PerWarInfo;
	import sszt.scene.data.shenMoWar.ShenMoWarInfo;
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarSceneItemInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.data.shenMoWar.myWarInfo.ShenMoWarMyWarItemInfo;
	import sszt.scene.events.SceneClubPointWarUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarEnterSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarMainSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarPersonalUpdateSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarRankSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarRewardsSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarEnterSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarMainSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarPersonalUpdateSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarRankSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarRewardsSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarEnterSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarGetAwardSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarMemberListUpdateSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarMyWarInfoUpdateSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarSceneListUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarEnterSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarGetAwardSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMemberListUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMyWarInfoUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarResultUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarSceneListUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.UpdateSelfHonorSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SceneWarMediator extends Mediator
	{
		private static const NAME:String = "shenMoWarMediator";
		public function SceneWarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOWAR,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOREWARDS,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOSHOP,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOICON,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWPERWARICON,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWCLUBPOINTSCORE,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWCLUBPOINTWARICON,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWPERWAR_REWARDS,
							SceneMediatorEvent.SCENE_MEDIATOR_GET_CLUBWARREWARDS,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWCRYTSALWARICON,
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWCRYSTALPOINTSCORE,
							SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
						];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOWAR:
					showShenMoMainPanel(notification.getBody() as int);
				break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOREWARDS:
					showShenMoRewardsPanel();
				break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOSHOP:
					showShenMoWarShopPanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOICON:
					showShenMoIcon(notification.getBody() as int);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWPERWARICON:
					showPerWarIcon(notification.getBody() as int);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWCLUBPOINTSCORE:
					showClubPointWarScorePanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWCLUBPOINTWARICON:
					showClubPointWarIcon(notification.getBody() as int);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_GET_CLUBWARREWARDS:
					getRewards();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWPERWAR_REWARDS:
					showPerWarRewardsPanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWCRYTSALWARICON:
					showCrystalWarIcon(notification.getBody() as int);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWCRYSTALPOINTSCORE:
					showCrystalWarScorePanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
				break;
			}
		}
		//神魔斗法图标
		public function showShenMoIcon(argShowTime:int):void
		{
			if(module.shenMoWarIcon == null)
			{
				module.shenMoWarIcon = new ShenMoIconView(this);
				module.shenMoWarIcon.addEventListener(Event.CLOSE,iconCloseHandler);
				module.shenMoWarIcon.show(argShowTime);
			}
		}
		
		private function iconCloseHandler(e:Event):void
		{
			if(module.shenMoWarIcon)
			{
				module.shenMoWarIcon.addEventListener(Event.CLOSE,iconCloseHandler);
				module.shenMoWarIcon.dispose();
				module.shenMoWarIcon = null;
			}
		}
		//神魔斗法主界面
		public function showShenMoMainPanel(argIndex:int):void
		{
			if(module.shenMoWarMainPanel == null) 
			{
				module.shenMoWarMainPanel = new ShenMoWarMainPanel(this,argIndex);
				GlobalAPI.layerManager.addPanel(module.shenMoWarMainPanel);
				module.shenMoWarMainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
			}
		}
		
		private function mainPanelCloseHandler(e:Event):void
		{
			if(module.shenMoWarMainPanel)
			{
				module.shenMoWarMainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
				module.shenMoWarMainPanel = null;
			}
		}
		//神魔斗法商场
		public function showShenMoWarShopPanel():void
		{
			if(module.shenMoWarShopPanel == null)
			{
				module.shenMoWarShopPanel = new ShenMoWarShopPanel(this);
				GlobalAPI.layerManager.addPanel(module.shenMoWarShopPanel);
				module.shenMoWarShopPanel.addEventListener(Event.CLOSE,hideShenMoWarShopPanel);
			}
		}
		
		private function hideShenMoWarShopPanel(e:Event):void
		{
			if(module.shenMoWarShopPanel)
			{
				module.shenMoWarShopPanel.removeEventListener(Event.CLOSE,hideShenMoWarShopPanel);
				module.shenMoWarShopPanel = null;
			}
		}
		
//		//帮会据点战商场
//		public function showClubWarShopPanel():void
//		{
//			if(module.clubWarShopPanel == null)
//			{
//				module.clubWarShopPanel = new ClubPointWarShopPanel(this);
//				GlobalAPI.layerManager.addPanel(module.clubWarShopPanel);
//				module.clubWarShopPanel.addEventListener(Event.CLOSE,hideClubWarShopPanel);
//			}
//		}
//		
//		private function hideClubWarShopPanel(e:Event):void
//		{
//			if(module.clubWarShopPanel)
//			{
//				module.clubWarShopPanel.removeEventListener(Event.CLOSE,hideClubWarShopPanel);
//				module.clubWarShopPanel = null;
//			}
//		}
		
		//神魔斗法奖励面板
		public function showShenMoRewardsPanel():void
		{
			if(module.shenMoRewardsPanel == null)
			{
				module.shenMoRewardsPanel = new ShenMoRewardsPanel(this);
				GlobalAPI.layerManager.addPanel(module.shenMoRewardsPanel);
				module.shenMoRewardsPanel.addEventListener(Event.CLOSE,rewardsPanelCloseHandler);
			}
		}
		
		private function rewardsPanelCloseHandler(e:Event):void
		{
			if(module.shenMoRewardsPanel)
			{
				module.shenMoRewardsPanel.removeEventListener(Event.CLOSE,rewardsPanelCloseHandler);
				module.shenMoRewardsPanel = null;
			}
		}
		
		//神魔斗法战报
		public function showMyWarInfoPanel():void
		{
			if(module.shenMoMyWarInfoPanel == null)
			{
				module.shenMoMyWarInfoPanel = new ShenMoMyWarInfoPanel(this);
				GlobalAPI.layerManager.addPanel(module.shenMoMyWarInfoPanel);
				module.shenMoMyWarInfoPanel.addEventListener(Event.CLOSE,myWarInfoPanelCloseHandler);
			}
		}
		
		private function myWarInfoPanelCloseHandler(e:Event):void
		{
			if(module.shenMoMyWarInfoPanel)
			{
				module.shenMoMyWarInfoPanel.removeEventListener(Event.CLOSE,myWarInfoPanelCloseHandler);
				module.shenMoMyWarInfoPanel = null;
			}
		}
//-----------------------------------------------------------------------------------------//			
		//显示帮会据点战图标
		public function showClubPointWarIcon(argShowTime:int):void
		{
			if(module.clubPointWarIcon == null)
			{
				module.clubPointWarIcon = new ClubPointWarIconView(this);
				module.clubPointWarIcon.addEventListener(Event.CLOSE,hideClubPointWarIcon);
				module.clubPointWarIcon.show(argShowTime);
			}
		}
		
		public function hideClubPointWarIcon(e:Event):void
		{
			if(module.clubPointWarIcon)
			{
				module.clubPointWarIcon.removeEventListener(Event.CLOSE,hideClubPointWarIcon);
				module.clubPointWarIcon.dispose();
				module.clubPointWarIcon = null;
			}
		}
		
		/**据点战统计排行版**/
		public function showClubPointWarScorePanel():void
		{
			if(module.clubPointWarScorePanel == null)
			{
				module.clubPointWarScorePanel = new ClubPointWarScorePanel(this);
				GlobalAPI.layerManager.addPanel(module.clubPointWarScorePanel);
				module.clubPointWarScorePanel.addEventListener(Event.CLOSE,hideClubPointWarScorePanel);
			}
		}
		
		private function hideClubPointWarScorePanel(e:Event):void
		{
			if(module.clubPointWarScorePanel)
			{
				module.clubPointWarScorePanel.removeEventListener(Event.CLOSE,hideClubPointWarScorePanel);
				module.clubPointWarScorePanel = null;
			}
		}
		
		private function getRewards():void
		{
			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				sendPointWarRewards(1);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.onlyClubLeaderCanGetAward"));
				return;
			}
		}
		
		//----------------------水晶战面板------------------------------------------------//
		/**水晶战统计排行版**/
		public function showCrystalWarScorePanel():void
		{
			if(module.crystalWarScorePanel == null)
			{
				module.crystalWarScorePanel = new CrystalWarScorePanel(this);
				GlobalAPI.layerManager.addPanel(module.crystalWarScorePanel);
				module.crystalWarScorePanel.addEventListener(Event.CLOSE,hideCrystalWarScorePanel);
			}
		}
		
		private function hideCrystalWarScorePanel(e:Event):void
		{
			if(module.crystalWarScorePanel)
			{
				module.crystalWarScorePanel.removeEventListener(Event.CLOSE,hideCrystalWarScorePanel);
				module.crystalWarScorePanel = null;
			}
		}
		
		//水晶战图标
		public function showCrystalWarIcon(argShowTime:int):void
		{
			if(module.crystalWarIconView == null)
			{
				module.crystalWarIconView = new CrystalWarIconView(this);
				module.crystalWarIconView.addEventListener(Event.CLOSE,hideCrystalWarIcon);
				module.crystalWarIconView.show(argShowTime);
			}
		}
		
		public function hideCrystalWarIcon(e:Event):void
		{
			if(module.crystalWarIconView)
			{
				module.crystalWarIconView.removeEventListener(Event.CLOSE,hideCrystalWarIcon);
				module.crystalWarIconView.dispose();
				module.crystalWarIconView = null;
			}
		}
		
//--------------------------------------神魔乱斗发送协议------------------------------------//		
		public function sendEnterWar():void
		{
			ShenMoWarEnterSocketHandler.send(shenMoWarInfo.warSceneId);
		}
		
		public function sendLeaveWar():void
		{
			ShenMoWarLeaveSocketHandler.send();
		}
		
		public function sendAward():void
		{
			shenMoWarInfo.shenMoWarMembersInfo.sendGet();
			ShenMoWarGetAwardSocketHandler.send();
		}
		
		public function sendMemberList():void
		{
			ShenMoWarMemberListUpdateSocketHandler.send(shenMoWarInfo.warSceneId);
		}
		
		public function sendMyWarList():void
		{
			ShenMoWarMyWarInfoUpdateSocketHandler.send(shenMoWarInfo.warSceneId);
		}
		
		public function sendResultList():void
		{
			ShenMoWarResultUpdateSocketHandler.send(shenMoWarInfo.warSceneId);
		}
		
		public function sendWarSceneList():void
		{
			ShenMoWarSceneListUpdateSocketHandler.send();
		}
		
		public function sendHonorInfo():void
		{
				UpdateSelfHonorSocketHandler.send();
		}
		
		public function sendClubHonorInfo():void
		{
			ClubPointWarPersonalUpdateSocketHandler.send();
		}
		
//--------------------帮会据点战------------------------------------//
		/**进入战场**/
		public function sendEnterPointWar():void
		{
			ClubPointWarEnterSocketHandler.send();
		}
		/**离开战场**/
		public function sendPointWarLeave():void
		{
			ClubPointWarLeaveSocketHandler.send();
		}
		/**获取据点信息**/
		public function sendPointWarMainInfo():void
		{
			ClubPointWarMainSocketHandler.send();
		}
		/**获取奖励**/
		public function sendPointWarRewards(argType:int):void
		{
			ClubPointWarRewardsSocketHandler.send(argType);
		}
		/**获取排行信息**/
		public function sendPointRank():void
		{
			ClubPointWarRankSocketHandler.send();
		}

//--------------------------------个人乱斗-------------------------------------//
		
		public function sendPerWarEnter():void
		{
//			ShenMoWarEnterSocketHandler.send(shenMoWarInfo.warSceneId);
			PerWarEnterSocketHandler.send(perWarInfo.warSceneId);
		}
		public function sendPerWarLeave():void
		{
			PerWarLeaveSocketHandler.send();	
		}
		public function sendPerWarSceneList():void
		{
			PerWarSceneListUpdateSocketHandler.send();
		}
		public function sendPerWarMemberList():void
		{
			PerWarMemberListUpdateSocketHandler.send(perWarInfo.warSceneId);
		}
		public function sendPerWarAward():void
		{
			perWarInfo.perWarMembersInfo.sendGet();
			PerWarGetAwardSocketHandler.send();
		}
		public function sendPerWarMyWarList():void
		{
			PerWarMyWarInfoUpdateSocketHandler.send(perWarInfo.warSceneId);
		}
		//个人乱斗奖励面板
		public function showPerWarRewardsPanel():void
		{
			if(module.perWarRewardsPanel == null)
			{
				module.perWarRewardsPanel = new PerWarRewardsPanel(this);
				GlobalAPI.layerManager.addPanel(module.perWarRewardsPanel);
				module.perWarRewardsPanel.addEventListener(Event.CLOSE,hidePerWarRewardsPanel);
			}
		}
		private function hidePerWarRewardsPanel(e:Event):void
		{
			if(module.perWarRewardsPanel)
			{
				module.perWarRewardsPanel.removeEventListener(Event.CLOSE,hidePerWarRewardsPanel);
				module.perWarRewardsPanel = null;
			}
		}
		//个人乱斗我的战报
		public function showPerWarMyWarInfoPanel():void
		{
			if(module.perWarMyInfoPanel == null)
			{
				module.perWarMyInfoPanel = new PerWarMyWarInfoPanel(this);
				GlobalAPI.layerManager.addPanel(module.perWarMyInfoPanel);
				module.perWarMyInfoPanel.addEventListener(Event.CLOSE,hidePerWarMyWarInfoPanel);
			}
		}
		
		public function hidePerWarMyWarInfoPanel(e:Event):void
		{
			if(module.perWarMyInfoPanel)
			{
				module.perWarMyInfoPanel.removeEventListener(Event.CLOSE,hidePerWarMyWarInfoPanel);
				module.perWarMyInfoPanel = null;
			}
		}
		
		//个人乱斗图标
		public function showPerWarIcon(argShowTime:int):void
		{
			if(module.perWarIcon == null)
			{
				module.perWarIcon = new PerWarIcon(this);
				module.perWarIcon.addEventListener(Event.CLOSE,hidePerWarIcon);
				module.perWarIcon.show(argShowTime);
			}
		}
		
		private function hidePerWarIcon(e:Event):void
		{
			if(module.perWarIcon)
			{
				module.perWarIcon.addEventListener(Event.CLOSE,hidePerWarIcon);
				module.perWarIcon.dispose();
				module.perWarIcon = null;
			}
		}
		
		
		public function get perWarInfo():PerWarInfo
		{
			return module.perWarInfo;
		}
//----------------------------------------------------------------------------//		
		
		
//--------------------水晶战----------------------//		
		/**进入水晶战场**/
		public function sendCrystalWarEnter():void
		{
			CrystalWarEnterSocketHandler.send();
		}
		/**离开水晶战场**/
		public function sendCrystalWarLeave():void
		{
			CrystalWarLeaveSocketHandler.send();
		}
		/**获取据点信息**/
		public function sendCrystalWarMainInfo():void
		{
			CrystalWarMainSocketHandler.send();
		}
		/**获取奖励**/
		public function sendCrystalWarRewards(argType:int):void
		{
			CrystalWarRewardsSocketHandler.send(argType);
		}
		/**获取排行信息**/
		public function sendCrystalWarRank():void
		{
			CrystalWarRankSocketHandler.send();
		}
		/**获取个人信息**/
		public function sendCrystalWarPersonal():void
		{
			CrystalWarPersonalUpdateSocketHandler.send();
		}
		
//***********************************************/		
		public function get shenMoWarInfo():ShenMoWarInfo
		{
			return module.shenMoWarInfo;
		}
		
		public function get clubPointWarInfo():ClubPointWarInfo
		{
			return module.clubPointWarInfo;
		}
		
		public function get sceneInfo():SceneInfo
		{
			return module.sceneInfo;
		}
		
		public function get crystalWarInfo():CrystalWarInfo
		{
			return module.crystalWarInfo;
		}
		
		public function get module():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
		
	}
}