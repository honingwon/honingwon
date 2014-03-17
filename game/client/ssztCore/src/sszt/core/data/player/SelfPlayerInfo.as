package sszt.core.data.player
{
	import flash.geom.Point;
	
	import sszt.constData.CategoryType;
	import sszt.constData.PropertyType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.vip.VipCommonEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class SelfPlayerInfo extends DetailPlayerInfo
	{
		/**
		 * 活跃度
		 */
		public var activeNum:int;
		/**
		 * 活跃度能否领取
		 */
		public var activeRewardCanGet:Boolean;
		
		/**
		 *0未有结果，1胜利，2失败，3平局
		 */		
		public var pkState:int;
		/**
		 *VIP飞行次数 
		 */		
		public var flyCount:int = 0;
		/**
		 *VIP免费使用喇叭次数 
		 */		
		public var bugle:int = 0;
		
		/**
		 *vip铜币是否已领取当天奖励 
		 */
		public var isVipCopperGot:Boolean = false;
		/**
		 *vip绑定元宝是否已领取当天奖励 
		 */
		public var isVipBindYuanbaoGot:Boolean = false;
		/**
		 *vip属性buff是否已领取当天奖励 
		 */
		public var isVipBuffGot:Boolean = false;
//		/**
//		 *vip上次领取时间
//		 */
//		public var vipLastGetAwardDate:Date;
		/**
		 *vip剩余时间 (秒数)
		 */
		public var vipTime:int = 0;
		
		public var userName:String;
		/**
		 * 当前经验
		 */	
		public var currentExp:Number;
		/**
		 * 货币信息
		 */		
		public var userMoney:PlayerMoneyResInfo;
		/**
		 *充值积分 
		 */
		public var yuanBaoScore:int;
		/**
		 * 总充值金额
		 */	
		public var money:int;
		/**
		 * 功勋数
		 */	
		public var exploit:int;//目前使用GlobalData.pvpInfo.exploit代替存放
		/**
		 * 背包最大数量
		 */		
		public var bagMaxCount:int;
		/**
		 *仓库最大数量
		 */
		public var wareHouseMaxCount:int;
		/**
		 * 帮会总贡献
		 */		
		public var totalClubContribute:int;
		/**
		 * 体力回复
		 */		
		public var HPRevert:int;
		/**
		 * MP回复
		 */		
		public var MPRevert:int;
		/**
		 * 异常状态几率
		 */		
		public var exceptRate:int;
		/**
		 * 抗击异常状态几率
		 */		
		public var defenseExceptRate:int;
		/**
		 * 可装备盔甲类型
		 */		
		public var fitEquipType:int;
		/**
		 * 可装备武器类型
		 */		
		public var fitWeaponType:int;
		/**
		 * 特殊状态
		 */		
		public var especialStatus:int;
		/**
		 * 增加的经验值
		 */		
		public var tmpExp:int;
		/**
		 * 增加的历练值
		 */		
		public var dle:int;
		/**
		 *总荣誉值 
		 */		
		public var totalHonor:int;
		/**
		 * 是否已经绑定facebook
		 */		
		public var hasBindFacebook:Boolean;
		
		/**
		 * 场景路径,跨图寻路数据
		 */
//		public var scenePath:Vector.<int> = new Vector.<int>();
		public var scenePath:Array = [];
		public var scenePathCallback:Function;
		public var scenePathTarget:Point;
		public var scenePathStopAtDistance:int;
		
		public var sceneTaskTarget:Point;
		
		/**
		 * 客户端配置
		 */		
		public var clientConfig:int;
		
		public var resourceWarQuitTime:int;
		
		public var exchangeSilverMoneyState:int;
		
		public function getExchangeSilverMoneyTypeState(type:int):int
		{
			var ret:int;
			switch(type)
			{
				case 1:
					ret = exchangeSilverMoneyState & 1;
					break;
				case 2:
					ret = exchangeSilverMoneyState & 2;
					break;
				case 3:
					ret = exchangeSilverMoneyState & 4;
					break;
			}
			if(ret > 0) ret = 1;
			return ret;
		}
		
		public function getRemainingExchangeSilverMoneyNum():int
		{
			return 3 - getExchangeSilverMoneyTypeState(1) - getExchangeSilverMoneyTypeState(2) - getExchangeSilverMoneyTypeState(3);
		}
		
		public function getAllowTrade():Boolean
		{
			return (clientConfig & 1) == 0;
		}
		public function getAllowAddFriend():Boolean
		{
			return (clientConfig & 2) == 0;
		}
		public function getAllowPrivateChat():Boolean
		{
			return (clientConfig & 4) == 0;
		}
		public function getAllowGroupInvite():Boolean
		{
			return (clientConfig & 8) == 0;
		}
		public function getAllowClubInvite():Boolean
		{
			return (clientConfig & 16) == 0;
		}
		public function getAllowFrightInvite():Boolean
		{
			return (clientConfig & 32) == 0;
		}
		
		public function getPropertyByType(type:int):int
		{
			switch(type)
			{
				case PropertyType.ATTR_SWORD:
					return fight;
				case PropertyType.ATTR_ATTACK:
					return attack;
				case PropertyType.ATTR_DEFENSE:
					return defense;
				case PropertyType.ATTR_POWERHIT:
					return powerHit;
				case PropertyType.ATTR_DELIGENCY:
					return deligency;
				case PropertyType.ATTR_HITTARGET:
					return hitTarget;
				case PropertyType.ATTR_DUCK:
					return duck;					
				default:
					return 0;					
			}
		}
		public function SelfPlayerInfo()
		{
			super();
			userMoney = new PlayerMoneyResInfo();
		}
		
		public function updateUserInfo(argLevel:int,argTotalHP:int,argTotalMP:int,argCurrentHP:int,argCurrentMP:int,argCurrentExp:Number,argAttack:int,argDefense:int,
									   argHitTarget:int,argDuck:int,argMumpAttack:int,argMumpDefense:int,argMagicAttack:int,argMagicDefense:int,
									   argFarAttack:int,argFarDefense:int,argPowerHit:int,
									   argMaxPhysical:int,argCurrentPhysical:int,argPKvalue:int,argLifeExperiences:int,argDeligency:int,argAttackSupress:int,argDefenseSupress:int,argFight:int):void
		{
			level = argLevel;
			totalHP = argTotalHP;
			totalMP = argTotalMP;
			currentHP = argCurrentHP;
			currentMP = argCurrentMP;
			updateExp(argCurrentExp);
			attack = argAttack;
			defense = argDefense;
			hitTarget = argHitTarget;
			duck = argDuck;
			mumpAttack = argMumpAttack;
			mumpDefense = argMumpDefense;
			magicAttack = argMagicAttack;
			magicDefense = argMagicDefense;
			farAttack = argFarAttack;
			farDefense = argFarDefense;
			powerHit = argPowerHit;
			maxPhysical = argMaxPhysical;
			currentPhysical = argCurrentPhysical;
			PKValue = argPKvalue;
			updateLifeExp(argLifeExperiences);
			deligency = argDeligency;
			attackSuppress = argAttackSupress;
			defenseSuppress = argDefenseSupress;
			fight = argFight;
			trace(fight);
//			lifeExperiences = argLifeExperiences;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE));
		}
		
		
		public function updateExp(value:Number):void
		{
			if(currentExp == value)return;
			var old:Number = currentExp;
			currentExp = value;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.EXPUPDATE,old));
			
			tmpExp  = currentExp-old;
			if(tmpExp <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainExp",tmpExp);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		public function updateHonor(value:int):void
		{
			var old:int = honor;
			honor = value;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.SELFHONOR_UPDATE));
			if(honor - old <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainHonor",(honor-old));
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		public function updateLifeExp(value:int):void
		{
			if(lifeExperiences == value)return;
			var old:int = lifeExperiences;
			lifeExperiences = value;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.LIFEEXP_UPDATE,old));
			
			var adddle:int = lifeExperiences - old;
			if(adddle>0)
			{
				dle = adddle;
				var message:String = LanguageManager.getWord("ssztl.common.gainLifeExp",dle);
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
			}
			
		}
		
		public function updateStallName(value:String):void
		{
			stallName = value;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.STALLNAMEUPDATE));
		}
		
		public function updatePhysical(value:int):void
		{
			if(currentPhysical == value)return;
			currentPhysical = value;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.PHYSICAL_UPDATE));
		}
		
		public function taskAccept(task:TaskItemInfo):void
		{
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.TASK_ACCEPT,task));
		}
		public function taskSubmit(task:TaskItemInfo):void
		{
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.TASK_SUBMIT,task));
		}
		
		public function updateHPMP(hp:int,mp:int):void
		{
			currentHP = hp;
			currentMP = mp;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.UPDATE_HPMP));
			
			if(GlobalData.selfScenePlayerInfo && GlobalData.selfScenePlayerInfo.getIsFight())
			{
				if((totalHP - currentHP) >= currentHP && !GlobalData.bagInfo.getUseHpItem(false))
				{
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.SHOW_MEDICINES_ICON,{medicinesType:1}));
				}
				else if((totalMP - currentMP) >= currentMP && !GlobalData.bagInfo.getUseMpItem(false))
				{
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.SHOW_MEDICINES_ICON,{medicinesType:2}));
				}
			}
		}
		
		public function canfly():Boolean
		{
			var count:int =  GlobalData.bagInfo.getItemCountById(CategoryType.TRANSFER);
			if(getVipType() == VipType.BESTVIP) return true;
			if(getVipType() == VipType.BETTERVIP)
			{
				if(count < 1 && flyCount <1) return false;
				else return true;
			}
			if(getVipType() == VipType.VIP)
			{
				if(count < 1 && flyCount <1) return false;
				else return true;
			}
			if(count < 1) return false;
			return true;
		}
		
		public function updateVipInfo(vipId:int, time:int, flyCount:int, bugle:int, isVipBindYuanbaoGot:Boolean, isVipCopperGot:Boolean, isVipBuffGot:Boolean):void
		{
			this.vipType = vipId;
			this.vipTime = time;
			this.flyCount = flyCount;
			this.bugle = bugle;
			this.isVipBindYuanbaoGot = isVipBindYuanbaoGot;
			this.isVipCopperGot = isVipCopperGot;
			this.isVipBuffGot = isVipBuffGot;
			dispatchEvent(new VipCommonEvent(VipCommonEvent.VIPSTATECHANGE));
		}
		
		public function updateYuanBaoScore(value:int):void
		{
			yuanBaoScore = value;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.UPDATE_YUANBAO_SCORE));
		}
		
		public function updateVipAwardYuanbaoState(value:Boolean):void
		{
			isVipBindYuanbaoGot = value;
			dispatchEvent(new VipCommonEvent(VipCommonEvent.AWARD_YUANBAO_STATECHANGE));
		}
		
		public function updateVipAwardCopperState(value:Boolean):void
		{
			isVipCopperGot = value;
			dispatchEvent(new VipCommonEvent(VipCommonEvent.AWARD_COPPER_STATECHANGE));
		}
		
		public function updateVipAwardBuffState(value:Boolean):void
		{
			isVipBuffGot = value;
			dispatchEvent(new VipCommonEvent(VipCommonEvent.AWARD_BUFF_STATECHANGE));
		}
		
		public function updateVipLastGetAwardDate():void
		{
//			var sysDate:Date = GlobalData.systemDate.getSystemDate();
//			if(vipLastGetAwardDate.fullYear == sysDate.fullYear && vipLastGetAwardDate.month == sysDate.month && vipLastGetAwardDate.date == sysDate.date)
//				isGet = true;
//			else
//				isGet = false;
//			if(!isGet && (getVipType() > 0))
//			{
//				if(GlobalData.vipIcon == null) GlobalData.vipIcon = new VipIcon();
//				GlobalData.vipIcon.show();
//			}
		}
	}
}