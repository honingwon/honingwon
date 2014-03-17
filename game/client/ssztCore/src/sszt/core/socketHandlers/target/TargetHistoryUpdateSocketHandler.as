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
	 * 成就历史数据 
	 * @author chendong
	 * 
	 */	
	public class TargetHistoryUpdateSocketHandler extends BaseSocketHandler
	{
		public function TargetHistoryUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TARGET_HISTORY_UPDATE;
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
				GlobalData.targetInfo.historyArray.push(targetId);
			}
			ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.TARGET_HISTORY));
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TARGET_HISTORY_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}