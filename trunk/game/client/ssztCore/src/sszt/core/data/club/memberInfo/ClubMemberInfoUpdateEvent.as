/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午2:29:33 
 * 
 */ 
package sszt.core.data.club.memberInfo 
{
	import flash.events.Event;
	
	public class ClubMemberInfoUpdateEvent extends Event {
		
		public static const MEMBERINFO_UPDATE:String = "memberInfoUpdate";
		public static const MEMBER_DUTY_UPDATE:String = "memberdutyUpdate";
		public static const MEMBER_ITEMINFO_UPDATE:String = "memberItemInfoUpdate";
		public static const MEMBER_ONLINE_CHANGE:String = "memberOnlineChange";
		public static const CLUB_NOTICE_UPDATE:String = "clubNoticeUpdate";
		
		public var data:Object;
		
		public function ClubMemberInfoUpdateEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false){
			this.data = obj;
			super(type, bubbles, cancelable);
		}
	}
}
