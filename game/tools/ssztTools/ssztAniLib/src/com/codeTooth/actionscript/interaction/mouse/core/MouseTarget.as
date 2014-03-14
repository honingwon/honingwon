package com.codeTooth.actionscript.interaction.mouse.core
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;
	
	/**
	 * 鼠标目标对象
	 */	
	
	public class MouseTarget implements IDestroy
	{
		//对象类型
		private var _targetType:Class = null;
		
		//关注的所有事件类型
		private var _eventTypes:Dictionary = null;
		
		//是否在捕获阶段
		private var _useCapture:Boolean = false;
		
		//是否在冒泡阶段
		private var _useBubbles:Boolean = false;
		
		/**
		 * 构造函数
		 * 
		 * @param targetType 对象类型
		 * @param eventTypes 关注的所有事件类型（of String）
		 * @param useCapture 是否在捕获阶段
		 * @param useBubbles 是否在冒泡阶段
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的targetClass或eventTypes是null
		 */
		public function MouseTarget(targetType:Class, eventTypes:Array/*of String*/, 
													useCapture:Boolean = false, useBubbles:Boolean = true)
		{
			if(targetType == null)
			{
				throw new NullPointerException("Null targetType");
			}
			
			if(eventTypes == null)
			{
				throw new NullPointerException("Null eventTypes");
			}
			
			_targetType = targetType;
			
			_eventTypes = new Dictionary();
			for each(var eventType:String in eventTypes)
			{
				_eventTypes[eventType] = true;
			}
			
			_useCapture = useCapture;
			_useBubbles = useBubbles;
		}
		
		/**
		 * 
		 */		
		public function get targetType():Class
		{
			return _targetType;
		}
		
		/**
		 * 是否在捕获阶段
		 */		
		public function get useCapture():Boolean
		{
			return _useCapture;
		}
		
		/**
		 * 是否在冒泡阶段
		 */		
		public function get useBubbles():Boolean
		{
			return _useBubbles;
		}
		
		/**
		 * 指定的事件是否在关注事件中
		 * 
		 * @param eventType
		 * 
		 * @return 
		 */		
		public function hasEventType(eventType:String):Boolean
		{
			return eventType in _eventTypes;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_targetType = null;
			
			DestroyUtil.breakMap(_eventTypes);
			_eventTypes = null;
		}

	}
}