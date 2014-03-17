package sszt.core.socketHandlers
{
	import sszt.interfaces.socket.ISubCodeSocketHandler;

	public class BaseSubCodeSocketHandler extends BaseSocketHandler implements ISubCodeSocketHandler
	{
		public function BaseSubCodeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public function getSubCode():int
		{
			return 0;
		}
	}
}