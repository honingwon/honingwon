package sszt.club.datas.workInfo
{
	import flash.events.EventDispatcher;
	
	import sszt.club.events.ClubWorkInfoUpdateEvent;

	public class ClubWorkInfo extends EventDispatcher
	{
		public var selfExploit:int;
		public var taskFinishList:Array;
		public var taskLimitNum:int;
		public var activityFinishList:Array;
		public var activityLimitNum:int;
		
		public var isCanAccept:Boolean;
		
		public function ClubWorkInfo()
		{
		}
		
		public function update():void
		{
			dispatchEvent(new ClubWorkInfoUpdateEvent(ClubWorkInfoUpdateEvent.WORK_INFO_UPDATE));
		}
		
//		public function udpateData(argExploit:int,argTaskFinishList:Array,argTaskLimitNum:int,argActivityFinishList:Array,argActivityLimitNum:int):void
//		{
//			selfExploit = argExploit;
//			taskFinishList = argTaskFinishList;
//			taskLimitNum = argTaskLimitNum;
//			activityFinishList = activityFinishList;
//			activityLimitNum = activityLimitNum;
//			dispatchEvent(new ClubWorkInfoUpdateEvent(ClubWorkInfoUpdateEvent.WORK_INFO_UPDATE));
//		}
	}
}