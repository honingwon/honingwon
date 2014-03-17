package sszt.core.data.deploys.deployHandlers
{
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.PopUpDeployType;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToConsignData;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.data.module.changeInfos.ToSettingData;
	import sszt.core.data.module.changeInfos.ToSkillData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.module.changeInfos.ToWareHouseData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.PrisonLeaveSocketHandler;
	import sszt.core.socketHandlers.vip.VipMapLeaveSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.MayaCopyEntranceView;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class PopupDeployHandler extends BaseDeployHandler
	{
		public function PopupDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.POPUP;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			switch(info.param1)
			{
				case ModuleType.NPCSTORE:
					SetModuleUtils.addNPCStore(new ToNpcStoreData(info.param2,info.param4));
					break;
				case ModuleType.DUPLICATESTORE:
					SetModuleUtils.addDuplicateStore(new ToStoreData(info.param2,info.param4));
					break;
				case ModuleType.ROLE:
					SetModuleUtils.addRole(GlobalData.selfPlayer.userId,info.param2);
					break;
				case ModuleType.BAG:
					SetModuleUtils.addBag();
					break;
				case ModuleType.SKILL:
					SetModuleUtils.addSkill(new ToSkillData(info.param2));
					break;
				case ModuleType.CLUB:
					SetModuleUtils.addClub(info.param2,info.param3);
					break;
				case ModuleType.WAREHOUSE:
					SetModuleUtils.addWareHouse(new ToWareHouseData(info.param4));
					break;
				case ModuleType.STORE:
					SetModuleUtils.addStore(new ToStoreData( info.param2,info.param3));
					break;
				case PopUpDeployType.NPC_POP_PANEL:
					if(info.param2 == 2 && GlobalData.selfPlayer.level < 40)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.transportNeedLevel40"));
					}
					else
					{
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.OPEN_NPC_POPPANEL,{type:info.param2,npcId:info.param3}));
					}
					break;
				case PopUpDeployType.NPC_COPY_ENTER:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_NPC_COPY_PANEL,{npcId:info.param2,levelId:info.param3,copyType:info.param4}));
					break;
				case PopUpDeployType.COPY_SCENE_EVENT:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_COPY_ACTION,info.param2));
					break;
				case PopUpDeployType.TRANSPORT_PANEL:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_TRANSPORT_PANEL));
					break;
				case PopUpDeployType.CLUB_SCENE_LEAVE:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CLUB_SCENE_LEAVE_PANEL,info.param2));
					break;
				case PopUpDeployType.CLUB_SCENE_ENTER:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CLUB_SCENE_ENTER_PANEL,info.param2));
					break;
				case PopUpDeployType.VIP_SCENE_LEAVE:
					MAlert.show(LanguageManager.getWord("ssztl.core.sureLeaveVipMap"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,vipSceneLeaveHandler);
					break;
				case PopUpDeployType.SPA_SCENE_ENTER:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_SPA_COPY_PANEL));
					break;
				case PopUpDeployType.SPA_SCENE_LEAVE:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_SPA_COPY_LEAVE));
					break;
				case ModuleType.ACTIVITY:
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.MAIN,0));
					break;
				case ModuleType.FURNACE:
					SetModuleUtils.addFurnace(info.param2);
					break;
				case ModuleType.CONSIGN:
					SetModuleUtils.addConsign(new ToConsignData(info.param2));
					break;
				case ModuleType.SETTING:
					SetModuleUtils.addSetting(new ToSettingData(info.param2));
					break;
				case ModuleType.BOX:
					SetModuleUtils.addBox(info.param2);
					break;
				case PopUpDeployType.ACCEPT_TRANSPORT_PANEL:
					if(GlobalData.selfPlayer.level < 40)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.transportNeedLevel40"));
					}
					else
					{
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ACCEPT_TRANSPORT_PANEL));
					}
					break;
				case ModuleType.PET:
					SetModuleUtils.addPet(new ToPetData(info.param2,0,0,0,-1,info.param3==1));
					break;
				case PopUpDeployType.PRISON_LEAVE:
					if(GlobalData.selfPlayer.PKValue >= 80)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.pkValueVeryHigh"));
						return;
					}
					MAlert.show(LanguageManager.getWord("ssztl.common.sureLeavePrison"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,prisonLeaveHandler);
					break;
				case ModuleType.FIREBOX:
					SetModuleUtils.addFireBox();
					break;
				case ModuleType.MOUNTS:
					SetModuleUtils.addMounts(new ToMountsData(0,0,0,0,-1,info.param2==1));
					break;
				
				case ModuleType.SWORDSMAN:
					SetModuleUtils.addSwordsman();
					break;
				case PopUpDeployType.SHOW_CLUMBING_TOWER:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CLIMBING_TOWER));
					break;
				case PopUpDeployType.SHOW_RESOURCE_WAR_ENTRANCE_PANEL:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_RESOURCE_WAR_ENTRANCE_PANEL));
					break;
				case PopUpDeployType.SHOW_MARRIAGE_ENTRANCE_PANEL:
//					QuickTips.show('功能尚未开放，敬请期待！');
					SetModuleUtils.addMarriage(new ToMarriageData(0));
					break;
				case PopUpDeployType.SHOW_PVP_FIRST_ENTRANCE_PANEL:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_PVP_FIRST_ENTRANCE_PANEL));
					break;
				case PopUpDeployType.SHOW_MAYA_PANEL:
					MayaCopyEntranceView.getInstance().show(function():void{
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_NPC_COPY_PANEL,{npcId:info.param2,levelId:0,copyType:0}));
					});
					break;
				case PopUpDeployType.SHOW_CITY_CRAFT_ENTRANCE_PANEL:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CITY_CRAFT_ENTRANCE_PANEL));
					break;
				case PopUpDeployType.SHOW_CITY_CRAFT_CALL_BOSS_PANEL:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CITY_CRAFT_CALL_BOSS_PANEL));
					break;
				case PopUpDeployType.SHOW_CITY_CRAFT_MANAGE_PANEL:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CITY_CRAFT_MANAGE_PANEL));
					break;
				case PopUpDeployType.SHOW_GUILD_PVP_ENTER_PANEL:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_GUILD_PVP_ENTER_PANEL));
			}
		}
		
		private function prisonLeaveHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				PrisonLeaveSocketHandler.send();
			}
		}
		
		private function vipSceneLeaveHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				VipMapLeaveSocketHandler.send();							
			}
		}
	}
}