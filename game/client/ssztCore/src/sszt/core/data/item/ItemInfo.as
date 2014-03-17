package sszt.core.data.item
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.interfaces.tick.ITick;
	
	public class ItemInfo extends EventDispatcher implements ITick
	{
	    public var itemId:Number;
		public var templateId:int;
		public var isBind:Boolean;
		public var strengthenLevel:int;
		public var strengthenPerfect:int;
		public var count:int;
		public var place:int;
		public var stallSellPrice:int;
		public var date:Date;
		/**
		 * 道具状态，0正常、1冷却、2耐久为0、3 出售中、4求购中,5保护锁。 
		 */
		public var state:int;
		/**未开孔 -1 开孔 0 镶嵌后 宝石模板ID**/
		public var enchase1:int;
		public var enchase2:int;
		public var enchase3:int;
		public var enchase4:int;
		public var enchase5:int;
		public var enchase6:int;
		public var isExist:Boolean;
	
		public var attack:int;   
		public var defence:int;
		public var durable:int;
//		public var fight:int;
//		public var freePropertyVector:Vector.<PropertyInfo>;
		public var freePropertyVector:Array;
		public var lastUseTime:int;
		
		private var _isInCooldown:Boolean;
		
		private var _locked:Boolean;
		public var score:int;
		public var wuHunId:int;
		/**
		 * 交易锁定
		 */		
		private var _tradeLocked:Boolean;
		
		public function ItemInfo()
		{
//			freePropertyVector = new Vector.<PropertyInfo>();
			freePropertyVector = [];
		}
		
		public function get template():ItemTemplateInfo
		{
			return ItemTemplateList.getTemplate(templateId);
		}
		
		public function updateInfo():void
		{
			dispatchEvent(new ItemInfoUpdateEvent(ItemInfoUpdateEvent.UPDATE));
		}
		
		public function get lock():Boolean
		{
			return _locked || _tradeLocked;
		}
		public function set lock(value:Boolean):void
		{
			if(_locked == value)return;
			_locked = value;
			dispatchEvent(new ItemInfoUpdateEvent(ItemInfoUpdateEvent.LOCK_UPDATE));
		}
		public function set tradeLock(value:Boolean):void
		{
			if(_tradeLocked == value)return;
			_tradeLocked = value;
			dispatchEvent(new ItemInfoUpdateEvent(ItemInfoUpdateEvent.LOCK_UPDATE));
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
			dispatchEvent(new ItemInfoUpdateEvent(ItemInfoUpdateEvent.COOLDOWN_UPDATE));
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(!((GlobalData.systemDate.getSystemDate().getTime() - lastUseTime) < 10000 + 200))
			{
				isInCooldown = (GlobalData.systemDate.getSystemDate().getTime() - lastUseTime) < 10000 + 200;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		public function isInStall():Boolean
		{
			return state == 3;
		}
		
		public function isInLock():Boolean
		{
			return state == 5;
		}
		
		public function canOperate():Boolean
		{
			return !lock && !isInStall()&&!isInLock();
		}
		
		public function getSellPrice():int
		{
			return template.sellCopper;
		}
		
		/**已镶嵌宝石的孔数**/
		public function getEnchaseCount(isMoreHole:Boolean):int
		{
			var count:int;
			if(enchase1 > 0){count++};
			if(enchase2 > 0){count++};
			if(enchase3 > 0){count++};
			if(isMoreHole)
			{
				if(enchase4 > 0){count++};
				if(enchase5 > 0){count++};
				if(enchase6 > 0){count++};
			}
			return count;
		}
		/**已使用的孔数**/
		public function getUsedHoleCount(isMoreHole:Boolean):int
		{
			var count:int;
			if(enchase1 >= 0){count++};
			if(enchase2 >= 0){count++};
			if(enchase3 >= 0){count++};
			if(isMoreHole)
			{
				if(enchase4 >= 0){count++};
				if(enchase5 >= 0){count++};
				if(enchase6 >= 0){count++};
			}
			return count;
		}
		
		/**已开孔数**/
		public function getOpenHoleCount(isMoreHole:Boolean):int
		{
			var count:int;
			if(enchase1 == 0){count++};
			if(enchase2 == 0){count++};
			if(enchase3 == 0){count++};
			if(isMoreHole)
			{
				if(enchase4 == 0){count++};
				if(enchase5 == 0){count++};
				if(enchase6 == 0){count++};
			}
			return count;
		}
		
		/**特殊孔镶嵌数**/
		public function getSpecialEnchaseHoleCount():int
		{
			var count:int;
			if(enchase4 > 0){count++};
			if(enchase5 > 0){count++};
			if(enchase6 > 0){count++};
			return count;
		}
		
		//特殊孔开启数
		public function getSpecialHoleCount():int
		{
			var count:int;
			if(template.quality == 1 || template.quality == 2)return 0;
			if(template.quality == 3 && strengthenLevel >= 6)
			{
				count++;
			}
			else if(template.quality == 4)
			{
				if(strengthenLevel >=6 && strengthenLevel < 8)
				{
					count++;
				}
				else if(strengthenLevel >=8 && strengthenLevel < 10)
				{
					count += 2;
				}
				else if(strengthenLevel >=10)
				{
					count += 3;
				}
			}
			return count;
		}
		
		public function updateSpecialHole():void
		{
			if(CategoryType.isEquip(template.categoryId))
			{
				if(template.quality == 3)//紫装
				{
					if(strengthenLevel >= 6)//强7以上，4孔自动开启(已有宝石，不变)
					{
						if(enchase4 < 0)enchase4 = 0;
					}
					else//强7以下，4孔自动关闭(已有宝石，不变)
					{
						if(enchase4 <= 0)enchase4 = -1;
					}
				}
				else if(template.quality == 4)//橙装
				{
					if(strengthenLevel < 6)//强7以下，45孔关闭（已有宝石不变）
					{
						if(enchase4 <=0)enchase4 = -1;
						if(enchase5 <=0)enchase5 = -1;
					}
					else if(strengthenLevel >=6 && strengthenLevel < 8)//强7-10,4孔开启(已有宝石不变)
					{
						if(enchase4 < 0)enchase4 = 0;
					}
					else if(strengthenLevel >= 8 && strengthenLevel < 10)//强10以上,45孔开启(已有宝石不变)
					{
						if(enchase4 < 0) enchase4 = 0;
						if(enchase5 < 0) enchase5 = 0;
					}
					else if(strengthenLevel >= 10)//强10以上,45孔开启(已有宝石不变)
					{
						if(enchase4 < 0) enchase4 = 0;
						if(enchase5 < 0) enchase5 = 0;
						if(enchase6 < 0) enchase6 = 0;
					}
				}
			}
		}
		
		public function getCanUse():Boolean
		{
			if(CategoryType.isHpDrup(template.categoryId))
			{
				if(GlobalData.lastUseTime_hp != 0 && (getTimer() - GlobalData.lastUseTime_hp < template.cd))
					return false;
			}
			else if(CategoryType.isMpDrup(template.categoryId))
			{
				if(GlobalData.lastUseTime_mp != 0 && (getTimer() - GlobalData.lastUseTime_mp < template.cd))
					return false;
			}
					
			if(template.needCareer != 0 && template.needCareer != GlobalData.selfPlayer.career)return false;
			if(template.needSex != 0 && template.needSex != GlobalData.selfPlayer.getSex())return false;
			if(template.needLevel > GlobalData.selfPlayer.level)return false;
			return true;
		}
		
//		public function clone():ItemInfo
//		{
//			var itemInfo:ItemInfo = new ItemInfo();
//			itemInfo.itemId = itemId;
//			itemInfo.templateId = templateId;
//			itemInfo.isBind = isBind;
//			itemInfo.strengthenLevel = strengthenLevel;
//			itemInfo.count = count;
//			itemInfo.place = place;
//			itemInfo.stallSellPrice = stallSellPrice;
//			itemInfo.date = date;
//			itemInfo.state = state;
//			itemInfo.enchase1 = enchase1;
//			itemInfo.enchase2 = enchase2;
//			itemInfo.enchase3 = enchase3;
//			itemInfo.enchase4 = enchase4;
//			itemInfo.enchase5 = enchase5;
//			itemInfo.isExist = isExist;
//			itemInfo.attack = attack;
//			itemInfo.defence = defence;
//			itemInfo.durable = durable;
////			itemInfo.regularProperty = regularProperty;
//			itemInfo.freePropertyVector = freePropertyVector;
////			itemInfo.hideProperty = hideProperty;
//			itemInfo.lastUseTime = lastUseTime;
//			itemInfo.isInCooldown = isInCooldown;
//			itemInfo.lock = lock;
//			return itemInfo;
//		}
	}
}