package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TaskQuickCompleteSocketHandler extends BaseSocketHandler
	{
		public function TaskQuickCompleteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_QUICK_COMPLETE;
		}
		
		override public function handlePackage():void
		{
			
			handComplete();
		}
		
		public static function sendSubmit(id:int,awardId:int = -1):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_QUICK_COMPLETE);
			pkg.writeInt(id);
			pkg.writeInt(awardId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}