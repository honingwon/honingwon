package sszt.marriage.event
{
	import flash.events.Event;
	
	public class MarriageRelationEvent extends Event
	{
		public static const UPDATE:String = 'update';
//		public static const RELATION_CHANGE:String = 'relationChange';
//		public static const DIVORCE_SUCCESS:String = 'divorceSuccess';
		public var data:Object;
		
		public function MarriageRelationEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}