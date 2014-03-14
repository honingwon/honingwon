package com.codeTooth.actionscript.interaction.mouse.core
{
	/**
	 * 事件类型
	 */	
	
	public class EventType
	{
		private var _eventType:String = null;
		
		private var _useBubbles:Boolean = false;
		
		private var _useCapture:Boolean = false;
		
		/**
		 * 构造函数
		 * 
		 * @param eventType 事件类型
		 * @param useBubbles 在冒泡阶段
		 * @param useCapture 在捕获阶段
		 */		
		public function EventType(eventType:String, useBubbles:Boolean = true, useCapture:Boolean = false)
		{
			_eventType = eventType;
			
			_useBubbles = useBubbles;
			
			_useCapture = useCapture;
		}
		
		/**
		 * 事件类型
		 */		
		public function get eventType():String
		{
			return _eventType;
		}
		
		/**
		 * 在冒泡阶段
		 */		
		public function get useBubbles():Boolean
		{
			return _useBubbles;
		}
		
		/**
		 * 在捕获阶段
		 */		
		public function get useCapture():Boolean
		{
			return _useCapture;
		}

	}
}