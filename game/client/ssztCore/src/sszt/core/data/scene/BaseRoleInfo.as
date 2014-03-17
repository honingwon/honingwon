package sszt.core.data.scene
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.constData.AttackTargetResultType;
	import sszt.core.action.BaseAction;
	import sszt.core.action.IAction;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.scene.BaseSceneObjInfo;
	
	public class BaseRoleInfo extends BaseSceneObjInfo
	{
		private var _currentHp:int;
		private var _currentMp:int;
		private var _totalHp:int;
		private var _totalMp:int;
		
		/**
		 * 人物状态
		 */		
		public var state:PlayerState = new PlayerState();
		/**
		 * 角色状态
		 */		
		protected var _roleSceneState:int = 1;
		
		private var _walkAction:IAction;
		
		public var preSpeed:Number = 0;
		
		private var _speed:Number = 6;
		public function get speed():Number
		{
			return _speed;
		}
		public function set speed(value:Number):void
		{
			_speed = Math.ceil( value);
		}
		
		
		public var buffs:Dictionary;
		
		public function BaseRoleInfo(walkAction:IAction)
		{
			_walkAction = walkAction;
			if(_walkAction)
			{
				_walkAction["setPlayer"](this);
				_walkAction["setWalkComplete"](walkComplete);
			}
			_roleSceneState = 1;
			buffs = new Dictionary();
		}
		
		public function updateHPMP(currentHP:int,currentMP:int,totalHP:int,totalMP:int):void
		{
			_currentHp = currentHP;
			_currentMp = currentMP;
			_totalHp = totalHP;
			_totalMp = totalMP;
		}
		
		public function get currentHp():int
		{
			return _currentHp;
		}
		public function set currentHp(value:int):void
		{
			if(_currentHp == value)return;
			_currentHp = value > 0 ? value : 0;
			_currentHp = _currentHp > totalHp ? totalHp : _currentHp;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.INFO_UPDATE,1));
		}
		
		public function get currentMp():int
		{
			return _currentMp;
		}
		public function set currentMp(value:int):void
		{
			if(_currentMp == value)return;
			_currentMp = value > 0 ? value : 0;
			_currentMp = _currentMp > totalMp ? totalMp : _currentMp;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.INFO_UPDATE));
		}
		
		public function get totalHp():int
		{
			return _totalHp;
		}
		public function set totalHp(value:int):void
		{
			if(_totalHp == value)return;
			_totalHp = value;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.TOTALHP_UPDATE));
		}
		
		public function get totalMp():int
		{
			return _totalMp;
		}
		public function set totalMp(value:int):void
		{
			if(_totalMp == value)return;
			_totalMp = value;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.TOTALMP_UPDATE));
		}
		
		public function addAction(action:BaseAction):void
		{
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.ADDACTION,action));
		}
		
		public function addBuff(buff:BuffItemInfo):void
		{
			buffs[buff.templateId] = buff;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.ADDBUFF,buff));
		}
		
		public function updateBuff(buff:BuffItemInfo):void
		{
			buffs[buff.templateId] = buff;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.UPDATEBUFF,buff));
		}
		
		public function removeBuff(id:int):void
		{
			var buff:BuffItemInfo = buffs[id];
			if(buff)
			{
				delete buffs[id];
				dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.REMOVEBUFF,buff));
			}
		}
		public function getBuff(id:int):BuffItemInfo
		{
			return buffs[id];
		}
		public function getBuffByType(type:int):BuffItemInfo
		{
			for each(var i:BuffItemInfo in buffs)
			{
				if(i && i.getTemplate().type == type)
				{
					return i;
				}
			}
			return null;
		}
		
		
		/**********攻击状态处理**********************************************/
		/**
		 * 清空攻击状态
		 * isForce 是否强制清除状态（强制时才清除战斗状态）
		 */	
		public function clearAttackState(isForce:Boolean = false):void
		{
			if(!getIsDead())
			{
				if(getIsFight() && !isForce)return;
				state.setCommon(true);
			}
		}
		
		/**
		 * 战斗
		 * @return 
		 * 
		 */		
		public function getIsFight():Boolean
		{
			return state.getFight() || state.getReady() || state.getDead() || state.getDizzy() || state.getDizzyProtect() || state.getSlow() || state.getSlowProtect() || state.getPoison();
		}
		/**
		 * 能否走路
		 * @return 
		 * 
		 */		
		public function getCanWalk():Boolean
		{
			return !state.getDizzy() && !state.getDead();
		}
		/**
		 * 死亡
		 * @return 
		 * 
		 */		
		public function getIsDead():Boolean
		{
			return state.getDead();
		}
		/**
		 * 吟唱
		 * @return 
		 * 
		 */		
		public function getIsReady():Boolean
		{
			return state.getReady();
		}
		/**
		 * 普通状态
		 * @return 
		 * 
		 */		
		public function getIsCommon():Boolean
		{
			return state.getCommon();
		}
		
		/**
		 * 击晕状态
		 * @return 
		 * 
		 */		
		public function getIsDizzy():Boolean
		{
			return state.getDizzy();
		}
		
		public function getIsDeadOrDizzy():Boolean
		{
			return state.getDizzy() || state.getDead();
		}
		
		/**
		 *  击晕保存状态
		 * @return 
		 * 
		 */		
		public function getIsDizzyProtect():Boolean
		{
			return state.getDizzyProtect()
		}
		/**
		 * 减速
		 * @return 
		 * 
		 */		
		public function getIsSlow():Boolean
		{
			return state.getSlow();
		}
		public function getIsSlowProtect():Boolean
		{
			return state.getSlowProtect();
		}
		
		/**
		 * 中毒
		 * @return 
		 * 
		 */		
		public function getIsPoison():Boolean
		{
			return state.getPoison();
		}
		
		override public function getCanAttack():Boolean
		{
			if(getIsDead())return false;
			//倒地，无敌
			return super.getCanAttack();
		}
		
		public function setAttackState(value:int):void
		{
			state.setState(value);
		}
		
		/********************************************************/
		
		public function getCareer():int
		{
			return 0;
		}
		
		public function getSex():Boolean
		{
			return false;
		}
		
		public function getHpPercent():int
		{
			return int((currentHp / totalHp) * 100);
		}
		public function getMpPercent():int
		{
			return int((currentMp / totalMp) * 100);
		}
		
		
		/*************走路数据更新*******************************************/
		public function updateDir(dir:int):void
		{
			this.dir = dir;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.DIR_UPDATE,dir));
		}
		public function doWalkAction():void
		{
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.DO_WALK_ACTION));
		}
		public function walkComplete():void
		{
			if(_walkAction)
			{
				GlobalAPI.tickManager.removeTick(_walkAction);
			}
			if(_walkComplete != null)
			{
				_walkComplete();
			}
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.WALK_COMPLETE));
		}
		override protected function startWalk():void
		{
			super.startWalk();
			if(_walkAction)
			{
				_walkAction.configure(_path);
				GlobalAPI.tickManager.addTick(_walkAction);
			}
		}
		override public function setStand():void
		{
			super.setStand();
			if(_walkAction)
			{
				GlobalAPI.tickManager.removeTick(_walkAction);
				_walkAction["walkStop"]();
			}
		}
		override public function dispose():void
		{
			super.dispose();
			if(_walkAction)
			{
				GlobalAPI.tickManager.removeTick(_walkAction);
				_walkAction.dispose();
				_walkAction = null;
			}
		}
	}
}