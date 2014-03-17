package sszt.core.data.target
{
	public class TargetData
	{
		
		private var _target_id:int
		
		private var _num:int;
		
		private var _isReceive:Boolean;
		
		private var _isFinish:Boolean;

		/**
		 * 是否已完成 
		 */
		public function get isFinish():Boolean
		{
			return _isFinish;
		}

		public function set isFinish(value:Boolean):void
		{
			_isFinish = value;
		}

		/**
		 * 是否已领取
		 */
		public function get isReceive():Boolean
		{
			return _isReceive;
		}

		public function set isReceive(value:Boolean):void
		{
			_isReceive = value;
		}

		/**
		 * 在目标中不用到,在成就中累计数量用到 
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
		 *编号 
		 */
		public function get target_id():int
		{
			return _target_id;
		}

		public function set target_id(value:int):void
		{
			_target_id = value;
		}

	}
}