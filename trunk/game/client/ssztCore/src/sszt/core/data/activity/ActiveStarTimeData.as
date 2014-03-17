package sszt.core.data.activity
{
	public class ActiveStarTimeData
	{
		private var _activeId:int;
		private var _time:int;
		private var _continueTime:int;
		private var _state:int;
		
		/**
		 * 活动id 
		 */
		public function get activeId():int
		{
			return _activeId;
		}

		/**
		 * @private
		 */
		public function set activeId(value:int):void
		{
			_activeId = value;
		}

		/**
		 * 活动开始时间 
		 */
		public function get time():int
		{
			return _time;
		}

		/**
		 * @private
		 */
		public function set time(value:int):void
		{
			_time = value;
		}

		/**
		 * 活动持续时间 
		 */
		public function get continueTime():int
		{
			return _continueTime;
		}

		/**
		 * @private
		 */
		public function set continueTime(value:int):void
		{
			_continueTime = value;
		}

		/**
		 * 状态 1开启，2即将开启  ，0关闭
		 */
		public function get state():int
		{
			return _state;
		}

		/**
		 * @private
		 */
		public function set state(value:int):void
		{
			_state = value;
		}
	}
}