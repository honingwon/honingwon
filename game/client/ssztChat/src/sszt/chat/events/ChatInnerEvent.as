package sszt.chat.events
{
	import flash.events.Event;
	
	public class ChatInnerEvent extends Event
	{
		public static const FACE_ADD:String = "faceAdd";
		
		public static const CHANNEL_CHANGE:String = "channelChange";
		
		public var data:Object;
		
		public function ChatInnerEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}