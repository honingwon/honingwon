package sszt.core.data.marriage
{
	import flash.events.EventDispatcher;

	public class MarriageInfo extends EventDispatcher
	{
		/**
		 * 亲密度要求的最小值
		 * */
		public static const FRIEND_POINT_LEAST:int = 1000;
		
		/**
		 *豪华  结婚费用
		 * */
		public static const GOOD_WEDDING_COST:int = 520;
		/**
		 *奢靡  结婚费用
		 * */
		public static const BETTER_WEDDING_COST:int = 1314;
		
		public static const GOOD_RING_ID:int = 274001;
		public static const BETTER_RING_ID:int = 274002;
		
		public static const GOOD_WEDDING_EXP:int = 1000;
		public static const BETTER_WEDDING_EXP:int = 3000;
		
		public static const GOOD_WEDDING_FREE_CANDIES_NUM_TOTAL:int = 1;		
		public static const BETTER_WEDDING_FREE_CANDIES_NUM_TOTAL:int = 3;
		
		public static const WEDDING_FREE_CANDIES_COST:int = 0;
		public static const WEDDING_GOOD_CANDIES_COST:int = 5;
		public static const WEDDING_BETTER_CANDIES_COST:int = 10;
		public static const WEDDING_BEST_CANDIES_COST:int = 30;
		public static const WEDDING_SUPER_CANDIES_COST:int = 100;
		
		public static const WEDDING_INVITATION_PAGESIZE:int = 9999;
		
		public var targetPlayerInfoCode:int;
		public var targetPlayerFriendPoint:int;
		public var targetPlayerId:Number;
		
		public var freeWeddingCandiesNum:int;
		
//		public var currentWeddingInvitationInfo:WeddingInvitationInfo;
		
		public var weddingGiftList:Array;
		
		public function updateWeddingGiftList(list:Array):void
		{
			weddingGiftList = list;
			dispatchEvent(new MarriageInfoUpdateEvent(MarriageInfoUpdateEvent.WEDDING_GIFT_LIST_UPDATE));
		}
	}
}