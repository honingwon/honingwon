package sszt.core.data.target
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;

	public class TargetInfo extends EventDispatcher implements ITick
	{
		private var _targetByIdDic:Dictionary;
		
		private var _achByIdDic:Dictionary;
		
		private var _num:int; //未领取数量
		
		private var _achCurrentNum:int;
		private var _achTotalNum:int;
		
		
		private var _historyArray:Array;
		
		private var _count:int = 0;
		
		public function TargetInfo()
		{
			_targetByIdDic = new Dictionary();
			_achByIdDic = new Dictionary();
			_historyArray = [];
		}
		
		public function start():void
		{
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
			_count = 0;
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			// TODO Auto Generated method stub
			_count++;
			if(_count >= 300) //1分钟
			{
				ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.CLEAR_FINISH_TARGET));
				_count = 0;
			}
		}
		
		public function get achTotalNum():int
		{
			return _achTotalNum;
		}

		public function set achTotalNum(value:int):void
		{
			_achTotalNum = value;
		}

		public function get achCurrentNum():int
		{
			return _achCurrentNum;
		}

		public function set achCurrentNum(value:int):void
		{
			_achCurrentNum = value;
		}

		/**
		 * 未领取数量 
		 * @return 
		 * 
		 */
		public function get num():int
		{
			return _num;
		}

		public function set num(value:int):void
		{
			_num = value;
		}

		/**
		 * 成就数据
		 */
		public function get achByIdDic():Dictionary
		{
			return _achByIdDic;
		}


		public function set achByIdDic(value:Dictionary):void
		{
			_achByIdDic = value;
		}

		/**
		 * 目标数据
		 */
		public function get targetByIdDic():Dictionary
		{
			return _targetByIdDic;
		}


		public function set targetByIdDic(value:Dictionary):void
		{
			_targetByIdDic = value;
		}

		public function updateTarget(argTarget:Dictionary):void
		{
			_targetByIdDic = null;
			_targetByIdDic = argTarget;
//			ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.UPDATE_TARGET_LIST));
		}

		/**
		 * 成就历史数据 
		 * @return 
		 * 
		 */		
		public function get historyArray():Array
		{
			return _historyArray;
		}

		/**
		 * 成就历史数据 
		 * @param value
		 * 
		 */		
		public function set historyArray(value:Array):void
		{
			_historyArray = value;
		}

	}
}