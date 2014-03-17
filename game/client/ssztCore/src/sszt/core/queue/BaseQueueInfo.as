package sszt.core.queue
{
	import sszt.interfaces.socket.IPackageIn;
	
	public class BaseQueueInfo implements IQueueInfo
	{
		private var _pkg:IPackageIn;
		private var _handlerData:*;
		
		public function BaseQueueInfo(pkg:IPackageIn,handlerData:* = null)
		{
			_pkg = pkg;
			_handlerData = handlerData;
		}
		
		public function get pkg():IPackageIn
		{
			return _pkg;
		}
		
		public function get handleData():*
		{
			return _handlerData;
		}
		
		public function dispose():void
		{
			_pkg = null;
		}
	}
}