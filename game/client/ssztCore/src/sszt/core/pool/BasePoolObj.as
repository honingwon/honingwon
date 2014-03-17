package sszt.core.pool
{
	import sszt.interfaces.pool.IPoolManager;
	import sszt.interfaces.pool.IPoolObj;
	
	public class BasePoolObj implements IPoolObj
	{
		protected var _manager:IPoolManager;
		
		public function BasePoolObj()
		{
		}
		
		public function setManager(manager:IPoolManager):void
		{
			_manager = manager;
		}
		
		public function reset(param:Object):void
		{
		}
		
		public function clear():void
		{
		}
		
		public function collect():void
		{
			if(_manager)
				_manager.removeObj(this);
		}
		
		public function dispose():void
		{
		}
		
		public function poolDispose():void
		{
			
		}
	}
}