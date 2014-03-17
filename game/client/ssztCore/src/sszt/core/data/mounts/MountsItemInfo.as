package sszt.core.data.mounts
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.tick.ITick;
	
	public class MountsItemInfo extends EventDispatcher implements ICharacterInfo
	{
		public var id:Number;
		public var templateId:int;
		public var level:int;           
		public var state:int;            //出战状态 0，休息，1，出战
		public var nick:String;
		public var exp:int;

		public var diamond:int;			//钻
		public var star:int;				//星
		private var _stairs:int;				//阶级
		public var speed:int;           //速度
		
		public var quality:int;          //资质
		public var grow:int;             //成长
		public var refined:int;			//洗练
		
		public var fight:int;				//战斗力
		public var skillCellNum:int;		//技能格数
		public var upGrow:int;				//成长上限
		public var upQuality:int;			//资质上限
		public var hp:int;               //生命
		public var hp1:int;               //生命
		public var mp:int;               //魔法
		public var mp1:int;               //魔法
		public var attack:int;           //攻击
		public var attack1:int;           //攻击
		public var defence:int;          //防御
		public var defence1:int;          //防御
		
	
		/**
		 *  
		 */		
		public var magicAttack:int;     //内攻击
		public var magicAttack1:int;     //内攻击
		public var farAttack:int;       //远程攻击
		public var farAttack1:int;       //远程攻击
		public var mumpAttack:int;      //外攻击
		public var mumpAttack1:int;      //外攻击
		
		public var magicDefence:int;     //内防御
		public var magicDefence1:int;     //内防御
		public var farDefence:int;       //远程防御
		public var farDefence1:int;       //远程防御
		public var mumpDefence:int;      //外防御
		public var mumpDefence1:int;      //外防御
	
		
		public var refinedHp:int;               //生命
		public var refinedMp:int;               //魔法
		public var refinedAttack:int;           //攻击
		public var refinedDefence:int;          //防御
		public var refinedProAttack:int;     	 //属攻
		public var refinedMagicDefence:int;     //内防
		public var refinedFarDefence:int;       //远防
		public var refinedMumpDefence:int;      //外防
		
		public var picWidth:int = 50;
		public var picHeight:int = 135;
		
		public var skillList:Array; //技能
		
		private var _style:Array;
		public var frameRates:Dictionary = new Dictionary;
		
		private var _mountsStrengthLevel:int;
		
		
		public function MountsItemInfo()
		{
			super();
			skillList = new Array();
		}
		
		public function parseData():void
		{
		}
		
		
		public function changeState(state:int):void
		{
			this.state = state;
			dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.CHANGE_STATE));
		}
		
		public function update():void
		{
			dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.UPDATE));
		}
		
		public function updateExp(level:int,exp:int):void
		{
			this.level = level;
			if(this.exp == exp)return;
			this.exp = exp;
			dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.UPDATE_EXP,{level:this.level,exp:this.exp}));
		}
		
		public function updateGrow(value:int):void
		{
			this.grow = value;
			dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.UPDATE_GROW));
		}		
		
		public function updateRefined(value:int):void
		{
			this.refined = value;
			dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.UPDATE_REFIEDN));
		}
		
		public function get template():ItemTemplateInfo
		{
			return ItemTemplateList.getTemplate(templateId);
		}
		
		public function updateQuality(value:int):void
		{
			this.quality = value;
			dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.UPDATE_QUALITY));
		}
		public function clearSkill():void
		{
			skillList = [];
		}
		
		public function updateSkill(skill:SkillItemInfo,updateView:Boolean = false):void
		{
			if(skill)
			{
				skillList.push(skill);
			}
			if(updateView)
				dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.SKILL_UPDATE));
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
		
		public function get stairs():int
		{
			return _stairs;
		}
		
		public function set stairs(value:int):void
		{
			if(_stairs == value ) return;
			_stairs =  value;
			if((_stairs % 15 ) == 0 &&  _stairs != 0)
			{
//				dispatchEvent(new MountsItemInfoUpdateEvent(MountsItemInfoUpdateEvent.UPDATE_STAIRS));
				dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_UPDATE));
			}
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
			return ItemTemplateList.getTemplate(id);
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
		public function getHideWeapon():Boolean { return false; }
		public function getHideSuit():Boolean{return false;}
		public function getMountsStrengthLevel():int
		{
			return stairs;
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