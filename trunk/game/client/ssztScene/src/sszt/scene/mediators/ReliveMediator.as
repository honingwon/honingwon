package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.scene.SceneModule;
	import sszt.scene.components.relive.PrisonRelivePanel;
	import sszt.scene.components.relive.ReliveBossWarPanel;
	import sszt.scene.components.relive.ReliveCopyIslandPanel;
	import sszt.scene.components.relive.ReliveMoneyPanel;
	import sszt.scene.components.relive.ReliveNormalPanel;
	import sszt.scene.components.relive.RelivePanel;
	import sszt.scene.components.relive.RelivePerWarPanel;
	import sszt.scene.components.relive.ReliveShenMoPanel;
	import sszt.scene.components.relive.ReliveTowerPanel;
	import sszt.scene.components.resourceWar.ResourceWarRelivePanel;
	import sszt.scene.components.shenMoWar.crystalWar.CrystalWarRelivePanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.PlayerReliveSocketHandler;
	
	public class ReliveMediator extends Mediator
	{
		public static const NAME:String = "reliveMediator";
		
		public function ReliveMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWRELIVE,
				SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE,
				SceneMediatorEvent.SHOW_RELIVE_MALERT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWRELIVE:
					initRelivePanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE:
					changeScene();
					break;
				case SceneMediatorEvent.SHOW_RELIVE_MALERT:
					showReliveMalert(notification.getBody() as String);
					break;
			}
		}
		
		private function initRelivePanel():void
		{
			if(MapTemplateList.isShenMoIsland())
			{
				if(sceneModule.copyIslandRelivePanel == null)
				{
					sceneModule.copyIslandRelivePanel = new ReliveCopyIslandPanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.copyIslandRelivePanel);
					sceneModule.copyIslandRelivePanel.addEventListener(Event.CLOSE,reliveCopyIslandPanelCloseHandler);
				}
				return;
			}
			if(MapTemplateList.isCrystalWar())
			{
				if(sceneModule.crystalWarRelivePanel == null)
				{
					sceneModule.crystalWarRelivePanel = new CrystalWarRelivePanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.crystalWarRelivePanel);
					sceneModule.crystalWarRelivePanel.addEventListener(Event.CLOSE,reliveCrystalWarRelivePanelCloseHandler);
				}
				return;
			}
			if(sceneInfo.mapInfo.isShenmoDouScene() || sceneInfo.mapInfo.isClubPointWarScene())
			{
				if(sceneModule.shenMoRelivePanel == null)
				{
					sceneModule.shenMoRelivePanel = new ReliveShenMoPanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.shenMoRelivePanel);
					sceneModule.shenMoRelivePanel.addEventListener(Event.CLOSE,reliveShenMoCloseHandler);
				}
			}
//			else if(GlobalData.copyEnterCountList.isTowerCopy() || GlobalData.copyEnterCountList.isPassCopy())
//			{
//				if(sceneModule.towerRelivePanel == null)
//				{
//					sceneModule.towerRelivePanel = new ReliveTowerPanel(this);
//					GlobalAPI.layerManager.addPanel(sceneModule.towerRelivePanel);
//					sceneModule.towerRelivePanel.addEventListener(Event.CLOSE,towerCloseHandler);
//				}
//			}
			else if(GlobalData.copyEnterCountList.isPVPCopy())
			{
				//不出现复活界面
			}
			else if(GlobalData.copyEnterCountList.isNormalCopy() || GlobalData.copyEnterCountList.isPassCopy() || GlobalData.copyEnterCountList.isChallengeCopy() ||
				MapTemplateList.isClubCamp() || MapTemplateList.isMarryMap() || MapTemplateList.isMaya()
			)
			{
				if(sceneModule.normalRelivePanel == null)
				{
					sceneModule.normalRelivePanel = new ReliveNormalPanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.normalRelivePanel);
					sceneModule.normalRelivePanel.addEventListener(Event.CLOSE,normalCloseHandler);
				}
			}
			else if(GlobalData.copyEnterCountList.isMoneyCopy() || GlobalData.copyEnterCountList.isTowerCopy()
						|| GlobalData.copyEnterCountList.isTreasureCopy() || MapTemplateList.isClubCamp())
			{
				if(sceneModule.moneyRelivePanel == null)
				{
					sceneModule.moneyRelivePanel = new ReliveMoneyPanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.moneyRelivePanel);
					sceneModule.moneyRelivePanel.addEventListener(Event.CLOSE,moneyCloseHandler);
				}
			}
			else if(MapTemplateList.isPerWarMap())
			{
				if(sceneModule.perWarRelivePanel == null)
				{
					sceneModule.perWarRelivePanel = new RelivePerWarPanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.perWarRelivePanel);
					sceneModule.perWarRelivePanel.addEventListener(Event.CLOSE,relivePerWarCloseHandler);
				}
			}
			else if(sceneInfo.mapInfo.isBossWar())
			{
				if(sceneModule.bossWarRelivePanle == null)
				{
					sceneModule.bossWarRelivePanle = new ReliveBossWarPanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.bossWarRelivePanle);
					sceneModule.bossWarRelivePanle.addEventListener(Event.CLOSE,reliveBossWarCloseHandler);
				}
			}
			else if(GlobalData.copyEnterCountList.isPKCopy())
			{
				relive(1);
			}else if(MapTemplateList.getIsPrison())
			{
				if(sceneModule.prisonRelivePanel == null)
				{
					sceneModule.prisonRelivePanel = new PrisonRelivePanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.prisonRelivePanel);
					sceneModule.prisonRelivePanel.addEventListener(Event.CLOSE,prisonCloseHandler);
				}
			}
			else if(MapTemplateList.isResourceWarMap() || MapTemplateList.isBigBossWar() ||MapTemplateList.isGuildPVP()||MapTemplateList.isCityCraft())
			{
				if(sceneModule.resourceWarRelivePanel == null)
				{
					sceneModule.resourceWarRelivePanel = new ResourceWarRelivePanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.resourceWarRelivePanel);
					sceneModule.resourceWarRelivePanel.addEventListener(Event.CLOSE,resourceWarRelivePanelCloseHandler);
				}
			}
			else if(MapTemplateList.isPVP1Map())
			{
				if(sceneModule.resourceWarRelivePanel == null)
				{
					sceneModule.resourceWarRelivePanel = new ResourceWarRelivePanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.resourceWarRelivePanel);
					sceneModule.resourceWarRelivePanel.addEventListener(Event.CLOSE,resourceWarRelivePanelCloseHandler);
				}
			}
			else
			{
				if(sceneModule.relivePanel || sceneModule.shenMoRelivePanel || sceneModule.perWarRelivePanel || sceneModule.bossWarRelivePanle||sceneModule.towerRelivePanel)return;
				if(sceneModule.relivePanel == null)
				{
					sceneModule.relivePanel = new RelivePanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.relivePanel);
					sceneModule.relivePanel.addEventListener(Event.CLOSE,reliveCloseHandler);
				}
			}
		}
		
		private function towerCloseHandler(evt:Event):void
		{
			if(sceneModule.towerRelivePanel)
			{
				sceneModule.towerRelivePanel.removeEventListener(Event.CLOSE,towerCloseHandler);
				sceneModule.towerRelivePanel = null;
			}
		}
		private function normalCloseHandler(evt:Event):void
		{
			if(sceneModule.normalRelivePanel)
			{
				sceneModule.normalRelivePanel.removeEventListener(Event.CLOSE,normalCloseHandler);
				sceneModule.normalRelivePanel = null;
			}
		}
		
		private function moneyCloseHandler(evt:Event):void
		{
			if(sceneModule.moneyRelivePanel)
			{
				sceneModule.moneyRelivePanel.removeEventListener(Event.CLOSE,moneyCloseHandler);
				sceneModule.moneyRelivePanel = null;
			}
		}
		private function prisonCloseHandler(evt:Event):void
		{
			if(sceneModule.prisonRelivePanel)
			{
				sceneModule.prisonRelivePanel.removeEventListener(Event.CLOSE,prisonCloseHandler);
				sceneModule.prisonRelivePanel = null;
			}
		}
		
		private function resourceWarRelivePanelCloseHandler(evt:Event):void
		{
			if(sceneModule.resourceWarRelivePanel)
			{
				sceneModule.resourceWarRelivePanel.removeEventListener(Event.CLOSE,resourceWarRelivePanelCloseHandler);
				sceneModule.resourceWarRelivePanel = null;
			}
		}
		
		private function reliveCloseHandler(evt:Event):void
		{
			if(sceneModule.relivePanel)
			{
				sceneModule.relivePanel.removeEventListener(Event.CLOSE,reliveCloseHandler);
				sceneModule.relivePanel = null;
			}
		}
		
		private function relivePerWarCloseHandler(evt:Event):void
		{
			if(sceneModule.perWarRelivePanel)
			{
				sceneModule.perWarRelivePanel.removeEventListener(Event.CLOSE,relivePerWarCloseHandler);
				sceneModule.perWarRelivePanel = null;
			}
		}
		
		private function reliveShenMoCloseHandler(evt:Event):void
		{
			if(sceneModule.shenMoRelivePanel)
			{
				sceneModule.shenMoRelivePanel.removeEventListener(Event.CLOSE,reliveShenMoCloseHandler);
				sceneModule.shenMoRelivePanel = null;
			}
		}
		
		private function reliveCrystalWarRelivePanelCloseHandler(evt:Event):void
		{
			if(sceneModule.crystalWarRelivePanel)
			{
				sceneModule.crystalWarRelivePanel.removeEventListener(Event.CLOSE,reliveCrystalWarRelivePanelCloseHandler);
				sceneModule.crystalWarRelivePanel = null;
			}
		}
		
		private function reliveCopyIslandPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.copyIslandRelivePanel)
			{
				sceneModule.copyIslandRelivePanel.removeEventListener(Event.CLOSE,reliveCopyIslandPanelCloseHandler);
				sceneModule.copyIslandRelivePanel = null;
			}
		}
		
		private function reliveBossWarCloseHandler(evt:Event):void
		{
			if(sceneModule.bossWarRelivePanle)
			{
				sceneModule.bossWarRelivePanle.removeEventListener(Event.CLOSE,reliveBossWarCloseHandler);
				sceneModule.bossWarRelivePanle = null;
			}
		}
		
		private function changeScene():void
		{
			if(sceneModule.relivePanel)
			{
				sceneModule.relivePanel.removeEventListener(Event.CLOSE,reliveCloseHandler);
				sceneModule.relivePanel.dispose();
				sceneModule.relivePanel = null;
			}
			if(sceneModule.shenMoRelivePanel)
			{
				sceneModule.shenMoRelivePanel.removeEventListener(Event.CLOSE,reliveShenMoCloseHandler);
				sceneModule.shenMoRelivePanel.dispose();
				sceneModule.shenMoRelivePanel = null;
			}
//			if(sceneModule.towerRelivePanel)
//			{
//				sceneModule.towerRelivePanel.removeEventListener(Event.CLOSE,towerCloseHandler);
//				sceneModule.towerRelivePanel.dispose();
//				sceneModule.towerRelivePanel = null;
//			}
		}
		
		private function showReliveMalert(nick:String):void
		{
			if(sceneModule.relivePanel)
			{
				sceneModule.relivePanel.showAlert(nick);
			}
		}
		
		public function relive(type:int):void
		{
			PlayerReliveSocketHandler.sendRelive(type);
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