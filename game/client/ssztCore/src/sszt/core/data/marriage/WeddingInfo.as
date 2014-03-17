package sszt.core.data.marriage
{
	import flash.events.EventDispatcher;

	public class WeddingInfo extends EventDispatcher
	{
		private var _isInit:Boolean;
		public var bridegroomId:Number;
		public var brideId:Number;
		public var bridegroom:String;
		public var bride:String;
		/**
		 * 倒计时秒数
		 * */
		private var _seconds:Number;
		/**
		 * 免费喜糖剩余次数
		 * */
		private var _freeNum:int;
		/**
		 * 正在拜堂
		 * */
		private var _inCeremony:Boolean;
		
		public function set inCeremony(value:Boolean):void
		{
			_inCeremony = value
			dispatchEvent(new WeddingInfoUpdateEvent(WeddingInfoUpdateEvent.IN_CEREMONY));
		}
		
		public function get inCeremony():Boolean
		{
			return _inCeremony;
		}
		
		public function set seconds(value:Number):void
		{
			_seconds = value;
			dispatchEvent(new WeddingInfoUpdateEvent(WeddingInfoUpdateEvent.SECONDS_UPDATE));
		}
		
		public function get seconds():Number
		{
			return _seconds;
		}
		
		public function set isInit(value:Boolean):void
		{
			_isInit = value;
			dispatchEvent(new WeddingInfoUpdateEvent(WeddingInfoUpdateEvent.INIT));
		}
		
		public function get isInit():Boolean
		{
			return _isInit;
		}
		
		public function set freeNum(value:int):void
		{
			_freeNum = value;
			dispatchEvent(new WeddingInfoUpdateEvent(WeddingInfoUpdateEvent.FREE_CANDIES_NUM_UPDATE));
		}
		
		public function get freeNum():int
		{
			return _freeNum;
		}
	}
}