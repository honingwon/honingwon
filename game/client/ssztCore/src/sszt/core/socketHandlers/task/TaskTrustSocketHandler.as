package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TaskTrustSocketHandler extends BaseSocketHandler
	{
		public function TaskTrustSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_TRUST;
		}
		
		public static function send(list:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_TRUST);
			pkg.writeByte(list.length);
			for(var i:int = 0; i < list.length; i++)
			{
				pkg.writeInt(list[i]["taskId"]);
				pkg.writeByte(list[i]["type"]);
				pkg.writeByte(list[i]["count"]);
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}