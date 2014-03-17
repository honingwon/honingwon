package sszt.core.utils
{
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToBagData;
	import sszt.core.data.module.changeInfos.ToBoxData;
	import sszt.core.data.module.changeInfos.ToClubData;
	import sszt.core.data.module.changeInfos.ToFireBoxData;
	import sszt.core.data.module.changeInfos.ToFurnaceData;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.data.module.changeInfos.ToPersonalData;
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.data.module.changeInfos.ToRoleChoiseData;
	import sszt.core.data.module.changeInfos.ToRoleData;
	import sszt.core.data.module.changeInfos.ToSceneData;
	import sszt.core.data.module.changeInfos.ToStallData;
	import sszt.core.data.module.changeInfos.ToSwordsmanData;
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;

	public class SetModuleUtils
	{
		public static function setToScene(toScene:ToSceneData):void
		{
			GlobalAPI.moduleManager.setModule(ModuleType.SCENE,null,toScene,null,null,false);
		}
		
		public static function setToRoleChoise(toRoleChoiseData:ToRoleChoiseData):void
		{
//			GlobalAPI.moduleManager.setModule(ModuleType.ROLECHOISE,null,toRoleChoiseData);
		}
		
		public static function addNavigation():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.NAVIGATION);
		}
		
		public static function addTask():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.TASK);
		}
		
		public static function addBag(rect:Rectangle=null,moveX:int = 580,moveY:int = 62):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.BAG,new ToBagData(moveX,moveY,rect));
		}
		
		public static function addStall(playerId:Number,playerName:String = ""):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.STALL,new ToStallData(playerId,playerName));
		}
		
		public static function addStore(data:Object):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.STORE,data);
		}
		
		public static function addRoleChoise():void
		{
//			GlobalAPI.moduleManager.addModule(ModuleType.ROLECHOISE);
		}
		
		public static function addRole(playerId:Number, argSelectIndex:int = 0,forciblyOpen:Boolean = false):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.ROLE,new ToRoleData(playerId,argSelectIndex,forciblyOpen));
		}
		
		public static function addNPCStore(data:Object = null):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.NPCSTORE,data);
		}
		
		public static function addExStore(data:Object = null):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.Exchange,data);
		}
		
		public static function addDuplicateStore(data:Object = null):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.DUPLICATESTORE,data);
		}
		
		public static function addMail(data:Object = null):void
		{
			if(GlobalData.isInTrade)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.inExchange"));
				return;
			}
			GlobalAPI.moduleManager.addModule(ModuleType.MAIL,data);	
		}
		
		public static function addConsign(data:Object = null):void
		{
			if(GlobalData.isInTrade)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.inExchange"));
				return;
			}
			GlobalAPI.moduleManager.addModule(ModuleType.CONSIGN,data);
		}
		
		public static function addChat():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.CHAT,null,true);
		}
		
		public static function addFriends():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.FRIENDS);
		}
		
		public static function addSetting(data:Object = null):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.SETTING,data);
		}

		public static function addSkill(data:Object = null):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.SKILL,data);
		}
		
		public static function addFurnace(argSelectIndex:int = 0,argItemId:Number = -1):void
		{
			if(GlobalData.selfPlayer.level > 15)
			{
				if(GlobalData.isInTrade)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.core.inExchange"));
					return;
				}
				if(GlobalData.furnaceState == 2)
				{
					addFireBox();
				}
				GlobalAPI.moduleManager.addModule(ModuleType.FURNACE,new ToFurnaceData(argSelectIndex,argItemId));
			}
			else{
				QuickTips.show(LanguageManager.getWord("ssztl.common.sysOpenFurnace"));
			}
		}
		
		public static function addActivity(data:Object = null):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.ACTIVITY,data);
		}
		
//		public static function addClub(showType:int):void
//		{
//			GlobalAPI.moduleManager.addModule(ModuleType.CLUB,new ToClubData(showType,GlobalData.selfPlayer.clubId));
//		}
		
		public static function addClub(showType:int=0,argIndex:int = 0):void
		{
			if(GlobalData.selfPlayer.level > 29)
			{
				if(GlobalData.selfPlayer.clubId == 0) 
				{
//					SetModuleUtils.addClub(3)
					GlobalAPI.moduleManager.addModule(ModuleType.CLUB,new ToClubData(3,GlobalData.selfPlayer.clubId,0));
				}
				else 
				{
//					SetModuleUtils.addClub(3,1);
					GlobalAPI.moduleManager.addModule(ModuleType.CLUB,new ToClubData(showType,GlobalData.selfPlayer.clubId,argIndex));
//					GlobalAPI.moduleManager.addModule(ModuleType.CLUB,new ToClubData(3,GlobalData.selfPlayer.clubId,1))
				}
			}else{
				QuickTips.show(LanguageManager.getWord("ssztl.common.sysOpenClub"));
			}
//			GlobalAPI.moduleManager.addModule(ModuleType.CLUB,new ToClubData(showType,GlobalData.selfPlayer.clubId,argIndex));
		}
		
		public static function addWareHouse(data:Object = null):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.WAREHOUSE,data);
		}
		
		public static function addMounts(data:Object = null):void
		{
			if(GlobalData.mountsList.getList().length > 0)
			{
				GlobalAPI.moduleManager.addModule(ModuleType.MOUNTS,data);
			}else{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.none"));
			}
//			GlobalAPI.moduleManager.addModule(ModuleType.MOUNTS,data);
		}
		
		public static function addPet(data:Object = null):void
		{
			if(GlobalData.petList.getList().length > 0)
			{
				GlobalAPI.moduleManager.addModule(ModuleType.PET,data);
			}else{
				QuickTips.show(LanguageManager.getWord("ssztl.pet.hasNoPet"));
			}
		}
		
		public static function addRank():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.RANK);
		}
		
		public static function addVip(toVipData:ToVipData):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.VIP, toVipData);
		}
		
		public static function addBox(type:int,price:int = -1,list:Array = null,tabIndex:int = 1):void
		{
//			if(GlobalData.selfPlayer.level > 40)
//			{
				GlobalAPI.moduleManager.addModule(ModuleType.BOX,new ToBoxData(type,price,list,tabIndex));
//			}else{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.sysOpenTaobao"));
//			}
//			GlobalAPI.moduleManager.addModule(ModuleType.BOX,new ToBoxData(type,price,list,tabIndex));
		}
		
		public static function addPersonal(playerId:Number):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.PERSONAL,new ToPersonalData(playerId));
		}
		
		public static function addFireBox(argTabIndex1:int=0,argTabIndex2:Number=0):void
		{
			if(GlobalData.furnaceState == 1)
			{
				addFurnace();
			}
			
			GlobalAPI.moduleManager.addModule(ModuleType.FIREBOX,new ToFireBoxData(argTabIndex1,argTabIndex2));
		}
		
		public static function addBagSell():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.BAGSELL);
		}
		
		public static function addOnlineReward():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.ONLINEREWARD);
		}
		
		public static function addWelfarePanel():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.LOGINREWARD);
		}
		
		public static function addSwordsman(index:int=0):void 
		{
			GlobalAPI.moduleManager.addModule(ModuleType.SWORDSMAN,new ToSwordsmanData(index));
		}
		
		
		public static function addTarget(index:int=0,argTypeIndex:int=0):void 
		{
			GlobalAPI.moduleManager.addModule(ModuleType.TARGET,new ToTargetData(index,argTypeIndex));
		}
		public static function addPVP1(pvpData:ToPvPData=null):void
		{
			if(GlobalData.pvpInfo.user_pvp_state != 2)
				GlobalAPI.moduleManager.addModule(ModuleType.PVP1,pvpData);
		}
		
		public static function addChallenge():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.Challenge);
		}
		
		public static function addOpenActivity():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.OPENACTIVITY);
		}

		public static function addQuiz(toQuizData:ToQuizData):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.QUIZ,toQuizData);
		}
		
		public static function addFirstRecharge():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.FIRSTRECHARGE);
		}
		
		public static function addSevenActivity():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.SEVENACTIVITY);
		}
		
		public static function addYellowBox():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.YELLOWBOX);
		}
		
		public static function addPayTagView():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.PAYTAGVIEW);
		}
		
		public static function addConsumTagView():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.CONSUMTAGVIEW);
		}
		
		public static function addMarriage(data:ToMarriageData):void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.MARRIAGE,data);
		}
		
		public static function addMidAutmnActivity():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.MID_AUTUMN_ACTIVITY);
		}
		
		public static function addMergeServer():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.MERGE_SERVER);
		}
		
		public static function addPetPVP():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.PET_PVP);
		}
		
		public static function addCityCraftAution():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.CITY_CRAFT_AUTION);
		}
		
		/**
		 * 添加模板module
		 */
		public static function addTemplate():void
		{
			GlobalAPI.moduleManager.addModule(ModuleType.TEMPLATE);
		}
	}
}