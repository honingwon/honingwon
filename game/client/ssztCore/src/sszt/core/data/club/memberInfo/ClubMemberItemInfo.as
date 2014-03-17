/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午2:28:51 
 * 
 */ 
package sszt.core.data.club.memberInfo
{
	import flash.events.EventDispatcher;
	
	public class ClubMemberItemInfo extends EventDispatcher 
	{
		public var serverId:int;
		public var id:Number;
		public var name:String;
		public var vipType:int;
		public var duty:int;
		public var career:int;
		public var sex:Boolean;
		public var level:int;
		public var currentExploit:int;
		public var totalExploit:int;
		public var outTime:Date;
		public var fightCapacity:int;
		public var army:String;
		public var contribute:int;
		public var exploit:int;
		public var exploitToday:int;
		public var isOnline:Boolean;
		
		public function update():void{
			dispatchEvent(new ClubMemberInfoUpdateEvent(ClubMemberInfoUpdateEvent.MEMBER_ITEMINFO_UPDATE));
		}
		
	}
}
