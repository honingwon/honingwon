package sszt.core.utils
{
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.PetStateType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.socketHandlers.pet.PetCallSocketHandler;
	import sszt.core.socketHandlers.pet.PetChangeStyleSocketHandler;
	import sszt.core.socketHandlers.pet.PetStudySkillSocketHandler;
	import sszt.core.socketHandlers.shenmoling.UseShenMoLingHandler;
	import sszt.core.socketHandlers.vip.VipCardUseSocketHandler;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.shenmoling.ShenMoLingPanel;
	import sszt.events.CellEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class CellDoubleClickHandler
	{
		public static function setup():void
		{
			ModuleEventDispatcher.addCellEventListener(CellEvent.CELL_DOUBLECLICK,cellDoubleClickHandler,false);
		}
		
		private static function cellDoubleClickHandler(evt:CellEvent):void
		{
			evt.stopImmediatePropagation();
			var cell:IDragable = evt.data as IDragable;
			if(!cell)return;
			switch(cell.getSourceType())
			{
				case CellType.BAGCELL:
					handleBagCell(cell);
					break;
				case CellType.ROLECELL:
					unloadEquipment(cell);
					break;
				case CellType.PET_EQUIP:
					unloadPetEquipment(cell);
					break;
				default:
					break;
			}
		}
		
		private static function unloadPetEquipment(cell:IDragable):void
		{
			var sourceData:Object = cell.getSourceData();
			if(!sourceData)return;
			var pet:PetItemInfo = GlobalData.petList.getFightPet();
			if(!pet)
				QuickTips.show('对不起，您只能卸下出战宠物身上的装备。');
			else
			{
				ItemMoveSocketHandler.sendItemMove(CommonBagType.PET_BAG,sourceData.place,CommonBagType.BAG,1000,pet.id);
			}
		}
		
		private static function handleBagCell(cell:IDragable):void
		{
			var sourceData:ItemInfo = cell.getSourceData() as ItemInfo;
			if(!sourceData)return;
			//之后还有其他操作，如续费，过期等
			if(GlobalData.isInTrade)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.inExchange"));
				return;
			}
			if(sourceData.template.canUse)
			{
				useItem(sourceData,true);
			}
			else if(CategoryType.isPetEquip(sourceData.template.categoryId))
			{
				var pets:Array = GlobalData.petList.getList();
				if(pets.length == 0)
				{
					QuickTips.show('对不起，你没有宠物，无法使用此装备。');
					return;
				}
				var fightPet:PetItemInfo = GlobalData.petList.getFightPet();
				if(!fightPet)
				{
					QuickTips.show('对不起，您只能给出战的宠物穿装备。');
					return;
				}
				if(fightPet.level < sourceData.template.needLevel)
				{
					QuickTips.show('对不起，你当前宠物等级不足，无法使用此装备。');
					return;
				}
				if(sourceData.template.bindType == 0 && !sourceData.isBind)
				{
					MAlert.show(LanguageManager.getWord("ssztl.common.wearChangeBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,useEquipAlertHandler2);
					return;
					function useEquipAlertHandler2(evt:CloseEvent):void
					{
						if(evt.detail == MAlert.OK)
						{
							ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.PET_BAG,29,fightPet.id);
						}
					}
				}
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.PET_BAG,29,fightPet.id);
			}
			else if(CategoryType.isEquip(sourceData.template.categoryId))
			{
				if(GlobalData.selfScenePlayerInfo.getIsFight())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.cannotChangeEquip"));
					return;
				}
				if(sourceData.template.needCareer != 0&&sourceData.template.needCareer != GlobalData.selfPlayer.career)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.careerNotFit"));
					return ;
				}
				if(sourceData.template.needSex != 0&& sourceData.template.needSex != GlobalData.selfPlayer.getSex())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.sexNotFit"));
					return ;
				}
				if(sourceData.template.needLevel >GlobalData.selfPlayer.level)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.levelNotEnough"));
					return ;
				}
				if(sourceData.template.durable != -1 && sourceData.durable == 0)
				{
					QuickTips.show("sszt.common.durabilityZero");
					return ;
				}
				if(sourceData.template.bindType == 0 && !sourceData.isBind)
				{
					MAlert.show(LanguageManager.getWord("ssztl.common.wearChangeBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,useEquipAlertHandler);
					return;
					function useEquipAlertHandler(evt:CloseEvent):void
					{
						if(evt.detail == MAlert.OK)
						{
							ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.BAG,29,1);
						}
					}
				}
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.BAG,29,1);
			}
			if(sourceData.template.categoryId != 0)  
			{ 
				openPanel(sourceData.template.categoryId);
			}
		}
		
		/**
		 * 更具category打开不同的面板
		 * @param category 类型
		 * 
		 */
		public static function openPanel(category:int):void
		{
			switch(category)
			{
				case CategoryType.MUNTS:   // 坐骑
					SetModuleUtils.addMounts(new ToMountsData(0));
					break;
				case CategoryType.STILETTO:
					SetModuleUtils.addFireBox(0,2);
					break;
				case CategoryType.UPGRADE:
					SetModuleUtils.addFurnace(2);
					break;
				case CategoryType.STRENGTH:
					SetModuleUtils.addFurnace(0);
					break;
				case CategoryType.REBUILD:
					SetModuleUtils.addFurnace(1);
					break;
				case CategoryType.ENCHASEATTACK:
				case CategoryType.ENCHASEDEFENSE:
				case CategoryType.ENCHASEMUMPHURT:
				case CategoryType.ENCHASEMUMPDEFENSE:
				case CategoryType.ENCHASEMAGICHURT:
				case CategoryType.ENCHASEMAGICDEFENSE:
				case CategoryType.ENCHASEFARHURT:
				case CategoryType.ENCHASEFARDEFENSE:
				case CategoryType.ENCHASEHITTARGET:
				case CategoryType.ENCHASEDUCK:
				case CategoryType.ENCHASEDELIGENCY:
				case CategoryType.ENCHASEPOWERHIT:
				case CategoryType.ENCHASEBLUE:
				case CategoryType.ENCHASERED:
					SetModuleUtils.addFurnace(4);
					break;
				case CategoryType.SHENMOLINE:
				case CategoryType.PURPLE_CRYSTAL:
				case CategoryType.UPGRADE_UPLEVEL:
				case CategoryType.COLLECT:
					SetModuleUtils.addFireBox(3,0);
					break;
				case CategoryType.STUFF:
					SetModuleUtils.addFireBox(0,1);
					break;
				case CategoryType.UPGRADE_SYMBOL:
					SetModuleUtils.addRole(GlobalData.selfPlayer.userId,1);
					break;
				case CategoryType.STONEPICKSYMBOL:
					SetModuleUtils.addFurnace(5);
					break;
//				case CategoryType.SHENMOLINE:
//					SetModuleUtils.addFurnace(6);
//					break;
				case CategoryType.PET_EGG:
				case 542:
//					SetModuleUtils.addPet();
					break;
				case CategoryType.MOUNTS_EXP_DRUG:
					if(GlobalData.mountsList.mountsCount > 0)
					{
						SetModuleUtils.addMounts(new ToMountsData());
						SetModuleUtils.addMounts(new ToMountsData(0,1,0,0));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.mounts.none2'));
					}
					
					break;
				case CategoryType.PET_QUALITY_SYMBOL:
					SetModuleUtils.addFireBox(2,0);
					break;
				case CategoryType.PET_LUCK_SYMBOL:
					if(GlobalData.petList.petCount > 0)
					{
						SetModuleUtils.addPet(new ToPetData(0,0,0,0,1));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.pet.hasNoPet2'));
					}
					break;
				case CategoryType.PET_PROTECTED_SYMBOL:
					if(GlobalData.petList.petCount > 0)
					{
						SetModuleUtils.addPet(new ToPetData(0,0,0,0,2));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.pet.hasNoPet2'));
					}
					break;
				case CategoryType.PET_ADVANCED_DRUG:
					if(GlobalData.petList.petCount > 0)
					{
						SetModuleUtils.addPet(new ToPetData(1,0,0,0,-1));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.pet.hasNoPet2'));
					}
					break;
				case CategoryType.PET_OPEN_HOLE_SYMBOL:
				case CategoryType.PET_SKILL_BOOK:
					if(GlobalData.petList.petCount > 0)
					{
						SetModuleUtils.addPet(new ToPetData(2,0,0,0,-1));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.pet.hasNoPet2'));
					}
					break;
				case CategoryType.PET_SKILL_BOOK_INCOMPLETE_PAGES:
					SetModuleUtils.addFireBox(2,1);
					break;
				case CategoryType.STRENGTHNEWPROTECTSYMBOL:
					SetModuleUtils.addFireBox(1,0);
					break;
				case CategoryType.MOUNTS_SKILL_BOOK_FOOD://坐骑技能书
					if(GlobalData.mountsList.mountsCount > 0)
					{
						SetModuleUtils.addMounts(new ToMountsData(2,0));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.mounts.none2'));
					}
					break;
				case CategoryType.MOUNTS_SKILL_BOOK_INCOMPLETE_PAGES:
					SetModuleUtils.addFireBox(1,1);
					break;
				case CategoryType.MOUNTS_QUALIFICATION_DRUG:
				case CategoryType.MOUNTS_QUALIFICATIONW_SYMBOL:
					if(GlobalData.mountsList.mountsCount > 0)
					{
						SetModuleUtils.addMounts(new ToMountsData(0,0,0,0,2));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.mounts.none2'));
					}
					break;
				case CategoryType.MOUNTS_GROW_DRUG:
				case CategoryType.MOUNTS_GROW_SYMBOL_TYPE:
					if(GlobalData.mountsList.mountsCount > 0)
					{
						SetModuleUtils.addMounts(new ToMountsData(0,0,0,0,1));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.mounts.none2'));
					}
					break;
				case CategoryType.MOUNTS_SKILL_SYMBOL:
					if(GlobalData.mountsList.mountsCount > 0)
					{
						SetModuleUtils.addMounts(new ToMountsData(2,0));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.mounts.none2'));
					}
					
					break;
				case CategoryType.MOUNTS_ADVANCED_DRUG:
				
					if(GlobalData.mountsList.mountsCount > 0)
					{
						SetModuleUtils.addMounts(new ToMountsData(1,0));
					}
					else
					{
						QuickTips.show(LanguageManager.getWord('ssztl.mounts.none2'));
					}
					break;
				case CategoryType.ROSE:
//					SetModuleUtils.addMounts(new ToMountsData(0,1));
					ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_GIVE_FLOWERS_PANEL,{id:0,nick:0}));
					break;
				case CategoryType.UPGRADE_SYMBOL1:
					SetModuleUtils.addRole(GlobalData.selfPlayer.userId,1);
					break;
				case 574:
					SetModuleUtils.addBox(1);
					break;
			}
		}
		
		/**
		 * 使用物品 
		 * @param item
		 * @param failTip失败提示
		 * 
		 */	
		public static function useItem(item:ItemInfo,failTip:Boolean = false):void
		{
			var drugType:int = 0;
			var selfSceneInfo:BaseRoleInfo = GlobalData.selfScenePlayerInfo;
			if(selfSceneInfo.getIsDeadOrDizzy())
			{
				if(!(selfSceneInfo.state.getHangup() || selfSceneInfo.state.getPickUp()))QuickTips.show(LanguageManager.getWord("ssztl.scene.unOperateInHitDownState"));
				return;
			}
			if(CategoryType.getIsCarry(item.template.categoryId))
			{
				if(MapTemplateList.getIsPrison())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
					return;
				}
				if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
					return;
				}
				else if(GlobalData.taskInfo.getTransportTask() != null)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.transporting"));
					return;
				}
				else if(GlobalData.selfScenePlayerInfo.getIsFight())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.inWarState"));
					return;
				}
			}
			if(item.template.categoryId == CategoryType.LIFEEXPERIENCEMEDICINE && GlobalData.selfPlayer.PKValue >=11)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.redNameState"));
				return;
			}
			if(item.template.categoryId == CategoryType.LIFEEXPERIENCEMEDICINE && ((item.template.property1+GlobalData.selfPlayer.lifeExperiences) > GlobalData.selfPlayer.totalLifeExperiences))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.lifeExperiencesState"));
				return;
			}
			if(item.template.categoryId == CategoryType.REDUCE_PK_VALUE && GlobalData.selfPlayer.PKValue == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.pkValueZero"));
				return;
			}
			if(item.template.categoryId == CategoryType.SKILLBOOKPLAYER)
			{
				var skillId:int = item.template.property1;
				var skill:SkillItemInfo = GlobalData.skillInfo.getSkillById(skillId);
				if(skill != null)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.core.learnedSkill"));
					return;
				}
			}
			if(item.template.needLevel > GlobalData.selfPlayer.level)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.levelNotEnough"));
				return ;
			}
			if(CategoryType.isHpDrup(item.template.categoryId))
			{
				drugType = 1;
			}
			else if(CategoryType.isMpDrup(item.template.categoryId))
			{
				drugType = 2;
			}
			else if (CategoryType.isTreasureMap(item.template.categoryId))
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.OPEN_TREASURE_MAP, item));
				return;
			}
			else if(CategoryType.SHENMOLINE == item.template.categoryId)
			{
				if(item.enchase1 == -1)
				{
					var list:Array = TaskTemplateList.getShenMoLingListByLevel(GlobalData.selfPlayer.level);
					if(list == null || list.length == 0)
					{
//						QuickTips.show(LanguageManager.getWord("ssztl.core.noShenMoLingTask"));
					}
					else
					{
						var randomIndex:int = Math.floor(Math.random()* list.length);
						UseShenMoLingHandler.sendShenMoLingTask((list[randomIndex] as TaskTemplateInfo).taskId, item.itemId);
					}	
				}
				else
				{
					var shenMOLingPanel:ShenMoLingPanel = new ShenMoLingPanel(item);
					GlobalAPI.layerManager.addPanel(shenMOLingPanel);
				}
				return;
			}
			if(drugType != 0 && !item.getCanUse())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.unColdDown"));
				return;
			}
			if(item.template.categoryId == CategoryType.VIP)
			{
				if(GlobalData.functionYellowEnabled && GlobalData.tmpIsYellowVip == 0 && 
					(item.templateId == CategoryType.VIP_WEEK_CARD || item.templateId == CategoryType.VIP_MONTH_CARD || item.templateId == CategoryType.VIP_YEAR_CARD))
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.noYellowVip"));//ssztl.common.noYellowVip:非黄钻用户不能购买或使用VIP卡
					return;
				}
				
				if(GlobalData.selfPlayer.getVipType() == VipType.NORMAL)
				{
					VipCardUseSocketHandler.send(item.place);
				}
				else
				{
					var cardLevel:int;
					var myVipType:int = GlobalData.selfPlayer.getVipType();
					var myLevel:int = myVipType;
					if(item.templateId == CategoryType.VIP_WEEK_CARD) cardLevel = VipType.VIP;
					if(item.templateId == CategoryType.VIP_MONTH_CARD) cardLevel = VipType.BETTERVIP;
					if(item.templateId == CategoryType.VIP_YEAR_CARD) cardLevel = VipType.BESTVIP;
					if(item.templateId == CategoryType.VIP_DAY_CARD) cardLevel = -1;
					if(item.templateId == CategoryType.VIP_HOUR_CARD) cardLevel = -2;
					
					if(myVipType == VipType.OneDay) myLevel = -1;
					if(myVipType == VipType.OneHour) myLevel = -2;
					
					
					if(myLevel == cardLevel)
					{
						VipCardUseSocketHandler.send(item.place);
//						ItemUseSocketHandler.sendItemUse(item.place);
					}else if(myLevel > cardLevel)
					{
						MAlert.show(LanguageManager.getWord("ssztl.core.maxVip"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK);
					}else
					{
						var message:String = item.template.name;
						
						var id:int;
						if(GlobalData.selfPlayer.getVipType() == VipType.VIP) id = CategoryType.VIP_WEEK_CARD;
						else if(GlobalData.selfPlayer.getVipType() == VipType.BETTERVIP) id = CategoryType.VIP_MONTH_CARD;
						else if(GlobalData.selfPlayer.getVipType() == VipType.BESTVIP) id = CategoryType.VIP_YEAR_CARD;
						else if(GlobalData.selfPlayer.getVipType() == VipType.OneDay) id = CategoryType.VIP_DAY_CARD;
						else if(GlobalData.selfPlayer.getVipType() == VipType.OneHour) id = CategoryType.VIP_HOUR_CARD;
						var message1:String = ItemTemplateList.getTemplate(id).name;
						
						MAlert.show(LanguageManager.getWord("ssztl.common.useXWillReplaceY",message,message1),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,vipUseCloseHandler);
						function vipUseCloseHandler(evt:CloseEvent):void
						{
							if(evt.detail == MAlert.OK)
							{
								VipCardUseSocketHandler.send(item.place);
							}
						}
					}		
				}
				return;
			}
			if(item.template.categoryId == CategoryType.BUFF)
			{
				if(item.template.needCareer != 0 && item.template.needCareer != GlobalData.selfPlayer.career)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.careerNotFit"));
					return ;
				}
				var buff:BuffTemplateInfo = BuffTemplateList.getBuff(item.template.property5);
				var buffItem:BuffItemInfo = selfSceneInfo.getBuffByType(buff.type);
				if(buffItem)
				{
					var upToLimit:Boolean = false;
					if(buffItem.getTemplate().limitTotalTime > -1)
					{
						if(!buffItem.getTemplate().getIsTime())
						{
							upToLimit = buffItem.remain + buff.valieTime >= buffItem.getTemplate().limitTotalTime;
						}
						else
						{
							var start:Number;
							if(buffItem.isPause)
							{
								start = buffItem.pauseTime.getTime();
							}
							else start = GlobalData.systemDate.getSystemDate().getTime();
							upToLimit = (buffItem.endTime.getTime() - start + buff.valieTime) >= buffItem.getTemplate().limitTotalTime;
						}
					}
					if(upToLimit)
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.bufferAchieveMax",buff.name));
						return;
					}
					if( buffItem.templateId != buff.templateId )
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.isSureReplaceEffect",buff.name,buffItem.getTemplate().name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
						return;
					}
				}
			}
			if(CategoryType.PET_SKILL_BOOK == item.template.categoryId)
			{
				usePetSkillBook(item);
				return;
			}
			if(item.template.templateId == CategoryType.LITTLE_REDUCE_PK)
			{
				if(GlobalData.selfPlayer.PKValue < 10)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.notMatchUseCondition"));
					return;
				}
			}
			
		
			
			if(CategoryType.isPetEgg(item.template.categoryId))
			{
				if(CategoryType.isWhiteEgg(item.templateId))
				{
					if(GlobalData.petList.petCount >= 3)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.core.petAchevieMaxNum"));
						return;
					}
				}
				PetCallSocketHandler.send(item.itemId);
//				SetModuleUtils.addPet();
				return;
			}
			if(CategoryType.isPetStyleSymbol(item.template.categoryId))
			{
				var pet:PetItemInfo = GlobalData.petList.getFightPet();
				if(pet == null)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.core.forOutPet"));
					return;
				}
				MAlert.show(LanguageManager.getWord("ssztl.core.isChangePetShape"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,changeStyleAlertHandler);
				function changeStyleAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.YES)
					{
						PetChangeStyleSocketHandler.send(pet.id,item.itemId,item.templateId);
					}
				}
				return;
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					doUse();
				}
			}
			doUse();
			//能否使用
			function doUse():void
			{
				if(CategoryType.getIsCarry(item.template.categoryId))
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CLEAR_WALK_PATH));
				}
				ItemUseSocketHandler.sendItemUse(item.place);
				if(drugType == 1)
				{
					GlobalData.lastUseTime_hp = getTimer();
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UPDATE_ITEM_CD,1));
				}
				else if(drugType == 2)
				{
					GlobalData.lastUseTime_mp = getTimer();
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UPDATE_ITEM_CD,2));
				}
			}
		}
		
		private static function usePetSkillBook(item:ItemInfo):void
		{
			var pet:PetItemInfo = GlobalData.petList.getFightPet();
			if(!pet)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.skillForOutPet"));
				return;
			}
			
			PetStudySkillSocketHandler.send( item.place);
			
//			if(!pet.hasSkillSpace(item.template.property2))
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.core.needPetSkillhole"));
//				return;
//			}
//			if(pet.hasSameSkill(item.template.property2,item.template.property3))
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.core.petLearnedSkill"));
//				return;
//			}
//			if(!pet.canStudyLow(item.template.property2,item.template.property3))
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.core.petLearnedMaxSkill"));
//				return;
//			}
//			if(!pet.canStudyHigh(item.template.property2,item.template.property3))
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.core.learnLowPetSkillFirst"));
//				return;
//			}
//			
//			if(item.template.property3 == 1) PetStudySkillSocketHandler.send(pet.id, item.itemId,item.templateId);
//			else 
//			{
//				PetSkillUpdateLevelSocketHandler.send(pet.id,pet.getLearnSkillPlace(item.template.property2),item.itemId,item.templateId);
//			}
		}
		
		private static function unloadEquipment(cell:IDragable):void
		{
			var sourceData:ItemInfo = cell.getSourceData() as ItemInfo;
			if(!sourceData)return;
			ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.BAG,1000,1);
		}
	}
}