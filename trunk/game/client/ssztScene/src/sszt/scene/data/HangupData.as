package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.scene.data.dropItem.DropItemInfo;
	import sszt.scene.socketHandlers.PlayerHangupDataSocketHandler;
	
	public class HangupData extends EventDispatcher
	{
		public var autoFight:Boolean;
		public var autoAddHp:Boolean;
		//从大到小吃药
		public var addHpAdd:Boolean;
		public var autoAddHpValue:int;
		//从大到小吃蓝
		public var addMpAdd:Boolean;
		public var autoAddMp:Boolean;
		public var autoAddMpValue:int;
		
		public var autoBuyDrug:Boolean;
		public var autoBack:Boolean;
		
		public var autoPickEquip:Boolean;
		//索引对应品质
		public var pickEquips:Array
		public var pickEquipsCareer:int;
		public var autoPickOther:Boolean;
		
		//索引对应品质
		public var pickOthers:Array;
		
		public var autoRelive:Boolean;
		public var autoRepair:Boolean;
		//自动击杀地图任务怪
		public var autoKillTask:Boolean;
		
		public var autoGroup:Boolean;
		public var isAccept:Boolean;//自动接受组队邀请
		//原地挂机
		public var localHangup:Boolean;
		
		public var attackPlayer:Boolean;
		
		public var autoSkill:Boolean;
		public var autoAddSkill:Boolean;
		public var skills:Array;
		//技能ID列表
		public var skillList:Array;
		public var monsterList:Array;
		//自动喂宠
		public var autoFeedPet:Boolean;
		public var autoDoubleExp:Boolean;
		/**
		 * 临时保存
		 */		
//		public var saveHangup:Vector.<int>;
		public var saveHangup:Array;
		
		/**
		 * -1无限杀
		 * 0停止挂机
		 */		
		public var monsterNeedCount:int = -1;
		public var autoFindTask:Boolean = false;
		public var stopComplete:Boolean = true;
		/**
		 * 挂机路线
		 */		
		public var attackPath:Array;
		/**
		 * 当前挂机路线点
		 */		
		public var attackIndex:int;
		
		public function HangupData()
		{
			skillList = new Array(10);
			monsterList = [];
			pickEquips = [];
			pickOthers = [];
			skills = [];
			saveHangup = [];
			attackPath = [];
			setDefault();
		}
		
		public function setDefault():void
		{
			autoFight = autoAddHp = autoAddMp = autoPickEquip = autoPickOther = autoGroup = autoSkill = autoDoubleExp = true;
			autoAddHpValue = autoAddMpValue = 50;
			isAccept = true;
			addHpAdd = addMpAdd = true;
			pickEquips = [true,true,true,true,true];
			pickOthers = [true,true,true,true,true];
			autoBuyDrug = autoBack = autoRelive = autoRepair = attackPlayer = localHangup = false;
			autoAddSkill = false;
			autoFeedPet = true;
			
			var list:Array = GlobalData.skillShortCut.getItemList();
			var tt:int = 0;
			for(var m:int = 0; m < list.length; m++)
			{
				if(list[m] && list[m].length == 2)
				{
					var skillItemInfo:SkillItemInfo = GlobalData.skillInfo.getSkillById(list[m][1]);
					if(skillItemInfo && skillItemInfo.getTemplate().activeType == 0 && skillItemInfo.getTemplate().getPrepareTime(skillItemInfo.level) == 0)
					{
						skillList[tt] = skillItemInfo;
						tt++;
					}
				}
				if(tt >= 10)break;
			}
			for(var mm:int = tt+1; mm < 10; mm++)
			{
				skillList[mm] = null;
			}
		}
		
		public function setMonsterList():void
		{
		}
		
		public function getMonsterTemplateId():int
		{
			if(monsterList.length == 0)return -1;
			return monsterList[0];
		}
		
//		public function getEquipQualityPicks():Vector.<int>
		public function getEquipQualityPicks():Array
		{
			if(!autoPickEquip)return null;
//			var result:Vector.<int> = new Vector.<int>();
			var result:Array = [];
			var i:int = 0;
			for(i = 0; i < pickEquips.length; i++)
			{
				if(pickEquips[i])result.push(i);
			}
			return result;
		}
//		public function getOtherQualityPicks():Vector.<int>
		public function getOtherQualityPicks():Array
		{
			if(!autoPickOther)return null;
//			var result:Vector.<int> = new Vector.<int>();
			var result:Array = [];
			var i:int = 0;
			for(i = 0; i < pickOthers.length; i++)
			{
				if(pickOthers[i])result.push(i);
			}
			return result;
		}
		public function newSkillAdd(skillId:int):void
		{
			var skillItemInfo:SkillItemInfo = GlobalData.skillInfo.getSkillById(skillId);
			if(skillItemInfo && skillItemInfo.getTemplate().activeType == 0 && skillItemInfo.getTemplate().getPrepareTime(skillItemInfo.level) == 0)
			{
				for(var n:int = 0; n < 10; n++)
				{
					if(skillList[n] == null)
					{
						skillList[n] = skillItemInfo;
						dispatchEvent(new HanpupDataUpdateEvent(HanpupDataUpdateEvent.ADD_SKILL,{place:n,skill:skillItemInfo}));
						PlayerHangupDataSocketHandler.sendConfig(getConfigStr());
						return;
					}
					
				}
			}
			
		}
		
		public function addSkill(place:int,skill:SkillItemInfo):void
		{
			if(skillList.indexOf(skill) != -1)return;
			if(skill)
			{
				if(skill.getTemplate().getPrepareTime(skill.level) != 0 || skill.getTemplate().activeType != 0)return;
			}
			skillList[place] = skill;
			dispatchEvent(new HanpupDataUpdateEvent(HanpupDataUpdateEvent.ADD_SKILL,{place:place,skill:skill}));
		}
		public function removeSkill(place:int):void
		{
			skillList[place] = null;
			dispatchEvent(new HanpupDataUpdateEvent(HanpupDataUpdateEvent.REMOVE_SKILL,place));
		}
		
		/**
		 * 需要自动打任务怪时，数量会减一，当数量为0时，检测任务中需要此怪是否为0，是的话自动切换下一种怪，如果不需要下一种怪则不处理
		 * 
		 */		
		public function updateCount():void
		{
//			if(!autoFindTask)return;
			if(monsterNeedCount == -1)return;
			if(monsterNeedCount > 0)
			{
//				monsterNeedCount --;
//				if(monsterNeedCount == 0)
//				{
//					if(!autoFindTask)return;
//					
//				}
				monsterNeedCount = GlobalData.taskInfo.getTaskMonsterCountByMonsterId(monsterList[0]);
				if(monsterNeedCount == 0)
				{
					//检测是否还有下一种怪物
					var monsterId:int = -1;
					var count:int = 0;
					for each(var i:int in monsterList)
					{
						count = GlobalData.taskInfo.getTaskMonsterCountByMonsterId(i);
						if(count > 0)
						{	
							monsterId = i;
							break;
						}
					}
					if(monsterId != -1)
					{
						setTargetToBottom(monsterList[0]);
						setTargetToTop(monsterId);
						monsterNeedCount = count;
					}
					else
					{
						if(stopComplete)monsterNeedCount = 0;
						else
							monsterNeedCount = -1;
					}
				}
			}
		}
		/**
		 * 是否挂机中，monsterNeedCount = 0为非挂机状态，但是可能还需要挂人条件
		 * @return 
		 * 
		 */		
		public function hangupIng():Boolean
		{
			return monsterNeedCount != 0;
		}
		
		public function getConfigStr():String
		{
			var result:String = "";			
			result += autoFight ? "1" : "0";
			result += autoAddHp ? "1" : "0";
			result += autoRelive ? "1" : "0";
			result += autoGroup ? "1" : "0";
			result += autoPickEquip ? "1" : "0";
			result += pickEquips[0] ? "1" : "0";
			result += pickEquips[1] ? "1" : "0";
			result += pickEquips[2] ? "1" : "0";
			result += pickEquips[3] ? "1" : "0";
			result += pickEquipsCareer.toString();
			result += autoPickOther ? "1" : "0";
			result += pickOthers[0] ? "1" : "0";
			result += pickOthers[1] ? "1" : "0";
			result += pickOthers[2] ? "1" : "0";
			result += pickOthers[3] ? "1" : "0";
			result += autoFeedPet ? "1" : "0";
			result += ",";
			result += isAccept ? "1" : "0";
			result += autoDoubleExp ? "1" : "0";
			result += ",";
			result += autoAddHpValue;
			result += ",";
			result += autoAddMpValue;
			result += ",";
			var skills:String = "";
			for(var j:int = 0; j < skillList.length; j++)
			{
				if(skillList[j])
					skills += skillList[j].templateId;
				skills += "|";
			}
			result += skills;
			return result;
		}
		
		public function setConfig(value:String):void
		{
			if(value == "" || value == "undefined")return;
			var valueArr:Array = value.split(",");
			if(valueArr.length < 5) return;
			var char0:String = valueArr[0];
			autoFight = char0.charAt(0) == "1";
			autoAddHp = char0.charAt(1) == "1";
			autoAddMp = autoAddHp;//char0.charAt(1) == "1";
			autoRepair = false;//char0.charAt(2) == "1";
			autoKillTask = false;//char0.charAt(3) == "1";
			autoRelive = false;//char0.charAt(2) == "1";
			localHangup = false;//char0.charAt(5) == "1";
			autoGroup = char0.charAt(3) == "1";
			autoPickEquip = char0.charAt(4) == "1";
			pickEquips = [char0.charAt(5) == "1",char0.charAt(6) == "1",char0.charAt(7) == "1",char0.charAt(8) == "1",true];
			pickEquipsCareer = int(char0.charAt(9));
			
			autoPickOther = char0.charAt(10) == "1";
			pickOthers = [char0.charAt(11) == "1",char0.charAt(12) == "1",char0.charAt(13) == "1",char0.charAt(14) == "1",true];
			autoSkill = true;//char0.charAt(17) == "1";
			autoAddSkill = false;//char0.charAt(18) == "1";
			autoFeedPet = false;//char0.charAt(15) == "1";
			char0 = valueArr[1];
			addHpAdd = true;//char0.charAt(0) == "1";
			addMpAdd = true;//char0.charAt(1) == "1";
			isAccept = char0.charAt(0) == "1";
			autoDoubleExp = char0.charAt(1) == "1";
//			var va:Array = valueArr[2].split("|");
			autoAddHpValue = int(valueArr[2]);
			autoAddMpValue = int(valueArr[3]);
			var va:Array  = valueArr[4].split("|");
			var len:int = skillList.length;
			for(var i:int = 0; i < va.length; i++)
			{
				if(i >= len)break;
				if(int(va[i]) > 0)
				{
					var skillitem:SkillItemInfo = GlobalData.skillInfo.getSkillById(int(va[i]));
					if(skillitem && skillitem.getTemplate().getPrepareTime(skillitem.level) == 0 && skillitem.getTemplate().activeType == 0)
						skillList[i] = skillitem;
				}
			}
		}
		
		
//		public function reSetSkillList(list:Array):void{
//			var skillItemInfo:SkillItemInfo;
//			this.skillList = [];
//			var count:int;
//			var i:int;
//			while (i < list.length) {
//				if (list[i]){
//					skillItemInfo = list[i];
//					if (skillItemInfo && skillItemInfo.canHangupUse() ){
//						skillList.push(skillItemInfo);
//						count++;
//					}
//				}
//				if (count >= 10) break;
//				i++;
//			}
//			dispatchEvent(new HanpupDataUpdateEvent(HanpupDataUpdateEvent.UPDATE_SKILL));
//		}
		
		public function getDropCanPick(drop:DropItemInfo):Boolean
		{
			var quality:int = drop.getTemplate().quality;
			if(CategoryType.isEquip(drop.getTemplate().categoryId))
			{
				if(drop.getTemplate().needCareer == 0 || pickEquipsCareer == 0 || pickEquipsCareer == drop.getTemplate().needCareer)
					return pickEquips[quality];
				else
					return false;
			}
			else
			{
				return pickOthers[quality];
			}
			return false;
		}
		
		public function setTargetToTop(monsterId:int):void
		{
			var index:int = monsterList.indexOf(monsterId);
			if(index != -1)
			{
				monsterList.splice(index,1);
			}
			monsterList.unshift(monsterId);
		}
		
		public function setTargetToBottom(monsterId:int):void
		{
			var index:int = monsterList.indexOf(monsterId);
			if(index != -1)
			{
				monsterList.splice(index,1);
			}
			monsterList.push(monsterId);
		}
		
		public function clear():void
		{
			monsterList.length = 0;
			attackPath.length = 0;
			attackIndex = 0;
		}
	}
}