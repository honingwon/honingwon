package sszt.core.data.personal
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PersonalInfo extends EventDispatcher
	{
		public var personalMyInfo:PersonalMyInfo;
		public var personalClubInfo:PersonalCluInfo;
		public var personalFriendInfo:PersonalFriendInfo;
		
		public function PersonalInfo(target:IEventDispatcher=null)
		{
			super(target);
			initPersonalMyInfo();
			initPersonalFriendInfo();
			initPersonalCluInfo();
		}
		//个人信息
		public function initPersonalMyInfo():void
		{
			if(personalMyInfo == null)
			{
				personalMyInfo = new PersonalMyInfo();
			}
		}
		public function clearPersonalMyInfo():void
		{
			if(personalMyInfo)
			{
				personalMyInfo = null;
			}
		}
		//好友动态
		public function initPersonalFriendInfo():void
		{
			if(personalFriendInfo == null)
			{
				personalFriendInfo = new PersonalFriendInfo();
			}
		}
		public function clearPersonalFriendInfo():void
		{
			if(personalFriendInfo)
			{
				personalFriendInfo = null;
			}
		}
		//帮会动态
		public function initPersonalCluInfo():void
		{
			if(personalClubInfo == null)
			{
				personalClubInfo = new PersonalCluInfo();
			}
		}
		public function clearPersonalCluInfo():void
		{
			if(personalClubInfo)
			{
				personalClubInfo = null;
			}
		}
	}
}