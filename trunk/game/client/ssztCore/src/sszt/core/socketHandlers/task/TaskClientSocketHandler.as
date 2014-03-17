package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TaskClientSocketHandler extends BaseSocketHandler
	{
		public function TaskClientSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_CLIENT;
		}
		
		public static function send(taskId:int,requireCount:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_CLIENT);
			pkg.writeInt(taskId);
			pkg.writeByte(requireCount);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}