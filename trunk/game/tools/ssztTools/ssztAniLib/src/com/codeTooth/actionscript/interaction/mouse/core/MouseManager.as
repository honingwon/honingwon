package com.codeTooth.actionscript.interaction.mouse.core
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	
	/**
	 * 鼠标点击管理器
	 * 
	 * <pre>
	 * <listing>
	 * var mouseManager:MouseManager = new MouseManager();
	 * mouseManager.container = stage;
	 * 
	 * mouseManager.addEventType(new EventType(MouseEvent.CLICK));
	 * mouseManager.addEventType(new EventType(MouseEvent.MOUSE_UP));
	 * mouseManager.addEventType(new EventType(MouseEvent.MOUSE_DOWN));
	 * 
	 * mosueManager.addMouseTarget(new MouseTarget(BoxA, [MouseEvent.MOUSE_UP, MouseEvent.MOUSE_DOWN]));
	 * 
	 * public class BoxA extends Sprite implements IMouseTarget
	 * {
	 * 	public function mouseTargetExecute(event:MouseEvent):void
	 * 	{
	 * 		if(event.type == MouseEvent.MOUSE_UP)
	 * 		{
	 * 			trace("BoxA MosueUp");
	 * 		}
	 * 		else if(event.type == MouseEvent.MOUSE_DOWN)
	 * 		{
	 * 			trace("BoxA MosueDown");
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * </pre>
	 */	
	
	public class MouseManager implements IDestroy
	{
		public function MouseManager()
		{
			_mouseTargets = new Array();
			
			_eventTypes = new Array();
		}
		
		//-------------------------------------------------------------------------------------------
		// 鼠标目标对象
		//-------------------------------------------------------------------------------------------
		
		//鼠标目标对象集合
		private var _mouseTargets:Array/*of MouseTarget*/ = null;
		
		/**
		 * 获得所有的鼠标对象
		 * 
		 * @return 
		 */		
		public function mouseTargetsIterator():IIterator
		{
			return new ArrayIterator(_mouseTargets);
		}
		
		/**
		 * 添加一个鼠标对象
		 * 
		 * @param mouseTarget
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 */		
		public function addMouseTarget(mouseTarget:MouseTarget):void
		{
			if(mouseTarget == null)
			{
				throw new NullPointerException("Null mouseTarget");
			}
			
			_mouseTargets.push(mouseTarget);
		}
		
		/**
		 * 移除一个鼠标对象
		 * 
		 * @param mouseTarget
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 不存在指定的对象
		 */		
		public function removeMouseTarget(mouseTarget:MouseTarget):void
		{
			var hasTheMouseTarget:Boolean = false;
			var numberMouseTargets:int = _mouseTargets.length;
			for(var i:int = 0; i < numberMouseTargets; i++)
			{
				if(_mouseTargets[i] == mouseTarget)
				{
					_mouseTargets.splice(i, 1);
					hasTheMouseTarget = true;
					break;
				}
			}
			
			if(!hasTheMouseTarget)
			{
				throw new NoSuchObjectException("Has not the mouseTarget");
			}
		}
		
		/**
		 * 判断是否存在指定的鼠标对象
		 * 
		 * @param mouseTarget
		 * 
		 * @return 
		 */		
		public function hasMouseTarget(mouseTarget:MouseTarget):Boolean
		{
			var hasTheMouseTarget:Boolean = false;
			var numberMouseTargets:int = _mouseTargets.length;
			for(var i:int = 0; i < numberMouseTargets; i++)
			{
				if(_mouseTargets[i] == mouseTarget)
				{
					hasTheMouseTarget = true;
					break;
				}
			}
			
			return hasTheMouseTarget;
		}
		
		//-------------------------------------------------------------------------------------------
		// 侦听
		//-------------------------------------------------------------------------------------------
		
		//容器侦听的事件类型
		private var _eventTypes:Array/*of EventType*/ = null;
		
		/**
		 * 获得所有的事件类型
		 * 
		 * @return 
		 */		
		public function eventTypesIterator():IIterator
		{
			return new ArrayIterator(_eventTypes);
		}
		
		/**
		 * 添加事件类型
		 * 
		 * @param eventType
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 */		
		public function addEventType(eventType:EventType):void
		{
			if(eventType == null)
			{
				throw new NullPointerException("Null eventType");
			}
			
			_eventTypes.push(eventType);
			addEventListener(eventType);
		}
		
		/**
		 * 移除一个事件类型
		 * 
		 * @param eventType
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有找到指定的对象
		 */		
		public function removeEventType(eventType:EventType):void
		{
			if(eventType == null)
			{
				throw new NullPointerException("Null eventType");
			}
			
			var numberEventTypes:int = _eventTypes.length;
			var aEventType:EventType = null;
			for(var i:int = 0; i < numberEventTypes; i++)
			{
				if(_eventTypes[i] == eventType)
				{
					aEventType = _eventTypes.splice(i, 1)[0] as EventType;
					break;
				}
			}
			
			if(aEventType != null)
			{
				removeEventListener(aEventType);
			}
			else
			{
				throw new NoSuchObjectException("Has not the eventType");
			}
		}
		
		/**
		 * 判断是否存在指定的事件类型
		 * 
		 * @param eventType
		 * 
		 * @return 
		 * 
		 * @exception com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 */		
		public function hasEventType(eventType:EventType):Boolean
		{
			if(eventType == null)
			{
				throw new NullPointerException("Null eventType");
			}
			
			var hasTheEventType:Boolean = false;
			for each(var aEventType:EventType in _eventTypes)
			{
				if(aEventType == eventType)
				{
					hasTheEventType = true;
					break;
				}
			}
			
			return hasTheEventType;
		}
		
		//添加侦听
		private function addEventListener(eventType:EventType):void
		{
			checkContainer();
			
			//捕获阶段
			if(eventType.useCapture)
			{
				_container.addEventListener(eventType.eventType, listenerHandler, true);
			}
			
			//冒泡阶段
			if(eventType.useBubbles)
			{
				_container.addEventListener(eventType.eventType, listenerHandler, false);
			}
		}
		
		private function removeEventListener(eventType:EventType):void
		{
			checkContainer();
			
			//捕获阶段
			if(eventType.useCapture)
			{
				_container.removeEventListener(eventType.eventType, listenerHandler, true);
			}
			
			//冒泡阶段
			if(eventType.useBubbles)
			{
				_container.removeEventListener(eventType.eventType, listenerHandler, false);
			}
		}
		
		//触发的事件
		private function listenerHandler(event:MouseEvent):void
		{
			eventInvoke(event);
		}
		
		private function eventInvoke(event:MouseEvent):void
		{
			if(_mouseTargets != null)
			{
				var target:IMouseTarget = null;
				//遍历鼠标目标对象
				for each(var mouseTarget:MouseTarget in _mouseTargets)
				{
					//鼠标目标对象关注此事件
					if(mouseTarget.hasEventType(event.type))
					{
						//在捕获阶段侦听或者在冒泡阶段侦听
						if((event.eventPhase == EventPhase.CAPTURING_PHASE && mouseTarget.useCapture) || 
							 (event.eventPhase == EventPhase.BUBBLING_PHASE && mouseTarget.useBubbles))
						{
							//找到鼠标点击的对象
							target = getTarget(event.target, mouseTarget.targetType);
							
							if(target != null)
							{
								target.mouseTargetExecute(event);
							}
						}
					}
				}
			}
		}
		
		//找鼠标点击的对象
		private function getTarget(target:Object, targetType:Class):IMouseTarget
		{
			//从鼠标点击的直接对象开始，向上遍历显示列表，直到容器
			//找到与targetType类型相同的对象时停止查找并返回
			
			while(!(target is IMouseTarget && target is targetType) && target != _container)
			{
				if(target == null)
				{
					break;
				}
				
				target = target.parent;
			}
			
			if(target is IMouseTarget && target is targetType)
			{
				return IMouseTarget(target);
			}
			else
			{
				//没有找到返回null
				return null;
			}
		}
		
		//-------------------------------------------------------------------------------------------
		// 容器
		//-------------------------------------------------------------------------------------------
		
		private var _container:DisplayObjectContainer = null;
		
		/**
		 * 事件侦听容器
		 */		
		public function set container(container:DisplayObjectContainer):void
		{
			destroy();
			
			_container = container;
			checkContainer();
		}
		
		/**
		 * @private
		 */		
		public function get container():DisplayObjectContainer
		{
			if(_container == null)
			{
				throw new NullPointerException("Null container");
			}
			
			return _container;
		}
		
		/**
		 * 判断是否设置了事件侦听容器
		 * 
		 * @return 
		 */		
		public function hasContainer():Boolean
		{
			return _container != null;
		}
		
		private function checkContainer():void
		{
			if(_container == null)
			{
				throw new NullPointerException("Null container");
			}
		}
		
		//-------------------------------------------------------------------------------------------
		// 实现IDestroy接口
		//-------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if(_container != null)
			{
				for each(var eventType:EventType in _eventTypes)
				{
					removeEventListener(eventType);
				}
				
				DestroyUtil.breakArray(_eventTypes);
				_eventTypes = null;
				
				_container = null;
			}
		}
	}
}