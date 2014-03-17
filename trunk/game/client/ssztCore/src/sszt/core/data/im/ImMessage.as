package sszt.core.data.im
{
	public class ImMessage
	{
		public var time:String;
		public var message:String;
		public var isSelf:Boolean;
		public var type:int;
		public static const UNREAD_ONE:int = 0;
		public static const UNREAD_TWO:int = 1;
		public static const READ:int = 2;
		
		public function ImMessage()
		{
			
		}
	}
}