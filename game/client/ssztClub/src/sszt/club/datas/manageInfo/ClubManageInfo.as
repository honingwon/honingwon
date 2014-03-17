package sszt.club.datas.manageInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubManageInfoUpdateEvent;
	
	public class ClubManageInfo extends EventDispatcher
	{
//		public var memberList:Vector.<ClubMemberItemInfo>;
		public var memberList:Array;
		public var clubLevel:int = 0;
		
		public function ClubManageInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
//		public function setList(value:Vector.<ClubMemberItemInfo>):void
		public function setList(value:Array):void
		{
			memberList = value;
			dispatchEvent(new ClubManageInfoUpdateEvent(ClubManageInfoUpdateEvent.MEMBERLIST_UPDATE));
		}
		
		public function dispose():void
		{
			memberList = null;
		}
	}
}