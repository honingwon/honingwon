package com.codeTooth.actionscript.classesLoader.core
{
	import flash.events.Event;
	
	/**
	 * 类加载器事件
	 */	
	
	public class ClassesLoaderEvent extends Event
	{
		/**
		 * 加载完成
		 */		
		public static const COMPLETE:String = "complete";
		
		/**
		 * 加载的过程中
		 */		
		public static const PROGRESS:String = "progress";
		
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
		public var url:String = null;
		
		/**
		 * 已加载字节数
		 */		
		public var bytesTotal:Number = -1;
		
		/**
		 * 总字节数
		 */		
		public var bytesLoaded:Number = -1;
		
		/**
		 * @inheritDoc
		 */		
		public function ClassesLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var newEvent:ClassesLoaderEvent = new ClassesLoaderEvent(type, bubbles, cancelable);
			newEvent.url = url;
			newEvent.bytesTotal = bytesTotal;
			newEvent.bytesLoaded = bytesLoaded;
			
			return newEvent;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return formatToString("ClassesLoaderEvent", "type", "bubbles", "cancelable", "eventPhase", "url", "bytesTotal", "bytesLoaded");
		}
	}
	
}