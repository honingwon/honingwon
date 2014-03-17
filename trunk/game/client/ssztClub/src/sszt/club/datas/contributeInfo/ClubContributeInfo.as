package sszt.club.datas.contributeInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ContributeInfoUpdateEvent;
	
	public class ClubContributeInfo extends EventDispatcher
	{
		public var total:int;
		public var contributeList:Array;
		
		public function ClubContributeInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function updateList(list:Array):void
		{
			contributeList = list;
			dispatchEvent(new ContributeInfoUpdateEvent(ContributeInfoUpdateEvent.CONTRIBUTE_INFO_UPDATE));
		}
		
		public function dispose():void
		{
			contributeList = null;
		}
	}
}