package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TaskTransportAddSocketHandler extends BaseSocketHandler
	{
//		public function TaskTransportAddSocketHandler(handlerData:Object=null)
//		{
//			super(handlerData);
//		}
//		
//		override public function getCode():int
//		{
//			return ProtocolType.TASK_TRANSPORT_ADD;
//		}
//		
//		override public function handlePackage():void
//		{
//			if(_data.readBoolean())
//			{
//				QuickTips.show("加货成功，提升经验奖励。");
//			}
//			else
//			{
//				QuickTips.show("加货失败，经验奖励不变。");
//			}
//			handComplete();
//		}
//		
//		public static function send(taskId:int):void
//		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_TRANSPORT_ADD);
//			pkg.writeInt(taskId);
//			GlobalAPI.socketManager.send(pkg);
//		}
	}
}