package sszt.core.socketHandlers.target
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 目标成就完成时通知 
	 * @author chendong
	 * 
	 */	
	public class TargetFinishSocketHandler extends BaseSocketHandler
	{
		public function TargetFinishSocketHandler(handlerData:Object=null)
		{
			//TODO: implement function
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TARGET_FINISH;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var leng:int = _data.readShort();
			var targetId:int = 0;
			var i:int = 0;
			for(;i<leng;i++)
			{
				targetId = _data.readInt();
				ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.FINISH_TARGET,{targetId:targetId}));
			}
			
			handComplete();
		}
	}
}