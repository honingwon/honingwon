package com.codeTooth.actionscript.components.core
{
	import flash.events.Event;

	/**
	 * 组件应用事件
	 */	
	
	public class ComponentsApplicationEvent extends Event
	{
		/**
		 * 加载完成
		 */		
		public static const COMPLETE:String = "complete";
		
		/**
		 * 加载发生IOError 
		 */		
		public static const IO_ERROR:String = "ioError";
		
		/**
		 * 加载发生SecurityError 
		 */		
		public static const SECURITY_ERROR:String = "securityError";
		
		/**
		 * 当前正在加载的url 
		 */		
		public var url:String;
		
		public function ComponentsApplicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:ComponentsApplicationEvent = new ComponentsApplicationEvent(type, bubbles, cancelable);
			newEvent.url = url;
			
			return newEvent;
		}
	}
}