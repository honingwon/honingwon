package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TaskAcceptSocketHandler extends BaseSocketHandler
	{
		public function TaskAcceptSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_ACCEPT;
		}
		
		public static function sendAccept(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_ACCEPT);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}