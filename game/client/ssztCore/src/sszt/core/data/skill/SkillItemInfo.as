package sszt.core.data.skill
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.tick.ITick;
	
	public class SkillItemInfo extends EventDispatcher implements ITick
	{
		public var templateId:int;
		private var _template:SkillTemplateInfo;
		
		public var level:int;
		public var isInCommon:Boolean;
		
		private var _lastUseTime:Number;
		private var _isInCooldown:Boolean;
		private var _lock:Boolean;
		
		public function SkillItemInfo()
		{
		}
		
		public function getTemplate():SkillTemplateInfo
		{
			if(_template == null)
			{
				_template = SkillTemplateList.getSkill(templateId);
			}
			return _template;
		}
		
		public function getCanUse():Boolean
		{
//			if(templateId != GlobalData.skillInfo.getDefaultSkill().templateId)
//			{
//				if(GlobalData.bagInfo.getItem(3) == null || GlobalData.bagInfo.getItem(3).template.categoryId != getTemplate().activeItemCategoryId)return false;
//			}
			if(int(getTemplate().activeUseMp[level - 1]) > GlobalData.selfPlayer.currentMP)return false;
			if((systemTime - lastUseTime) < (CD + 200))return false;
//			if(getTemplate().activeItemCategoryId != 0 && getTemplate().activeItemCategoryId != -1)
//			{
//				var weapon:ItemInfo = GlobalData.bagInfo.getItem(5);
//				if(weapon == null || weapon.template.categoryId != getTemplate().activeItemCategoryId)return false;
//			}
			return true;
		}
		
		public function get lastUseTime():Number
		{
			return _lastUseTime;
		}
		
		public function set lastUseTime(value:Number):void
		{
			if(_lastUseTime == value)return;
			_lastUseTime = value;
			setInCooldownForce((systemTime - _lastUseTime) < (CD + 200));
//			trace(this.getTemplate().name);
//			trace('技能使用后过去的时间:'+(systemTime - _lastUseTime));
//			trace('技能冷却还需时间:' + ((CD + 200) - (systemTime - _lastUseTime)));
//			trace(((systemTime - _lastUseTime) < (CD + 200)) ? '冷却中' : '冷却结束');
		}
		
		public function setCommonCD():void
		{
//			var cdLast:Number = systemTime - CD + CommonConfig.COMMONCD;
			//如果上次CD结束需要的时间小于公共CD，那么技能冷却还需要的时间设置为公共CD
			//(_lastUseTime + CD - systemTime) < CommonConfig.COMMONCD
//			if(cdLast > _lastUseTime)
//			{
//				lastUseTime = cdLast;
//			}
		}
		
		public function get isInCooldown():Boolean
		{
			return _isInCooldown;
		}
		
		public function set isInCooldown(value:Boolean):void
		{
			if(_isInCooldown == value)return;
			_isInCooldown = value;
			if(_isInCooldown)
				GlobalAPI.tickManager.addTick(this);
			dispatchEvent(new SkillItemInfoUpdateEvent(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE));
		}
		
		/**
		 * 强制更新，设完lateusetime后强制更新cooldown
		 * @param value
		 * 
		 */		
		public function setInCooldownForce(value:Boolean):void
		{
			_isInCooldown = value;
			if(_isInCooldown)
				GlobalAPI.tickManager.addTick(this);
			dispatchEvent(new SkillItemInfoUpdateEvent(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE));
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			//如果从技能上次使用到现在过去的时间 大于等于 技能冷却时间
			if( (systemTime - _lastUseTime) >= (CD + 200)  )
			{
				isInCooldown = false;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		public function get lock():Boolean
		{
			return _lock;
		}
		public function set lock(value:Boolean):void
		{
			if(_lock == value)return;
			_lock = value;
			dispatchEvent(new SkillItemInfoUpdateEvent(SkillItemInfoUpdateEvent.LOCKUPDATE));
		}
		
		public function getAttackEffect():int
		{
			return int(getTemplate().attackEffect[level - 1]);
		}
		public function getBeAttackEffect():int
		{
			return int(getTemplate().beattackEffect[level - 1]);
		}
		
		public function getAffectCount():int
		{
			return int(getTemplate().affectCount[level - 1]);
		}
		
		public function dataUpdate():void
		{
			dispatchEvent(new SkillItemInfoUpdateEvent(SkillItemInfoUpdateEvent.SKILL_UPGRADE));
		}
		
		public function get systemTime():Number
		{
			return GlobalData.systemDate.getSystemDate().getTime();
		}
		
		public function get CD():int
		{
			return int(getTemplate().coldDownTime[level - 1]);
		}
	}
}