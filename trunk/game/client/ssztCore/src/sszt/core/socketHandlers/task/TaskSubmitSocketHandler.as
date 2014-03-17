package sszt.core.socketHandlers.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class TaskSubmitSocketHandler extends BaseSocketHandler
	{
		public function TaskSubmitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_SUBMIT;
		}
		
		override public function handlePackage():void
		{
			ModuleEventDispatcher.dispatchModuleEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.COMPLETE_TASK));
			
			handComplete();
		}
		
		public static function sendSubmit(id:int,awardId:int = -1):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TASK_SUBMIT);
			pkg.writeInt(id);
			pkg.writeInt(awardId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}