package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ActiveStartEvents;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 各活动开启时间状态 
	 * @author chendong
	 * 
	 */	
	public class ActiveStartTimeListSocketHandler extends BaseSocketHandler
	{
		public function ActiveStartTimeListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.ACTIVE_START_TIME_LIST;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var leng:int =  _data.readShort();
			var i:int = 0;
			var activeId:int;//活动id
			var time:int;//活动开始时间
			var continueTime:int; //活动持续时间
			var state:int; //状态 1开启，2即将开启
			var activeTime:ActiveStarTimeData;
			for(;i<leng;i++)
			{
				activeTime = new ActiveStarTimeData();
				activeTime.activeId = _data.readInt();
				activeTime.time = _data.readInt(); 
				activeTime.continueTime = _data.readInt();
				activeTime.state = _data.readShort();
				GlobalData.activeStartInfo.activeTimeInfo[activeTime.activeId] = activeTime;
				if(activeTime.state ==1)
				{
					GlobalData.pvpInfo.current_active_id = activeTime.activeId;
				}
			}
			ModuleEventDispatcher.dispatchModuleEvent(new ActiveStartEvents(ActiveStartEvents.ACTIVE_START_UPDATE));
			handComplete();
		}
	}
}