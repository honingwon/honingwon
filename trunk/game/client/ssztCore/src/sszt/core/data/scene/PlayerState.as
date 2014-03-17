package sszt.core.data.scene
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	
	public class PlayerState extends EventDispatcher
	{
		private static const MAX:int = 4095;
		
		private static const VALUES:Array = [1,2,4,8,16,32,64,128,256,512,1024];
		
		/**
		 * 状态:普通1、战斗2、死亡3、吟唱4、击倒5、击倒保护6、缓慢7、缓慢保护8、中毒9
		 * 
		 */		
		private var _state:int;
		/**
		 * 客户端状态
		 * 普通0、杀一个怪1、挂机2、挂机捡道具3、寻路4
		 */		
		private var _clientState:int;
		
		
		public function PlayerState()
		{
		}
		
		public function setState(value:int):void
		{
			_state = value;
			dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.STATE_CHANGE));
		}
		
		private function setStateByIndex(value:Boolean,index:int):void
		{
			if(value)
			{
				_state = _state | VALUES[index];
			}
			else
			{
				_state = _state & (MAX - VALUES[index]);
			}
		}
		
		private function setClientState(value:Boolean,index:int):void
		{
			if(value)
			{
				_clientState = _clientState | VALUES[index];
			}
			else
			{
				_clientState = _clientState & (MAX - VALUES[index]);
			}
		}
		
		/**
		 * 是否普通状态
		 * @return 
		 * 
		 */		
		public function getCommon():Boolean
		{
			return (_state & 1) > 0;
		}
		public function setCommon(value:Boolean):void
		{
			if(getCommon() == value)return;
			setStateByIndex(value,0);
			if(value)
			{
				setFight(false);
				setDead(false);
				setReady(false);
				setDizzy(false);
				setDizzyProtect(false);
				setSlow(false);
				setSlowProtect(false);
			}
			dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.STATE_CHANGE));
		}
		/**
		 * 是否战斗状态
		 * @return 
		 * 
		 */		
		public function getFight():Boolean
		{
			return (_state & Math.pow(2, 1)) > 0;
		}
		private function setFight(value:Boolean):void
		{
			setStateByIndex(value,1);
		}
		/**
		 * 是否死亡状态
		 * @return 
		 * 
		 */		
		public function getDead():Boolean
		{
			return (_state & Math.pow(2, 2)) > 0;
		}
		private function setDead(value:Boolean):void
		{
			if(getDead() == value)return;
			setStateByIndex(value,2);
		}
		/**
		 * 是否吟唱状态
		 * @return 
		 * 
		 */		
		public function getReady():Boolean
		{
			return (_state & 8) > 0;
		}
		private function setReady(value:Boolean):void
		{
			if(getReady() == value)return;
			setStateByIndex(value,3);
		}
		/**
		 * 是否击倒状态
		 * @return 
		 * 
		 */		
		public function getDizzy():Boolean
		{
			return (_state & 16) > 0;
		}
		private function setDizzy(value:Boolean):void
		{
			if(getDizzy() == value)return;
			setStateByIndex(value,4);
		}
		/**
		 * 是否击晕保护状态
		 * @return 
		 * 
		 */		
		public function getDizzyProtect():Boolean
		{
			return (_state & 32) > 0;
		}
		private function setDizzyProtect(value:Boolean):void
		{
			if(getDizzyProtect() == value)return;
			setStateByIndex(value,5);
		}
		
		/**
		 * 是否减速状态
		 * @return 
		 * 
		 */		
		public function getSlow():Boolean
		{
			return (_state & 64) > 0;
		}
		private function setSlow(value:Boolean):void
		{
			if(getSlow() == value)return;
			setStateByIndex(value,6);
		}
		/**
		 * 是否减速保护状态
		 * @return 
		 * 
		 */		
		public function getSlowProtect():Boolean
		{
			return (_state & 128) > 0;
		}
		private function setSlowProtect(value:Boolean):void
		{
			if(getSlowProtect() == value)return;
			setStateByIndex(value,7);
		}
		
		/**
		 * 是否中毒状态
		 * @return 
		 * 
		 */		
		public function getPoison():Boolean
		{
			return (_state & 256) > 0;
		}
		private function setPoison(value:Boolean):void
		{
			if(getPoison() == value)return;
			setStateByIndex(value,8);
		}
		
		/**
		 * 是否不攻击状态
		 * @return 
		 * 
		 */		
		public function getNotAttack():Boolean
		{
			return (_clientState & 1) > 0;
		}
		public function setNotAttack(value:Boolean,dispatch:Boolean = true):void
		{
			if(getNotAttack() == value)return;
			setClientState(value,0);
			if(value)
			{
				setKillOne(false,false);
				setHangup(false,false);
				setPickUp(false,false);
				setCollect(false,false);
			}
			if(dispatch)
				dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE));
		}
		/**
		 * 是否杀一个目标
		 * @return 
		 * 
		 */		
		public function getKillOne():Boolean
		{
			return (_clientState & 2) > 0;
		}
		public function setKillOne(value:Boolean,dispatch:Boolean = true):void
		{
			if(getKillOne() == value)return;
			setClientState(value,1);
			if(value)
			{
				setNotAttack(false,false);
				setFindPath(false,false);
				setHangup(false,false);
				setPickUp(false,false);
				setCollect(false,false);
			}
			if(dispatch)
				dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE));
		}
		/**
		 * 是否挂机中
		 * @return 
		 * 
		 */		
		public function getHangup():Boolean
		{
			return (_clientState & 4) > 0;
		}
		public function setHangup(value:Boolean,dispatch:Boolean = true):void
		{
			if(getHangup() == value)return;
			setClientState(value,2);
			if(value)
			{
				setNotAttack(false,false);
				setFindPath(false,false);
				setKillOne(false,false);
				setPickUp(false,false);
				setCollect(false,false);
			}
			if(dispatch)
				dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE));
		}
		/**
		 * 是否拾取中
		 * @return 
		 * 
		 */		
		public function getPickUp():Boolean
		{
			return (_clientState & 8) > 0;
		}
		public function setPickUp(value:Boolean,dispatch:Boolean = true):void
		{
			if(getPickUp() == value)return;
			setClientState(value,3);
			if(value)
			{
				setNotAttack(false,false);
				setKillOne(false,false);
				setHangup(false,false);
				setFindPath(false,false);
				setCollect(false,false);
			}
			if(dispatch)
				dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE));
		}
		/**
		 * 是否寻路中
		 * @return 
		 * 
		 */		
		public function getFindPath():Boolean
		{
			return (_clientState & 16) > 0;
		}
		public function setFindPath(value:Boolean,dispatch:Boolean = true):void
		{
			if(getFindPath() == value)return;
			setClientState(value,4);
			if(value)
			{
				setKillOne(false,false);
				setHangup(false,false);
				setPickUp(false,false);
				setCollect(false,false);
			}
			if(dispatch)
				dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE));
		}
		
		public function getCollect():Boolean
		{
			return (_clientState & 32) > 0;
		}
		public function setCollect(value:Boolean,dispatch:Boolean = true):void
		{
			if(getFindPath() == value)return;
			setClientState(value,5);
			if(value)
			{
				setKillOne(false,false);
				setHangup(false,false);
				setPickUp(false,false);
				setFindPath(false,false);
			}
			if(dispatch)
				dispatchEvent(new PlayerStateUpdateEvent(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE));
		}
		
		
	}
}