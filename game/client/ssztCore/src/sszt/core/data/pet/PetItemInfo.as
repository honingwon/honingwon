package sszt.core.data.pet
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class PetItemInfo extends EventDispatcher
	{
		public var id:Number;
		public var templateId:int;
		public var styleId:int;           //幻形ID
		public var color:int;//品质颜色
		public var type:int;//属性攻击类型 
		public var state:int;            //出战状态  休息：0，出战：1
		public var diamond:int;//钻级
		public var star:int;//星级
		public var nick:String;
		public var _stairs:int;//品阶
		public var level:int;
		public var exp:int;
		public var grow:int;             //成长
		public var growExp:int;             //成长
		public var quality:int;          //资质
		public var qualityExp:int;          //资质exp
		
		public var fight:int;
		public var skillCellNum:int;
		public var upGrow:int;//成长上限
		public var upQuality:int;//资质上限
		public var energy:int;           //饱食度
		
		public var hit:int;
		public var hit2:int;
		public var powerHit:int;
		public var powerHit2:int;
		public var attack:int;
		public var attack2:int;
		public var magicAttack:int;
		public var magicAttack2:int;
		public var farAttack:int;
		public var farAttack2:int;
		public var mumpAttack:int;
		public var mumpAttack2:int;
		
		public var skillList:Array; //技能
		
		
		
		
		public var defaultSkill:PetSkillInfo;
		public var hangupSkillList:Array;
		
		public var picWidth:int = 50;
		public var picHeight:int = 135;
		private var _style:Array;
		public var frameRates:Dictionary = new Dictionary;
		
//		public var time:int;             //升级时间
		
//		public var attack:int;           //攻击
//		public var defence:int;          //防御
//		public var mumpDefence:int;      //斗气防御
//		public var magicDefence:int;     //魔法防御
//		public var farDefence:int;       //远程防御
//		public var hp:int;               //生命
//		public var mp:int;               //魔法
//		
//		public var hitTarget:int;        //命中
//		public var duck:int;             //闪避
//		public var powerHit:int;         //暴击
//		public var deligency:int;        //坚韧
//		public var attackOver:int;       //攻击压制
//		public var defenceOver:int;      //防御压制
//		
//		public var attackRate:int;
//		public var defenceRate:int;
//		public var hpRate:int;
//		public var mumpDefenceRate:int;
//		public var magicDefenceRate:int;
//		public var farDefenceRate:int;
		
		public function PetItemInfo()
		{
			super();
			skillList = [];
			hangupSkillList = [];
		}
		
		public function update():void
		{
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE));
		}
		
		public function updateExp():void
		{
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE_EXP));
		}
		
		public function updateGrowExp():void
		{
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE_GROW_EXP));
		}
		
		public function updateQualityExp():void
		{
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE_QUALITY_EXP));
		}
		
		//todo:重构，分成两个方法，一个添加，一个更新
		public function updateSkill(skill:PetSkillInfo,updateView:Boolean = false):void
		{
			if(skill)
			{
				skillList.push(skill);
				var i:int = 0;
				while (i < this.hangupSkillList.length)
				{
					if( i == 0)
					{
						defaultSkill = skill;
					}
					if (this.hangupSkillList[i].templateId == skill.templateId)
					{
						this.hangupSkillList.splice(i, 1);
						break;
					}
					i++;
				}
				this.hangupSkillList.push(skill);
				
			}
			if(updateView)
				dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.SKILL_UPDATE));
		}
		
		public function removeSkill():void
		{
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.REMOVE_SKILL))
		}
		
		public function reName(value:String):void
		{
			nick = value;
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.RENAME));
		}
		
		public function changeState(state:int):void
		{
			this.state = state;
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.CHANGE_STATE));
		}
		
		public function updateEnergy():void
		{
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE_ENERGY));
		}
		
		public function upgrade():void
		{
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPGRADE));
		}
		
		public function clearSkill():void
		{
			defaultSkill = null;
			skillList = [];
			hangupSkillList = [];
		}
		
		
		
		
		
		public function setSkillCDExcept(skill:PetSkillInfo) : void
		{
			var petSkillInfo:PetSkillInfo = null;
			for each (petSkillInfo in this.skillList)
			{
				
				if (petSkillInfo != skill)
				{
					petSkillInfo.isInCommon = true;
				}
				petSkillInfo.setCommonCD();
			}
		}
		
		public function get template():PetTemplateInfo
		{
			return PetTemplateList.getPet(templateId);
		}
		
		public function parseData():void
		{
			
		}
		
		public function updateTime(time:int):void
		{
//			this.time = time;
//			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE_TIME));
		}
		
		public function updateStyle(id:int):void
		{
			if(styleId == id) return;
			this.styleId = id;
//			addStyleProperty();
			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE_STYLE));
		}
		
		public function updatePropertyRate(attackRate:int,defenceRate:int,hpRate:int,mumpDefence:int,magicDefence:int,farDefence:int):void
		{
//			this.attackRate = attackRate;
//			this.defenceRate = defenceRate;
//			this.hpRate = hpRate;
//			this.mumpDefenceRate = mumpDefenceRate;
//			this.magicDefenceRate = magicDefenceRate;
//			this.farDefenceRate = farDefenceRate;
//			dispatchEvent(new PetItemInfoUpdateEvent(PetItemInfoUpdateEvent.UPDATE_PROPERTY_RATE));
		}
		
		public function hasSkillSpace(templateId:int):Boolean
		{
			for each(var i:PetSkillInfo in skillList)
			{
				if(i.templateId == 0 || i.templateId == templateId) return true;
			}
			return false;
		}
	    	
		public function hasSameSkill(templateId:int,level:int):Boolean
		{
			for each(var i:PetSkillInfo in skillList)
			{
				if(i.templateId == templateId && i.level == level) return true;
			}
			return false;
		}
		
		public function canStudyLow(groupId:int,level:int):Boolean
		{
			for each(var i:PetSkillInfo in skillList)
			{
				if(groupId == i.templateId && level <= i.level)
					return false;
			}
			return true;
		}
		
		public function canStudyHigh(groupId:int,level:int):Boolean
		{
			var result:Boolean = false;
			for each(var i:PetSkillInfo in skillList)
			{
				if(i.templateId == groupId)
				{
					if(level - i.level == 1) return true;
					else return false;
				}
			}
			if(level == 1) return true;
			return result;
		}
		
		public function getSkillPlace():int
		{
			var place:int = 10000;
			for each(var i:PetSkillInfo in skillList)
			{
				if(i.templateId == 0)
				{
					if(i.place < place) place = i.place
				}
			}
			return place;
		}
		
		public function getLearnSkillPlace(templateId:int):int
		{
			for each(var i:PetSkillInfo in skillList)
			{
				if(i.templateId == templateId) return i.place;
			}
			return 0;
		}
		
		
		
		/**
		 *添加幻形增加的属性 
		 * 
		 */		
		public function addStyleProperty():void
		{
//			if(styleId != 0)
//			{
//				var styleSymbol:ItemTemplateInfo = ItemTemplateList.getTemplate(styleId);
//				if(styleSymbol)
//				{
//					for each(var i:PropertyInfo in styleSymbol.regularPropertyList)
//					{
//						if(i.propertyId == 1) attack = attack + i.propertyValue;
//						else if(i.propertyId == 2) defence = defence + i.propertyValue;	
//						else if(i.propertyId == 7)	mumpDefence = mumpDefence + i.propertyValue;					
//						else if(i.propertyId == 8)	magicDefence = magicDefence + i.propertyValue;
//						else if(i.propertyId == 9)	farDefence = farDefence + i.propertyValue;
//						else if(i.propertyId == 13) hp = hp + i.propertyValue;
//						else if(i.propertyId == 15) powerHit = powerHit + i.propertyValue;
//						else if(i.propertyId == 16) deligency = deligency + i.propertyValue;
//						else if(i.propertyId == 17) hitTarget = hitTarget + i.propertyValue;
//						else if(i.propertyId == 18) duck = duck + i.propertyValue;
//						else if(i.propertyId == 22) attackOver = attackOver + i.propertyValue;
//						else if(i.propertyId == 23) defenceOver = defenceOver + i.propertyValue;
//					}
//				}
//			}
		}
		
		/**
		 *移除幻形符属性 
		 * 
		 */		
		public function removeStyleProperty():void
		{
//			if(styleId != 0)
//			{
//				var styleSymbol:ItemTemplateInfo = ItemTemplateList.getTemplate(styleId);
//				if(styleSymbol)
//				{
//					for each(var i:PropertyInfo in styleSymbol.regularPropertyList)
//					{
//						if(i.propertyId == 1) attack = attack - i.propertyValue;
//						else if(i.propertyId == 2) defence = defence - i.propertyValue;	
//						else if(i.propertyId == 7)	mumpDefence = mumpDefence - i.propertyValue;					
//						else if(i.propertyId == 8)	magicDefence = magicDefence - i.propertyValue;
//						else if(i.propertyId == 9)	farDefence = farDefence - i.propertyValue;
//						else if(i.propertyId == 13) hp = hp - i.propertyValue;
//						else if(i.propertyId == 15) powerHit = powerHit - i.propertyValue;
//						else if(i.propertyId == 16) deligency = deligency - i.propertyValue;
//						else if(i.propertyId == 17) hitTarget = hitTarget - i.propertyValue;
//						else if(i.propertyId == 18) duck = duck - i.propertyValue;
//						else if(i.propertyId == 22) attackOver = attackOver - i.propertyValue;
//						else if(i.propertyId == 23) defenceOver = defenceOver - i.propertyValue;
//					}
//				}
//			}
		}
		
		public function get characterId():uint
		{
			return templateId;
		}
		
		public function get style():Array
		{
			if(_style == null)
			{
				_style = [];
				_style.push(int(template.picPath));
			}
			return _style;
		}
		
		public function getSex():int
		{
			return 0;
		}
		
		public function getCareer():int
		{
			return 0;
		}
		
		public function getMounts():Boolean
		{
			return false;
		}
		
		public function getPicWidth():int { return picWidth; }
		public function getPicHeight():int { return picHeight; }
		
		public function getPartStyle(categoryId:int):int
		{
			return 0;
		}
		
		public function getLayerInfoById(id:int):ILayerInfo
		{
			return null;
		}
		
		public function getDefaultLayer(category:int):ILayerInfo
		{
			return null;
		}
		
		public function getDefaultAction(type:String):ICharacterActionInfo
		{
			return null;
		}
		public function getDefaultActionType(type:String):int
		{
			return ActionType.STAND;
		}
		public function getWeaponStrength():int
		{
			return 0;
		}
		public function getWindStrength():int{return 0;}
		
		
		public function get stairs():int
		{
			return _stairs;
		}
		
		public function set stairs(value:int):void
		{
			if(_stairs == value) return;
//			if(value >1)
//			{
//				
//				var old:int = Math.floor(_stairs % 4);
//				var tem:int = Math.floor(value % 4);
//				if(old != tem)
//				
//					
//			}
			_stairs = value;
		}
		
		public function getFrameRate(actionType:int):int
		{
			if(frameRates.hasOwnProperty(actionType))
			{
				return frameRates[actionType];
			}
			else if(frameRates.hasOwnProperty(0))
			{
				return frameRates[0];
			}
			return 3;	
		}
	}
}