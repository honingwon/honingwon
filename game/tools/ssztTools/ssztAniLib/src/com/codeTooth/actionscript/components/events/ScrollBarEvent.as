package com.codeTooth.actionscript.components.events
{
	import flash.events.Event;
	
	public class ScrollBarEvent extends Event
	{
		public static const SCROLL:String = "scroll";
		
		public var scrollPosition:Number;
		
		public function ScrollBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, 
														scrollPosition:Number = NaN)
		{
			super(type, bubbles, cancelable);
			
			this.scrollPosition = scrollPosition;
		}
		
		override public function clone():Event
		{
			return new ScrollBarEvent(type, bubbles, cancelable, scrollPosition);
		}
	}
}