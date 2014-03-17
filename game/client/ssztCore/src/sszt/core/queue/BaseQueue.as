package sszt.core.queue
{
	import sszt.constData.CommonConfig;

	public class BaseQueue implements IQueue
	{
		protected var _isfinish:Boolean;
		protected var _hadDoInit:Boolean;
		protected var _life:int;
		protected var _info:IQueueInfo;
		
		public function BaseQueue(info:IQueueInfo,life:int = -1)
		{
			_isfinish = false;
			_hadDoInit = false;
			_life = life;
			_info = info;
		}
		
		public function get isFinished():Boolean
		{
			return _isfinish;
		}
		
		public function set isFinished(value:Boolean):void
		{
			_isfinish = value;
		}
		/**
		 * 回调用
		 * 
		 */		
		public function setFinish():void
		{
			isFinished = true;
		}
		
		public function skip():void
		{
			isFinished = true;
		}
		
		public function configure(...args):void
		{
		}
		
		public function get hadDoInit():Boolean
		{
			return _hadDoInit;
		}
		
		public function init():void
		{
			_hadDoInit = true;
			if(_info && _info.pkg)
				_info.pkg.position = CommonConfig.PACKAGE_HEAD_SIZE + 1;
		}
		
		public function managerClear():void
		{
			dispose();
		}
		
		public function dispose():void
		{
			if(_info)
			{
				_info.dispose();
				_info = null;
			}
		}
		
		public function update(times:int,dt:Number=0.04):void
		{
			if(_life != -1)
			{
				_life-= times;
				if(_life <= 0)
				{
					isFinished = true;
				}
			}
		}
	}
}