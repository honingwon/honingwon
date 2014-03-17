package sszt.club.datas.contributeLogInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ContributeInfoUpdateEvent;
	
	public class ClubContributeLogInfo extends EventDispatcher
	{
		public var total:int;
		public var contributeLogList:Array;
		
		public function ClubContributeLogInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function updateList(list:Array):void
		{
			contributeLogList = list;
			dispatchEvent(new ContributeInfoUpdateEvent(ContributeInfoUpdateEvent.CONTRIBUTE_LOG_UPDATE));
		}
		
		public function dispose():void
		{
			contributeLogList = null;
		}
	}
}