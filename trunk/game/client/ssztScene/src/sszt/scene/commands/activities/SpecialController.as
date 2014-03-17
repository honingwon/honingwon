package sszt.scene.commands.activities
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.marriage.WeddingInfoUpdateEvent;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.scene.IScene;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.acrossServer.AcroSerLeaveIconView;
	import sszt.scene.components.bigBossWar.BigBossWarPanel;
	import sszt.scene.components.copyIsland.CopyIslandFollowPanel;
	import sszt.scene.components.copyIsland.CopyIslandLeaveIconView;
	import sszt.scene.components.copyMoney.ComboBatterPanel;
	import sszt.scene.components.copyMoney.MoneyDuplicatePanel;
	import sszt.scene.components.duplicate.DuplicateChallengePanel;
	import sszt.scene.components.duplicate.DuplicateGuardPanel;
	import sszt.scene.components.duplicate.DuplicateGuardSkillPanel;
	import sszt.scene.components.duplicate.DuplicateMayaPanel;
	import sszt.scene.components.duplicate.DuplicateNormalPanel;
	import sszt.scene.components.duplicate.DuplicatePassPanel;
	import sszt.scene.components.duplicate.HangupCuePanel;
	import sszt.scene.components.guildPVP.GuildPVPPanel;
	import sszt.scene.components.pvpFirst.PvpFirstDuplicatePanel;
	import sszt.scene.components.resourceWar.ResourceWarRankingPanel;
	import sszt.scene.components.shenMoWar.clubWar.ranking.ClubPointWarRankingPanel;
	import sszt.scene.components.shenMoWar.crystalWar.ranking.CrystalWarRankingPanel;
	import sszt.scene.components.shenMoWar.personalWar.ranking.PerWarRankingPanel;
	import sszt.scene.components.shenMoWar.ranking.ShenMoRankingPanel;
	import sszt.scene.components.shenMoWar.ranking.ShenMoRankingTimePanel;
	import sszt.scene.components.specials.CollectCopyView;
	import sszt.scene.components.specials.SpaController;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerReliveSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandMainInfoSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandMonsterCountSocketHandler;
	
	public class SpecialController
	{
		private var _scene:IScene;
		private var _mediator:SceneMediator;
		private var _collectCopyView:CollectCopyView;
		
		private var _shenMoRankingPanel:ShenMoRankingPanel;
		private var _shenMoRankingTimePanel:ShenMoRankingTimePanel;
		
		private var _clubPointWarRankingPanel:ClubPointWarRankingPanel;
		private var _crystalWarRankingPanel:CrystalWarRankingPanel;
		private var _spaController:SpaController;
		private var _acroSerLeaveIconView:AcroSerLeaveIconView;
		private var _copyIslandLeaveIconView:CopyIslandLeaveIconView;
		
		private var _perWarRankingPanel:PerWarRankingPanel;
		private var _resourceWarRankingPanel:ResourceWarRankingPanel;
		private var _pvpFirstDuplicatePanel:PvpFirstDuplicatePanel;
		private var _copyIslandFollowPanel:CopyIslandFollowPanel;
		
		private var _moneyDuplicatePanel:MoneyDuplicatePanel;
		private var _comboBatterPanel:ComboBatterPanel;
		private var _duplicateGuardPanel:DuplicateGuardPanel;
		private var _duplicateGuardSkillPanel:DuplicateGuardSkillPanel;
		private var _duplicateNormalPanel:DuplicateNormalPanel;
		private var _duplicateMayaPanel:DuplicateMayaPanel;
		private var _duplicatePassPanel:DuplicatePassPanel;
		private var _hangupCuePanel:HangupCuePanel;
		private var _duplicateChallengePanel:DuplicateChallengePanel;
		
		private var _bigBossWarPanel:BigBossWarPanel;
		private var _guildPVPPanel:GuildPVPPanel;
		
		public function SpecialController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
		}
		
		public function initScene():void
		{
			if(GlobalData.copyEnterCountList.isCopyCollectScene())
			{
				_collectCopyView = new CollectCopyView(_scene,_mediator);
			}			
			else if(_mediator.sceneInfo.mapInfo.isShenmoDouScene())
			{
				_shenMoRankingPanel = new ShenMoRankingPanel(_mediator);
				_shenMoRankingTimePanel = new ShenMoRankingTimePanel(_mediator);
				GlobalAPI.layerManager.getPopLayer().addChild(_shenMoRankingPanel);
				GlobalAPI.layerManager.getPopLayer().addChild(_shenMoRankingTimePanel);
				GlobalData.warManager.isInShenMoWar = true;
//				_mediator.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMORANKING);
			}
			else if(_mediator.sceneInfo.mapInfo.isClubPointWarScene())
			{
				_clubPointWarRankingPanel = new ClubPointWarRankingPanel(_mediator);
				GlobalAPI.layerManager.getPopLayer().addChild(_clubPointWarRankingPanel);
				GlobalData.warManager.isInClubPointWar = true;
			}
			else if(MapTemplateList.isCrystalWar())
			{
				_crystalWarRankingPanel = new CrystalWarRankingPanel(_mediator);
				GlobalAPI.layerManager.getPopLayer().addChild(_crystalWarRankingPanel);
			}
			else if(_mediator.sceneInfo.mapInfo.isSpaScene())
			{
				_spaController = new SpaController(_scene,_mediator);
			}
			else if(MapTemplateList.isAcrossBossMap())
			{
				_acroSerLeaveIconView = new AcroSerLeaveIconView(_mediator);
				GlobalAPI.layerManager.getPopLayer().addChild(_acroSerLeaveIconView);
			}
			else if(MapTemplateList.isPerWarMap())
			{
				_perWarRankingPanel = new PerWarRankingPanel(_mediator);
				GlobalAPI.layerManager.getPopLayer().addChild(_perWarRankingPanel);
			}
			else if(MapTemplateList.isResourceWarMap())
			{
				_resourceWarRankingPanel = new ResourceWarRankingPanel(_mediator);
				ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
				GlobalAPI.layerManager.getPopLayer().addChild(_resourceWarRankingPanel);
			}
			else if(MapTemplateList.isPVP1Map())
			{
				_pvpFirstDuplicatePanel = new PvpFirstDuplicatePanel(_mediator);
				ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
				GlobalAPI.layerManager.getPopLayer().addChild(_pvpFirstDuplicatePanel);
			}
			else if(MapTemplateList.isWeddingMap())
			{
				if(GlobalData.weddingInfo.isInit)
				{
					//显示婚礼面板
					SetModuleUtils.addMarriage(new ToMarriageData(2));
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
				}
				else
				{
					GlobalData.weddingInfo.addEventListener(WeddingInfoUpdateEvent.INIT, weddingInfoInitHandler);
				}
				function weddingInfoInitHandler(e:Event):void
				{
					GlobalData.weddingInfo.removeEventListener(WeddingInfoUpdateEvent.INIT, weddingInfoInitHandler);
					//显示婚礼面板
					SetModuleUtils.addMarriage(new ToMarriageData(2));
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
				}
			}
			else if(MapTemplateList.isMaya())//玛雅神殿
			{
				if(_duplicateMayaPanel == null)
				{
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
					var copy1:CopyTemplateItem = CopyTemplateList.getCopy(GlobalData.currentMapId);
					_mediator.sceneModule.duplicateMayaInfo.setDuplicateInfo(copy1);
					_duplicateMayaPanel = new DuplicateMayaPanel(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_duplicateMayaPanel);
				}
			}
			else if(MapTemplateList.isNormalDuplicate())//普通副本，如神木崖
			{
				if(_mediator.sceneModule.copyIslandEnterPanel)_mediator.sceneModule.copyIslandEnterPanel.dispose();
				if(_moneyDuplicatePanel == null)
				{
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
					var copy:CopyTemplateItem = CopyTemplateList.getCopy(GlobalData.currentMapId);
					_mediator.sceneModule.duplicateNormalInfo.setDuplicateInfo(copy);
					_duplicateNormalPanel = new DuplicateNormalPanel(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_duplicateNormalPanel);
				}
			}
			else if(MapTemplateList.isPassDuplicate())
			{
				if(_mediator.sceneModule.copyIslandEnterPanel)_mediator.sceneModule.copyIslandEnterPanel.dispose();
				if(_duplicatePassPanel == null)
				{
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
					_mediator.sceneModule.duplicatePassInfo.setDuplicateInfo(GlobalData.currentMapId);
					_duplicatePassPanel = new DuplicatePassPanel(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_duplicatePassPanel);
				}
			}
			else if(MapTemplateList.isMoneyDuplicate())
			{
				if(_mediator.sceneModule.copyIslandEnterPanel)_mediator.sceneModule.copyIslandEnterPanel.dispose();
				if(_moneyDuplicatePanel == null)
				{
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
					_comboBatterPanel = new ComboBatterPanel(_mediator);
					_moneyDuplicatePanel = new MoneyDuplicatePanel(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_comboBatterPanel);
					GlobalAPI.layerManager.getPopLayer().addChild(_moneyDuplicatePanel);
				}
				/**离开图标*/
//				if(_copyIslandLeaveIconView == null)
//				{
//					_copyIslandLeaveIconView = new CopyIslandLeaveIconView(_mediator);
//					GlobalAPI.layerManager.getPopLayer().addChild(_copyIslandLeaveIconView);
//				}
			}
			else if(MapTemplateList.isGuardDuplicate())
			{
				if(_mediator.sceneModule.copyIslandEnterPanel)_mediator.sceneModule.copyIslandEnterPanel.dispose();
				if(_duplicateGuardPanel == null)
				{
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
					_duplicateGuardSkillPanel = new DuplicateGuardSkillPanel(_mediator);
					_duplicateGuardPanel = new DuplicateGuardPanel(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_duplicateGuardPanel);
					GlobalAPI.layerManager.getPopLayer().addChild(_duplicateGuardSkillPanel);
				}				
			}
			else if(MapTemplateList.isShenMoIsland())
			{
				if(_mediator.sceneModule.copyIslandEnterPanel)_mediator.sceneModule.copyIslandEnterPanel.dispose();
				/**神魔岛时间面板**/
				if(_copyIslandFollowPanel == null)
				{
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
					_mediator.copyIslandInfo.initCIMaininfo();//初始化神魔岛面板数据
					_mediator.copyIslandInfo.initCIKingInfo();//初始化神魔岛雕像数据
					_copyIslandFollowPanel = new CopyIslandFollowPanel(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_copyIslandFollowPanel);
				}
				CopyIslandMainInfoSocketHandler.send();//切场景申请数据
				CopyIslandMonsterCountSocketHandler.send(); //申请怪物数量
//				var tmpInfo:CIMaininfo = _mediator.copyIslandInfo.cIMainInfo;
//				if(tmpInfo)CopyIslandKingInfoSocketHandler.send(tmpInfo.stage,GlobalData.currentMapId);			//申请霸主数据
				/**离开图标*/
				if(_copyIslandLeaveIconView == null)
				{
					_copyIslandLeaveIconView = new CopyIslandLeaveIconView(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_copyIslandLeaveIconView);
				}
			}
			else if(MapTemplateList.isChallenge())//试炼副本
			{
				if(_mediator.sceneModule.copyIslandEnterPanel)_mediator.sceneModule.copyIslandEnterPanel.dispose();
				if(_duplicateChallengePanel == null)
				{
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
					_mediator.sceneModule.duplicateChallInfo.setDuplicateInfo(GlobalData.currentMapId);
					_duplicateChallengePanel = new DuplicateChallengePanel(_mediator);
					GlobalAPI.layerManager.getPopLayer().addChild(_duplicateChallengePanel);
				}
			}
			else if(MapTemplateList.isBigBossWar())
			{
				_mediator.sendNotification(SceneMediatorEvent.BIG_BOSS_WAR_START);
			}
			else if(MapTemplateList.isCityCraft())
			{
				_mediator.sendNotification(SceneMediatorEvent.CITY_CRAFT_START);
			}
			else if(MapTemplateList.isGuildPVP())
			{
				_mediator.sendNotification(SceneMediatorEvent.GUILD_PVP_START);
			}
			else if(!MapTemplateList.isShenMoIsland())//清空神魔岛数据
			{
				if(_mediator.sceneModule.copyIslandRelivePanel)
				{
					_mediator.sceneModule.copyIslandRelivePanel.dispose();
					PlayerReliveSocketHandler.sendRelive(1);
				}
				if(_copyIslandFollowPanel)
				{
					_copyIslandFollowPanel.dispose();
					_copyIslandFollowPanel = null;
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
					_mediator.copyIslandInfo.clearCIMaininfo();
					_mediator.copyIslandInfo.clearCIKingInfo();
				}
			}
		}
		
		public function clearScene():void
		{
			if(_collectCopyView)
			{
				_collectCopyView.dispose();
				_collectCopyView = null;
			}
			if(_shenMoRankingPanel)
			{
				_shenMoRankingPanel.dispose();
				_shenMoRankingPanel = null;
				GlobalData.warManager.isInShenMoWar = false;
			}
			if(_shenMoRankingTimePanel)
			{
				_shenMoRankingTimePanel.dispose();
				_shenMoRankingTimePanel = null;
			}
			if(_crystalWarRankingPanel)
			{
				_crystalWarRankingPanel.dispose();
				_crystalWarRankingPanel = null;
			}
			if(_clubPointWarRankingPanel)
			{
				_clubPointWarRankingPanel.dispose();
				_clubPointWarRankingPanel = null;
				GlobalData.warManager.isInClubPointWar = false;
			}
			if(_perWarRankingPanel)
			{
				if(_mediator.sceneModule.perWarRelivePanel)
				{
					_mediator.sceneModule.perWarRelivePanel.dispose();
					_mediator.sceneModule.perWarRelivePanel = null;
				}
				_perWarRankingPanel.dispose();
				_perWarRankingPanel = null;
			}
			if(_duplicateNormalPanel)
			{
				_duplicateNormalPanel.dispose();
				_duplicateNormalPanel = null;
			}
			if(_duplicateMayaPanel)
			{
				_duplicateMayaPanel.dispose();
				_duplicateMayaPanel = null;
			}
			if(_resourceWarRankingPanel)
			{
				_resourceWarRankingPanel.dispose();
				_resourceWarRankingPanel = null;
			}
			if(_pvpFirstDuplicatePanel)
			{
				_pvpFirstDuplicatePanel.dispose();
				_pvpFirstDuplicatePanel = null;
			}
			if(_duplicatePassPanel)
			{
				_duplicatePassPanel.dispose();
				_duplicatePassPanel = null;
			}
			
			if(_duplicateChallengePanel)
			{
				_duplicateChallengePanel.dispose();
				_duplicateChallengePanel = null;
			}
			
			if(_moneyDuplicatePanel)
			{
//				if(_mediator.sceneModule.moneyDuplicatePanel)
//				{
//					_mediator.sceneModule.moneyDuplicatePanel.dispose();
//					_mediator.sceneModule.moneyDuplicatePanel = null;
//				}				
				_moneyDuplicatePanel.dispose();
				_moneyDuplicatePanel = null;
			}
			if(_comboBatterPanel)
			{
//				if(_mediator.sceneModule.comboBatterPanel)
//				{
//					_mediator.sceneModule.comboBatterPanel.dispos();
//					_mediator.sceneModule.comboBatterPanel = null;
//				}
				_comboBatterPanel.dispose();
				_comboBatterPanel = null;
			}
			if(_duplicateGuardSkillPanel)
			{
				_duplicateGuardSkillPanel.dispose();
				_duplicateGuardSkillPanel = null;
			}
			if(_duplicateGuardPanel)
			{
				_duplicateGuardPanel.dispose();
				_duplicateGuardPanel = null;
			}
			
			if(_copyIslandLeaveIconView)
			{
				_copyIslandLeaveIconView.dispose();
				_copyIslandLeaveIconView = null;
			}
			if(_acroSerLeaveIconView)
			{
				_acroSerLeaveIconView.dispose();
				_acroSerLeaveIconView = null;
			}
			if(_spaController)
			{
				_spaController.dispose();
				_spaController = null;
			}
			
		}
	}
}