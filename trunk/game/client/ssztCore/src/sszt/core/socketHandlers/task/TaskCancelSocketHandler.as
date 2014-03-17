package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TaskCancelSocketHandler extends BaseSocketHandler
	{
		public function TaskCancelSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_CANCEL;
		}
		
		public static function sendCancel(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_CANCEL);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}