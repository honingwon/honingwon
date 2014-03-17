package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TaskTrustFinishSocketHandler extends BaseSocketHandler
	{
		public function TaskTrustFinishSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_TRUST_FINISH;
		}
		
		public static function send(list:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_TRUST_FINISH);
			pkg.writeByte(list.length);
			for(var i:int = 0; i < list.length; i++)
			{
				pkg.writeInt(list[i]);
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}