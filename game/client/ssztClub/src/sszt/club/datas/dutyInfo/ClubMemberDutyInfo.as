package sszt.club.datas.dutyInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ClubMemberDutyInfo extends EventDispatcher
	{
		public var useId:Number;
//		public var nick:String;
		public var duty:int;
		
		public function ClubMemberDutyInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}