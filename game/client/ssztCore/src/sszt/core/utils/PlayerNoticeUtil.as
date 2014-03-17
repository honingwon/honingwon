package sszt.core.utils
{
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.events.ChatModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class PlayerNoticeUtil
	{
		public function PlayerNoticeUtil()
		{
		}
		
		//开启太初宝盒 type:3
		public static function openTaiChuBoxNotice(serverId:int,nickName:String,itemTemplateId:int):void
		{
			var itemInfo:ChatItemInfo;
			var itemTemplate:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTemplateId);
			
			var info:String = LanguageManager.getWord("ssztl.common.taiChuBoxChatNotice","{N[" + serverId + "]" + nickName + "}","{I0-0-"+itemTemplateId+"-0}");
			
			itemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.taiChuBoxMidNotice","{000xff3737-【[" + serverId + "]" +nickName + "】}",
				"{000x"+CategoryType.getQualityColorString(itemTemplate.quality)+"-"+itemTemplate.name+"}");
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		//打开紫色宠物蛋  type:7
		public static function petEggOpenNotice(serverId:int,nickName:String,petName:String):void
		{
			var itemInfo:ChatItemInfo;
			
			var info:String = LanguageManager.getWord("ssztl.common.petEggChatNotice","{N["+ serverId + "]" + nickName + "}","{C0xA85AF0-【"+petName+"】}");	
			itemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.petEggMidNotice","{000xff3737-【[" + serverId + "]" + nickName + "】}",
				"{000xA85AF0-【"+petName+"】}");
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		
		//使用vip半年卡  type:8
		public static function useHalfYearVipCard(serverId:int,nickName:String):void
		{
			var itemInfo:ChatItemInfo;
			
			var info:String = LanguageManager.getWord("ssztl.common.halfYearVipChatNotice",
				"{N[" + serverId + "]" + nickName + "}","{C0xA85AF0-"+LanguageManager.getWord("ssztl.common.playerTitle")+"}",GlobalData.GAME_NAME);
			
			itemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.halfYearVipMidNotice",
				"{000xff3737-【["+ serverId + "]" + nickName + "】}","{000xA85AF0-"+LanguageManager.getWord("ssztl.common.playerTitle")+"}",GlobalData.GAME_NAME);
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		
		//赤月窟守塔 type:9
		public static function chiYueKuNotice(serverId:int,nickName:String,level:int):void
		{
			var info1:String = "";
			var info2:String = "";
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			
			switch(level)
			{
				case 50:
					info1 =  LanguageManager.getWord("ssztl.common.chiYue50ChatNotice","{N[" + serverId + "]" + nickName + "}");
					info2 = LanguageManager.getWord("ssztl.common.chiYue50MidNotice","{000xff3737-["+ serverId + "]" + nickName + "}");
					break;
				case 60:
					info1 = LanguageManager.getWord("ssztl.common.chiYue60ChatNotice","{N["+ serverId + "]" + nickName + "}");
					info2 = LanguageManager.getWord("ssztl.common.chiYue60MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}");
					break;
				case 70:
					info1 = LanguageManager.getWord("ssztl.common.chiYue70ChatNotice","{N[" + serverId + "]" + nickName + "}");
					info2 = LanguageManager.getWord("ssztl.common.chiYue70MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}");
					break;
				case 80:
					info1 = LanguageManager.getWord("ssztl.common.chiYue80ChatNotice","{N[" + serverId + "]" + nickName + "}");
					info2 = LanguageManager.getWord("ssztl.common.chiYue80MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}");
					break;
				case 90:
					info1 = LanguageManager.getWord("ssztl.common.chiYue90ChatNotice","{N[" + serverId + "]" + nickName + "}");
					info2 = LanguageManager.getWord("ssztl.common.chiYue90MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}");
					break;
				case 100:
					info1 = LanguageManager.getWord("ssztl.common.chiYue100ChatNotice","{N[" + serverId + "]" + nickName + "}");
					info2 = LanguageManager.getWord("ssztl.common.chiYue100MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}");
					break;
			}
			itemInfo.message = info1;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info2));
		}
		
		//杀怪掉紫装 type:
		public static function killMonster(serverId:int,nickName:String,monTemId:int,itemTemId:int):void
		{
			var itemInfo:ChatItemInfo;
			var monster:MonsterTemplateInfo = MonsterTemplateList.getMonster(monTemId);
			var itemTemp:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTemId);
			var info:String = LanguageManager.getWord("ssztl.common.fallEquipChatNotice","{N[" + serverId + "]" + nickName + "}",
				"{C0xff3737-【"+monster.name+"】}","{I0-0-"+itemTemId+"-0}");
			itemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.fallEquipMidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
				"{000xff3737-【"+monster.name+"】}","{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}");
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		//装备强化
		public static function equipStrengthNotice(serverId:int,nickName:String,itemId:Number,itemTempId:int,level:int,userId:Number):void
		{
			var info1:String;
			var info2:String;
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var itemTemp:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
			itemInfo.type = MessageType.SYSTEM;
			
			if(level>=7 && level<=9)
			{
				info1 = LanguageManager.getWord("ssztl.common.equipStreigth7ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{I"+userId+"-"+itemId+"-"+itemTempId+"-0}",level);
				info2 = LanguageManager.getWord("ssztl.common.equipStreigth7MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}",level);
			}
			else if(level>=10 && level<=11)
			{
				info1 = LanguageManager.getWord("ssztl.common.equipStreigth10ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{I"+userId+"-"+itemId+"-"+itemTempId+"-0}",level);
				info2 = LanguageManager.getWord("ssztl.common.equipStreigth10MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}",level);
			}
			else if(level == 12)
			{
				info1 = LanguageManager.getWord("ssztl.common.equipStreigth12ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{I"+userId+"-"+itemId+"-"+itemTempId+"-0}",level);
				info2 = LanguageManager.getWord("ssztl.common.equipStreigth12MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}",level);
			}
			itemInfo.message = info1;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info2));
		}
		
		//合成宝石
		public static function compoundStoneNotice(serverId:int,nickName:String,itemTempId:int):void
		{
			var info1:String;
			var info2:String;
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var itemTemp:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
			itemInfo.type = MessageType.SYSTEM;
			
			switch(itemTemp.property3)
			{
				case 6:
				case 7:

					info1 = LanguageManager.getWord("ssztl.common.compoundStone6ChatNotice","{N[" + serverId + "]" + nickName + "}","{I0-0-"+itemTempId+"-0}");
					info2 = LanguageManager.getWord("ssztl.common.compoundStone6MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}","{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}");
					break;
				case 8:
				case 9:
					info1 = LanguageManager.getWord("ssztl.common.compoundStone8ChatNotice","{N[" + serverId + "]" + nickName + "}","{I0-0-"+itemTempId+"-0}");
					info2 = LanguageManager.getWord("ssztl.common.compoundStone8MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}","{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}");
					break;
				case 10:
					info1 = LanguageManager.getWord("ssztl.common.compoundStone10ChatNotice","{N[" + serverId + "]" + nickName + "}","{I0-0-"+itemTempId+"-0}");
					info2 = LanguageManager.getWord("ssztl.common.compoundStone10MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}","{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}");
					break;
			}
			itemInfo.message = info1;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info2));
		}
		
		//四神兽现身  type:15
		public static function shenshouBossRefreshNotice(bossId:int):void
		{
			var itemInfo:ChatItemInfo;
			var monster:MonsterTemplateInfo = MonsterTemplateList.getMonster(bossId);
			var info:String = LanguageManager.getWord("ssztl.common.bossAppearChatNotice","{C0xff3737-【"+monster.name+"】}",monster.level,MapTemplateList.getMapTemplate(monster.sceneId).name);
			
			itemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.bossAppearMidNotice","{000xff3737-【"+monster.name+"】}",monster.level,MapTemplateList.getMapTemplate(monster.sceneId).name);
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		//boss现身  type:16
		public static function bossRefreshNotice(bossId:int):void
		{
			var itemInfo:ChatItemInfo;
			var monster:MonsterTemplateInfo = MonsterTemplateList.getMonster(bossId);
			var info:String = LanguageManager.getWord("ssztl.common.bossRefreshChatNotice","{C0xff3737-【"+monster.name+"】}",monster.level,MapTemplateList.getMapTemplate(monster.sceneId).name);
			
			itemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.bossRefreshMidNotice","{000xff3737-【"+monster.name+"】}",monster.level,MapTemplateList.getMapTemplate(monster.sceneId).name);
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		//装备神佑
		public static function equipShenYou(nickName:String,userId:Number,itemId:Number,itemTempId:int):void
		{
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var itemTemp:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
			var info:String = LanguageManager.getWord("ssztl.common.shenYouChatNotice","{N"+nickName+"}","{I"+userId+"-"+itemId+"-"+itemTempId+"-0}");
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.shenYouMidNotice","{000xff3737-"+nickName+"}","{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}");
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		
		public static function roseNotice(sender:String,receiver:String):void
		{
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var info:String = LanguageManager.getWord("ssztl.common.roseNotice","{N"+sender+"}","{N"+receiver+"}");
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.roseNotice","{000xff3737-【"+sender+"】}","{000xff3737-【"+receiver+"】}");
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		
		public static function openLovePacket(nickName:String):void
		{
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var info:String = LanguageManager.getWord("ssztl.common.openLovePacketNotice","{N"+nickName+"}");
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.openLovePacketNotice","{000xff3737-【"+nickName+"】}");
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		
		public static function equipUpgradeNotice(nickName:String,userId:Number,itemId:Number,itemTempId:int):void
		{
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var itemTemp:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
			var info:String = LanguageManager.getWord("ssztl.common.equipUpgradeChatNotice","{N"+nickName+"}","{I"+userId+"-"+itemId+"-"+itemTempId+"-0}");
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.message = info;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			info = LanguageManager.getWord("ssztl.common.equipUpgradeMidNotice","{000xff3737-"+nickName+"}","{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+itemTemp.name+"】}");
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info));
		}
		
		public static function petGrowUpNotice(serverId:int,nickName:String,userId:Number,itemId:Number,itemTempId:int,petName:String,growValue:int):void
		{
			var info1:String;
			var info2:String;
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var itemTemp:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
			itemInfo.type = MessageType.SYSTEM;
			
			if(petName == "")
			{
				petName = itemTemp.name;
			}
			
			if(growValue>=45 && growValue<=49)
			{
				info1 = LanguageManager.getWord("ssztl.common.petGrowUp45ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{P"+userId+"-"+itemId+"-"+itemTempId+"-"+petName+"}",growValue);
				info2 = LanguageManager.getWord("ssztl.common.petGrowUp45MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+petName+"】}",growValue);
			}
			else if(growValue>=50 && growValue<=55)
			{
				info1 = LanguageManager.getWord("ssztl.common.petGrowUp50ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{P"+userId+"-"+itemId+"-"+itemTempId+"-"+petName+"}",growValue);
				info2 = LanguageManager.getWord("ssztl.common.petGrowUp50MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+petName+"】}",growValue);
			}
			else if(growValue>=56 && growValue<=60)
			{
				info1 = LanguageManager.getWord("ssztl.common.petGrowUp56ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{P"+userId+"-"+itemId+"-"+itemTempId+"-"+petName+"}",growValue);
				info2 = LanguageManager.getWord("ssztl.common.petGrowUp56MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+petName+"】}",growValue);
			}
			
			itemInfo.message = info1;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info2));
		}
		
		public static function petQualityNotice(serverId:int,nickName:String,userId:Number,itemId:Number,itemTempId:int,petName:String,qualityValue:int):void
		{
			var info1:String;
			var info2:String;
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			var itemTemp:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
			itemInfo.type = MessageType.SYSTEM;
			
			if(petName == "")
			{
				petName = itemTemp.name;
			}
			
			if(qualityValue>=60 && qualityValue<=69)
			{
				info1 = LanguageManager.getWord("ssztl.common.petquality60ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{P"+userId+"-"+itemId+"-"+itemTempId+"-"+petName+"}",qualityValue);
				info2 = LanguageManager.getWord("ssztl.common.petquality60MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+petName+"】}",qualityValue);
			}
			else if(qualityValue>=70 && qualityValue<=79)
			{
				info1 = LanguageManager.getWord("ssztl.common.petquality70ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{P"+userId+"-"+itemId+"-"+itemTempId+"-"+petName+"}",qualityValue);
				info2 = LanguageManager.getWord("ssztl.common.petquality70MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+petName+"】}",qualityValue);
			}
			else if(qualityValue>=80 && qualityValue<=89)
			{
				info1 = LanguageManager.getWord("ssztl.common.petquality80ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{P"+userId+"-"+itemId+"-"+itemTempId+"-"+petName+"}",qualityValue);
				info2 = LanguageManager.getWord("ssztl.common.petquality80MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000x"+CategoryType.getQualityColorString(itemTemp.quality)+"-【"+petName+"】}",qualityValue);
			}
			else if(qualityValue>=90 && qualityValue<=100)
			{
				info1 = LanguageManager.getWord("ssztl.common.petquality90ChatNotice","{N[" + serverId + "]" + nickName + "}",
					"{P"+userId+"-"+itemId+"-"+itemTempId+"-"+petName+"}",qualityValue);
				info2 = LanguageManager.getWord("ssztl.common.petquality90MidNotice","{000xff3737-[" + serverId + "]" + nickName + "}",
					"{000xA85AF0-【"+petName+"】}",qualityValue);
			}
			
			itemInfo.message = info1;
			GlobalData.chatInfo.appendMessage(itemInfo);
			
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PLAYER_NOTICE,info2));
		}
	}
}













