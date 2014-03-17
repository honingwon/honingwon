package sszt.core.data.activity
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SevenActivityItemInfo extends EventDispatcher
	{
		public var id:int;
		public var isEnd:Boolean;
		public var innerLen:int;
		public var userArray:Array;
		
		
		public function SevenActivityItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}