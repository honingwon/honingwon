/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午2:21:54 
 * 
 */ 
package sszt.core.data.club.memberInfo 
{
	import flash.events.EventDispatcher;
	
	public class ClubMemberInfo extends EventDispatcher {
		
		public var currentMaster:int;
		public var totalHonor:int;
		public var currentHonor:int;
		public var totalMember:int;
		public var currentMember:int;
		public var totalPrepare:int;
		public var currentPrepare:int;
		public var list:Array;
		public var clubNotice:String = "";
		private var _sortOnIndex:int = -1;
		public var sortNick:Boolean;
		public var sortDuty:Boolean;
		public var sortCareer:Boolean;
		public var sortSex:Boolean;
		public var sortLevel:Boolean;
		public var sortContribute:Boolean;
		public var sortFight:Boolean;
		public var sortOnline:Boolean;
		
		public var currentViceMaster:int;	
		public var totalViceMaster:int;
		public var clubLevel:int;
		public function ClubMemberInfo(){
			this.list = [];
		}
		
		public function getSortList():Array{
			if (this._sortOnIndex == -1){
				this.list.sortOn(["duty", "isOnline", "totalExploit"], [Array.NUMERIC, (Array.NUMERIC | Array.DESCENDING), (Array.NUMERIC | Array.DESCENDING)]);
			}
			return (this.list);
		}
		
		public function getSortListByOnLine():Array{
			this.list.sortOn(["isOnline", "duty"], [(Array.NUMERIC | Array.DESCENDING), Array.NUMERIC]);
			return (this.list);
		}
		
		public function getSortListByPage(page:int, pageSize:int):Array{
			if (page < 1 || pageSize < 1){
				return (null);
			}
			return (this.list.slice((pageSize * (page - 1)), (pageSize * page)));
		}
		
		public function getOnlineCount():int{
			var i:ClubMemberItemInfo;
			var count:int;
			for each (i in this.list) {
				if (i.isOnline){
					count++;
				}
			}
			return (count);
		}
		
		public function onlineChange(id:Number):void{
			dispatchEvent(new ClubMemberInfoUpdateEvent(ClubMemberInfoUpdateEvent.MEMBER_ONLINE_CHANGE, id));
		}
		
		public function setList(value:Array):void{
			this.list = value;
			switch (this._sortOnIndex){
				case 0:
					if (this.sortNick){
						this.list.sortOn(["name"], [Array.CASEINSENSITIVE]);
					} 
					else {
						this.list.sortOn(["name"], [(Array.CASEINSENSITIVE | Array.DESCENDING)]);
					}
					break;
				case 1:
					if (this.sortDuty){
						this.list.sortOn(["duty"], [(Array.NUMERIC | Array.DESCENDING)]);
					} 
					else {
						this.list.sortOn(["duty"], [Array.NUMERIC]);
					}
					break;
				case 2:
					if (this.sortCareer){
						this.list.sortOn(["career"], [Array.NUMERIC]);
					} 
					else {
						this.list.sortOn(["career"], [(Array.NUMERIC | Array.DESCENDING)]);
					}
					break;
				case 3:
					if (this.sortSex){
						this.list.sortOn(["sex"], [Array.NUMERIC]);
					} 
					else {
						this.list.sortOn(["sex"], [(Array.NUMERIC | Array.DESCENDING)]);
					}
					break;
				case 4:
					if (this.sortLevel){
						this.list.sortOn(["level"], [(Array.NUMERIC | Array.DESCENDING)]);
					} 
					else {
						this.list.sortOn(["level"], [Array.NUMERIC]);
					}
					break;
				case 5:
					if (this.sortContribute){
						this.list.sortOn(["totalExploit"], [(Array.NUMERIC | Array.DESCENDING)]);
					} 
					else {
						this.list.sortOn(["totalExploit"], [Array.NUMERIC]);
					}
					break;
				case 6:
					if (this.sortFight){
						this.list.sortOn(["fightCapacity"], [(Array.NUMERIC | Array.DESCENDING)]);
					} 
					else {
						this.list.sortOn(["fightCapacity"], [Array.NUMERIC]);
					}
					break;
				case 7:
					if (this.sortOnline){
						this.list.sortOn(["isOnline", "outTime"], [(Array.NUMERIC | Array.DESCENDING), (Array.NUMERIC | Array.DESCENDING)]);
					} else {
						this.list.sortOn(["isOnline", "outTime"], [Array.NUMERIC, Array.NUMERIC]);
					}
					break;
				default:
					this.list.sortOn(["duty", "isOnline", "totalExploit"], [Array.NUMERIC, (Array.NUMERIC | Array.DESCENDING), (Array.NUMERIC | Array.DESCENDING)]);
			}
			dispatchEvent(new ClubMemberInfoUpdateEvent(ClubMemberInfoUpdateEvent.MEMBERINFO_UPDATE));
		}
		
		public function getClubMember(userId:Number):ClubMemberItemInfo{
			var info:ClubMemberItemInfo;
			for each (info in this.list) {
				if (info.id == userId){
					return (info);
				}
			}
			return (null);
		}
		
		public function noticeUpdate(str:String):void{
			this.clubNotice = str;
			dispatchEvent(new ClubMemberInfoUpdateEvent(ClubMemberInfoUpdateEvent.CLUB_NOTICE_UPDATE));
		}
		
//		public function set currentHonor(honorCount:int):void{
//			this._currentHonor = honorCount;
//		}
//		
//		public function get currentHonor():int{
//			return this._currentHonor - this.currentMaster - 1;
//		}
		
		public function dispose():void{
			this.list = null;
		}
		
		public function get sortOnIndex():int{
			return (this._sortOnIndex);
		}
		
		public function set sortOnIndex(value:int):void{
			this._sortOnIndex = value;
		}
		
	}
}
