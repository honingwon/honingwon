package sszt.marriage.event
{
	import flash.events.Event;
	
	public class WeddingUIEvent extends Event
	{
		public var data:Object;
		
		/**
		 * 打开婚礼邀请面板
		 * */
		public static const SHOW_WEDDING_INVITATION_PANEL:String = "showWeddingInvitationPanel";
		
		/**
		 * 打开查看礼金面板
		 * */
		public static const SHOW_WEDDING_CHECK_GIFT_PANEL:String = "showWeddingCheckGiftPanel";
		
		/**
		 * 发喜糖
		 * */
		public static const PRESENT_WEDDING_CANDIES:String = "presentWeddingCandies";
		
		/**
		 * 随礼
		 * */
		public static const PRESENT_CASH_GIFT:String = "presentCashGift";
		
		public static const LEAVE:String = "leave";
		
		/**
		 * 结婚仪式
		 * */
		public static const WEDDING_CEREMONY:String = "weddingCeremony";
		
		public function WeddingUIEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}