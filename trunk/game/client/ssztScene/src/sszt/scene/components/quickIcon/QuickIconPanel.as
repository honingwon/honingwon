package sszt.scene.components.quickIcon
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.data.quickIcon.iconInfo.ClubNewcomerIconInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.events.ClubModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.MailModuleEvent;
	import sszt.events.PetPVPModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.container.MTile;
	
	public class QuickIconPanel extends Sprite
	{
		private var _quicikMediator:QuickIconMediator;
		private var  iconMTile:MTile;
		public var clubNewcomerIconBtn:ClubNewcomerIconBtn;
		public var friendIconBtn:FriendIconBtn;
		public var tradeIconBtn:TradeIconBtn;
		public var clubIconBtn:ClubIconBtn;
		public var doubleSitIconBtn:DoubleSitIconBtn;
		public var teamIconBtn:TeamIconBtn;
		public var skillIconBtn:SkillIconBtn;
		public var veinsIconBtn:VeinsIconBtn;
		public var petPVPIconBtn:PetPVPIconBtn;
		public var mailIconBtn:MailIconBtn;
		public var medicinelIconBtn:MedicineIconBtn;
		public var warIconBtn:WarIconBtn;
		
		public function QuickIconPanel(argMediator:QuickIconMediator)
		{
			super();
			_quicikMediator = argMediator;
			initialView();
			initialEvents();
			gameSizeChangeHandler(null);
			//计时开始
			GlobalData.quickIconInfo.start();
		}
		
		private function initialView():void
		{
			iconMTile = new MTile(40,44,6);
			iconMTile.setSize(280,44);
			iconMTile.verticalScrollPolicy = iconMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			iconMTile.itemGapW = 5;
			addChild(iconMTile);
		}
		
		private function initialEvents():void
		{
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.CLUB_NEWCOMER_ICON_ADD,showClubNewcomerIcon);
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.CLUB_NEWCOMER_ICON_REMOVE,hideClubNewcomerIcon);
			
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.FRIEND_ICON_ADD,showFriendIcon);
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.FRIEND_ICON_REMOVE,hideFriendIcon);
			
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.TRADE_ICON_ADD,showTradeIcon);
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.TRADE_ICON_REMOVE,hideTradeIcon);
			
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.DOUBLESIT_ICON_ADD,showDoubleSitIconBtn);
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.DOUBLESIT_REMOVE,hideDoubleSitIconBtn);
			
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.CLUB_ICON_ADD,showClubIconBtn);
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.CLUB_ICON_REMOVE,hideClubIconBtn);
			
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.TEAM_ICON_ADD,showTeamIconBtn);
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.TEAM_ICON_REMOVE,hideTeamIconBtn);
			
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.CLUB_WAR_ICON_ADD,showWarIconBtn);
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.CLUB_WAR_ICON_REMOVE,hideWarIconBtn);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.addClubEventListener(ClubModuleEvent.SHOW_CLUB_WAR_REQUEST,showWarIconBtn);
//			_quicikMediator.sceneModule.sceneInfo.playerList.getPlayer(GlobalData.selfPlayer.userId).addEventListener(BaseRoleInfoUpdateEvent.UPGRADE,showSkillIconBtn);
//			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,showSkillIconBtn);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,checkSkillIcon);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SKILL_REFRESH,checkSkillIcon);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.MAIL_REFRESH,showMailIconBtn);
			ModuleEventDispatcher.addMailEventListener(MailModuleEvent.SHOW_MAIL_PANEL,hideMailIconBtn);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.VEINS_UPGRADE, checkVeinsIcon);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SHOW_MEDICINES_ICON, showMedicinesIconBtn);
			
			ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.PET_PVP_SELF_LOG,showPetPVPIconBtn);
		}
		
		private function removeEvents():void
		{
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.FRIEND_ICON_ADD,showFriendIcon);
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.FRIEND_ICON_REMOVE,hideFriendIcon);
			
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.TRADE_ICON_ADD,showTradeIcon);
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.TRADE_ICON_REMOVE,hideTradeIcon);
			
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.DOUBLESIT_ICON_ADD,showDoubleSitIconBtn);
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.DOUBLESIT_REMOVE,hideDoubleSitIconBtn);
			
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.CLUB_ICON_ADD,showClubIconBtn);
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.CLUB_ICON_REMOVE,hideClubIconBtn);
			
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.TEAM_ICON_ADD,showTeamIconBtn);
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.TEAM_ICON_REMOVE,hideTeamIconBtn);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.removeClubEventListener(ClubModuleEvent.SHOW_CLUB_WAR_REQUEST,showWarIconBtn);
			//			_quicikMediator.sceneModule.sceneInfo.playerList.getPlayer(GlobalData.selfPlayer.userId).removeEventListener(BaseRoleInfoUpdateEvent.UPGRADE,showSkillIconBtn);
//			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,showSkillIconBtn);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,checkSkillIcon);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SKILL_REFRESH,checkSkillIcon);
			
			ModuleEventDispatcher.removePetPVPEventListener(PetPVPModuleEvent.PET_PVP_SELF_LOG,showPetPVPIconBtn);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.MAIL_REFRESH,showMailIconBtn);
			ModuleEventDispatcher.removeMailEventListener(MailModuleEvent.SHOW_MAIL_PANEL,hideMailIconBtn);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.VEINS_UPGRADE, checkVeinsIcon);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SHOW_MEDICINES_ICON, showMedicinesIconBtn);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			var w:int = iconMTile.getItemCount()*45;
			
			iconMTile.move((CommonConfig.GAME_WIDTH - w >>1) + 100 ,CommonConfig.GAME_HEIGHT-165);
		}
		
		private function showClubNewcomerIcon(e:QuickIconInfoEvent):void
		{
			if(clubNewcomerIconBtn == null)
			{
				clubNewcomerIconBtn = new ClubNewcomerIconBtn(_quicikMediator);
				iconMTile.appendItem(clubNewcomerIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		
		private function hideClubNewcomerIcon(e:QuickIconInfoEvent):void
		{
			if(clubNewcomerIconBtn)
			{
				iconMTile.removeItem(clubNewcomerIconBtn);
				clubNewcomerIconBtn.dispose();
				clubNewcomerIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		/*****好友图标*******/
		private function showFriendIcon(e:QuickIconInfoEvent):void
		{
			if(friendIconBtn == null)
			{
				friendIconBtn = new FriendIconBtn(_quicikMediator);
				iconMTile.appendItem(friendIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		private function hideFriendIcon(e:QuickIconInfoEvent):void
		{
			if(friendIconBtn)
			{
				iconMTile.removeItem(friendIconBtn);
				friendIconBtn.dispose();
				friendIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		/*******交易图标*******/
		private function showTradeIcon(e:QuickIconInfoEvent):void
		{
			if(tradeIconBtn == null)
			{
				tradeIconBtn = new TradeIconBtn(_quicikMediator);
				iconMTile.appendItem(tradeIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		private function hideTradeIcon(e:QuickIconInfoEvent):void
		{
			if(tradeIconBtn)
			{
				iconMTile.removeItem(tradeIconBtn);
				tradeIconBtn.dispose();
				tradeIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		/******双修图标*******/
		private function showDoubleSitIconBtn(e:QuickIconInfoEvent):void
		{
			if(doubleSitIconBtn == null)
			{
				doubleSitIconBtn = new DoubleSitIconBtn(_quicikMediator);
				iconMTile.appendItem(doubleSitIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		private function hideDoubleSitIconBtn(e:QuickIconInfoEvent):void
		{
			if(doubleSitIconBtn)
			{
				iconMTile.removeItem(doubleSitIconBtn);
				doubleSitIconBtn.dispose();
				doubleSitIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		/****帮会图标*******/
		private function showClubIconBtn(e:QuickIconInfoEvent):void
		{
			if(clubIconBtn == null)
			{
				clubIconBtn = new ClubIconBtn(_quicikMediator);
				iconMTile.appendItem(clubIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		private function hideClubIconBtn(e:QuickIconInfoEvent):void
		{
			if(clubIconBtn)
			{
				iconMTile.removeItem(clubIconBtn);
				clubIconBtn.dispose();
				clubIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		/****组队图标*******/
		private function showTeamIconBtn(e:QuickIconInfoEvent):void
		{
			if(teamIconBtn == null)
			{
				teamIconBtn = new TeamIconBtn(_quicikMediator);
				iconMTile.appendItem(teamIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		private function hideTeamIconBtn(e:QuickIconInfoEvent):void
		{
			if(teamIconBtn)
			{
				iconMTile.removeItem(teamIconBtn);
				teamIconBtn.dispose();
				teamIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		/**帮会宣战图标**/
		private function showWarIconBtn(e:ClubModuleEvent):void
		{
			if(warIconBtn == null)
			{
				warIconBtn = new WarIconBtn(_quicikMediator);
				iconMTile.appendItem(warIconBtn);
				warIconBtn.addEventListener(MouseEvent.CLICK,hideWarIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		private function hideWarIconBtn(e:MouseEvent):void
		{
			if(warIconBtn)
			{
				warIconBtn.removeEventListener(MouseEvent.CLICK,hideWarIconBtn);
				iconMTile.removeItem(warIconBtn);
				warIconBtn.dispose();
				warIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		/**
		 * 邮件图标
		 **/
		private function showMailIconBtn(e:Event):void
		{
			if(mailIconBtn == null)
			{
				mailIconBtn = new MailIconBtn(_quicikMediator);
				iconMTile.appendItem(mailIconBtn);
				mailIconBtn.addEventListener(QuickIconInfoEvent.MAIL_ICON_REMOVE,hideMailIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		
		private function hideMailIconBtn(e:Event):void
		{
			if(mailIconBtn)
			{
				mailIconBtn.removeEventListener(QuickIconInfoEvent.MAIL_ICON_REMOVE,hideMailIconBtn);
				ModuleEventDispatcher.removeMailEventListener(MailModuleEvent.SHOW_MAIL_PANEL,hideMailIconBtn);
				iconMTile.removeItem(mailIconBtn);
				mailIconBtn.dispose();
				mailIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		/**
		 * 药品提示图标
		 **/
		private function showMedicinesIconBtn(e:CommonModuleEvent):void
		{
			if(medicinelIconBtn == null && !_quicikMediator.sceneModule.medicinesCautionPanel)
			{
				medicinelIconBtn = new MedicineIconBtn(_quicikMediator,e.data);
				iconMTile.appendItem(medicinelIconBtn);
				medicinelIconBtn.addEventListener(QuickIconInfoEvent.MEDICINE_ICON_REMOVE,hideMedicinesIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		
		private function hideMedicinesIconBtn(e:Event):void
		{
			if(medicinelIconBtn)
			{
				medicinelIconBtn.removeEventListener(QuickIconInfoEvent.MEDICINE_ICON_REMOVE,hideMedicinesIconBtn);
				iconMTile.removeItem(medicinelIconBtn);
				medicinelIconBtn.dispose();
				medicinelIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		
		/**
		 * 宠物斗坛图标
		 **/
		private function showPetPVPIconBtn(e:PetPVPModuleEvent):void
		{
			if(petPVPIconBtn == null)
			{
				petPVPIconBtn = new PetPVPIconBtn(_quicikMediator);
				iconMTile.appendItem(petPVPIconBtn);
				petPVPIconBtn.addEventListener(QuickIconInfoEvent.PETPVP_ICON_REMOVE,hidePetPVPIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		
		private function hidePetPVPIconBtn(e:QuickIconInfoEvent):void
		{
			if(petPVPIconBtn)
			{
				petPVPIconBtn.removeEventListener(QuickIconInfoEvent.PETPVP_ICON_REMOVE,hidePetPVPIconBtn);
				//				ModuleEventDispatcher.removeMailEventListener(MailModuleEvent.SHOW_MAIL_PANEL,hideMailIconBtn);
				iconMTile.removeItem(petPVPIconBtn);
				petPVPIconBtn.dispose();
				petPVPIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		/**
		 * 穴位图标
		 **/
		private function showVeinsIconBtn():void
		{
			if(veinsIconBtn == null)
			{
				veinsIconBtn = new VeinsIconBtn(_quicikMediator);
				iconMTile.appendItem(veinsIconBtn);
				veinsIconBtn.addEventListener(QuickIconInfoEvent.VEINS_ICON_REMOVE,hideVeinsIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		
		private function hideVeinsIconBtn(e:QuickIconInfoEvent):void
		{
			if(veinsIconBtn)
			{
				veinsIconBtn.removeEventListener(QuickIconInfoEvent.VEINS_ICON_REMOVE,hideVeinsIconBtn);
//				ModuleEventDispatcher.removeMailEventListener(MailModuleEvent.SHOW_MAIL_PANEL,hideMailIconBtn);
				iconMTile.removeItem(veinsIconBtn);
				veinsIconBtn.dispose();
				veinsIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		private function checkVeinsIcon(e:CommonModuleEvent):void
		{
			showVeinsIconBtn();
		}
		
		/****技能图标*******/
		private function showSkillIconBtn():void
		{
			if(skillIconBtn == null)
			{
				skillIconBtn = new SkillIconBtn(_quicikMediator);
				iconMTile.appendItem(skillIconBtn);
				skillIconBtn.addEventListener(QuickIconInfoEvent.SKILL_ICON_REMOVE,hideSkillIconBtn);
				gameSizeChangeHandler(null);
			}
		}
		
		private function hideSkillIconBtn(e:QuickIconInfoEvent):void
		{
			if(skillIconBtn)
			{
				skillIconBtn.removeEventListener(QuickIconInfoEvent.SKILL_ICON_REMOVE,hideSkillIconBtn);
				iconMTile.removeItem(skillIconBtn);
				skillIconBtn.dispose();
				skillIconBtn = null;
				gameSizeChangeHandler(null);
			}
		}
		
		private function checkSkillIcon(e:CommonModuleEvent):void
		{
			var hasActiveSkillCanUpdate:Boolean = false;
			var hasPassiveSkillCanUpdate:Boolean = false;
			for each(var i:SkillTemplateInfo in SkillTemplateList.getSelfActiveSkills()) //主动技能
			{
				for each(var j:SkillItemInfo in GlobalData.skillInfo.getSkills()) //用户技能
				{
					if(i.templateId == j.templateId)
					{
						hasActiveSkillCanUpdate = checkUpgrade(j,i);
						if(hasActiveSkillCanUpdate)break;
					}
				}
			}
			
			if(!hasActiveSkillCanUpdate)
			{
				for each(var n:SkillTemplateInfo in SkillTemplateList.getSelfPassiveSkills())
				{
					if(isMySkill(n))continue;
					hasPassiveSkillCanUpdate = checkUpgrade(null,n);
					if(hasPassiveSkillCanUpdate)break;
				}
			}
			
			if(hasActiveSkillCanUpdate || hasPassiveSkillCanUpdate)showSkillIconBtn();
		}
		
		private function isMySkill(argSkillTemplate:SkillTemplateInfo):Boolean
		{
			for each(var j:SkillItemInfo in GlobalData.skillInfo.getSkills())
			{
				if(argSkillTemplate.templateId == j.templateId)
				{
					return true;
				}
			}
			return false;
		}
		
		private function checkUpgrade(argMySkillInfo:SkillItemInfo,argSkillTemplateInfo:SkillTemplateInfo):Boolean
		{
			var level:int = 0;
			var template:SkillTemplateInfo;
			if(argMySkillInfo) level = argMySkillInfo.level;
			template = argSkillTemplateInfo;
			if(level >= template.totalLevel) return false;
			if(GlobalData.selfPlayer.level <= 8) return false;
//			if(GlobalData.selfPlayer.level > 30) return false; 
			if(GlobalData.selfPlayer.level < template.needLevel[level]) return false;
			if((GlobalData.selfPlayer.userMoney.copper + GlobalData.selfPlayer.userMoney.bindCopper) < template.needCopper[level]) return false;
			if(GlobalData.selfPlayer.lifeExperiences < template.needLifeExp[level]) return false;
			if(ItemTemplateList.getTemplate(template.needItemId[level]))
			{
				if(GlobalData.bagInfo.getItemById(template.needItemId[level]) == null) return false;
			}
			return true;
		}
		
		public function dispose():void
		{
			removeEvents();
			_quicikMediator = null;
			if(iconMTile)
			{
				iconMTile.dispose();
				iconMTile = null;
			}
		}
	}
}