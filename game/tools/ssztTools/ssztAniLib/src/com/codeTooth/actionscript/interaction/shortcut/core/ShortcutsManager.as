package com.codeTooth.actionscript.interaction.shortcut.core
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	/**
	 * 快捷键管理器
	 * 
	 * @example
	 * <pre>
	 * <listing>
	 * var shortcutsManager:ShortcutsManager = new ShortcutsManager();
	 * shortcutsManager.container = stage;
	 * 
	 * shortcutsManager.addShortcut(new Shortcut(Keyboard.A, [], true, false, true, false));
	 * 
	 * function shortcutExecute():void
	 * {
	 * 	trace("trace shortcut ctrl + a when key press");
	 * }
	 * </listing>
	 * </pre>
	 */	
	
	public class ShortcutsManager implements IDestroy
	{
		public function ShortcutsManager()
		{
			_shortcuts = new Dictionary();
		}
		
		//-------------------------------------------------------------------------------------------
		// 快捷键
		//-------------------------------------------------------------------------------------------
		
		//存储所有的快捷键对象
		private var _shortcuts:Dictionary = null;
		
		/**
		 * 手动重置KeyDown计数器，
		 * 比如在air中弹出系统窗口后，键盘的KeyUp事件将不再触发
		 */		
		public function resetKeyDownTimes():void
		{
			_keyDownTimes = 0
		}
		
		/**
		 * 获得相同keyCode值的所有快捷键
		 * 
		 * @param keyCode 指定的键值
		 * 
		 * @return 返回具有相同键值的所有快捷键
		 */		
		public function shortcutsIteratorByKeyCode(keyCode:uint):IIterator
		{
			return new ArrayIterator(getShortcutsGroup(keyCode));
		}
		
		/**
		 * 获得所有的快捷键
		 * 
		 * @return 
		 */		
		public function shortcutsIterator():IIterator
		{
			var shortcuts:Array = new Array();
			for each(var shortcutsGroup:Array in _shortcuts)
			{
				shortcuts = shortcuts.concat(shortcutsGroup);
			}
			
			return new ArrayIterator(shortcuts);
		}
		
		/**
		 * 添加一个快捷键
		 * 
		 * @param shortcut
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 */		
		public function addShortcut(shortcut:IShortcut):void
		{
			if(shortcut == null)
			{
				throw new NullPointerException("Null shortcut");
			}
			
			var shortcutsGroup:Array = getShortcutsGroup(shortcut.keyCode);
			shortcutsGroup.push(shortcut);
		}
		
		/**
		 * 移除一个快捷键
		 * 
		 * @param shortcut
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有指定快捷键
		 */		
		public function removeShortcut(shortcut:IShortcut):void
		{
			if(shortcut == null)
			{
				throw new NullPointerException("Null shortcut");
			}
			
			//没有keyCode的快捷键组
			if(_shortcuts[shortcut.keyCode] == undefined)
			{
				throw new NoSuchObjectException("Has not the shortcut");
			}
			else
			{
				var shortcutsGroup:Array = getShortcutsGroup(shortcut.keyCode);
				var numberShortcuts:int = shortcutsGroup.length;
				var hasTheShortcut:Boolean = false;
				
				for(var i:int = 0; i < numberShortcuts; i++)
				{
					if(shortcutsGroup[i] == shortcut)
					{
						hasTheShortcut = true;
						shortcutsGroup.splice(i, 1);
						
						//如果keyCode快捷键组中没有快捷键，删除该组
						if(shortcutsGroup.length == 0)
						{
							delete _shortcuts[shortcut.keyCode];
						}
						
						break;
					}
				}
				
				//如果没有找到抛出异常
				if(!hasTheShortcut)
				{
					throw new NoSuchObjectException("Has not the shortcut");
				}
			}
		}
		
		/**
		 * 判断是否有指定的快捷键
		 * 
		 * @param shortcut 
		 * 
		 * @return 
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 */		
		public function hasShortcut(shortcut:IShortcut):Boolean
		{
			if(shortcut == null)
			{
				throw new NullPointerException("Null shortcut");
			}
			
			//没有keyCode的快捷键组
			if(_shortcuts[shortcut.keyCode] == undefined)
			{
				return false;
			}
			else
			{
				var shortcutsGroup:Array = getShortcutsGroup(shortcut.keyCode);
				var numberShortcuts:int = shortcutsGroup.length;
				var hasTheShortcut:Boolean = false;
				
				for(var i:int = 0; i < numberShortcuts; i++)
				{
					if(shortcutsGroup[i] == shortcut)
					{
						hasTheShortcut = true;
						break;
					}
				}
				
				return hasTheShortcut;
			}
		}
		
		/**
		 * 开启被屏蔽的快捷键
		 */		
		public function openShortcuts():void
		{			
			checkContainer();
			closeShortcuts();
			addContainerListeners();
		}
		
		/**
		 * 屏蔽所有的快捷键
		 */		
		public function closeShortcuts():void
		{
			checkContainer();
			removeContainerListeners();
		}
		
		//获得keyCode快捷键所在的组
		//相同keyCode的快捷键将被存储在一个组中
		private function getShortcutsGroup(keyCode:uint):Array
		{
			//如果没有指定的keyCode快捷键组新创建一个
			if(_shortcuts[keyCode] != undefined)
			{
				return _shortcuts[keyCode] as Array;
			}
			//否则返回一个新keyCode组
			else
			{
				var shortcutsGroup:Array = new Array();
				_shortcuts[keyCode] = shortcutsGroup;
				
				return shortcutsGroup;
			}
		}
		
		//-------------------------------------------------------------------------------------------
		// 容器
		//-------------------------------------------------------------------------------------------
		
		//事件侦听的容器
		private var _container:DisplayObjectContainer = null;
		
		/**
		 * 事件侦听的容器
		 */		
		public function set container(container:DisplayObjectContainer):void
		{
			_container = container;
			checkContainer();
			addContainerListeners();
		}
		
		/**
		 * @private
		 */		
		public function get container():DisplayObjectContainer
		{
			checkContainer();
			
			return _container;
		}
		
		/**
		 * 判断是否设定了容器
		 * 
		 * @return 
		 */		
		public function hasContainer():Boolean
		{
			return _container != null;
		}
		
		//检查是否设定了容器
		private function checkContainer():void
		{
			if(_container == null)
			{
				throw new NullPointerException("Null container");
			}
		}
		
		//-------------------------------------------------------------------------------------------
		// 快捷键侦听
		//-------------------------------------------------------------------------------------------
		
		// BUG 弹出系统窗口后，容器接受不到KeyUp事件，计数器不能复位
		//键按下的计数器，防止重复触发键按下事件
		private var _keyDownTimes:int = 0;
		
		//添加容器侦听
		private function addContainerListeners():void
		{
			_container.addEventListener(KeyboardEvent.KEY_UP, containerKeyUpHandler);
			_container.addEventListener(KeyboardEvent.KEY_DOWN, containerKeyDownHandler);
		}
		
		//移除容器侦听
		private function removeContainerListeners():void
		{
			_container.removeEventListener(KeyboardEvent.KEY_UP, containerKeyUpHandler);
			_container.removeEventListener(KeyboardEvent.KEY_DOWN, containerKeyDownHandler);
		}
		
		//释放键
		private function containerKeyUpHandler(event:KeyboardEvent):void
		{	
			if(event.keyCode == Keyboard.CONTROL || event.keyCode == Keyboard.SHIFT)
			{
				return;
			}
			
			//计数器复位
			_keyDownTimes = 0;
			shortcutExecute(false, event);
		}
		
		//按下键
		private function containerKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.CONTROL || event.keyCode == Keyboard.SHIFT)
			{
				return;
			}
			
			//只触发一次
			if(_keyDownTimes == 0)
			{
				_keyDownTimes++;
				shortcutExecute(true, event);
			}
		}
		
		private function shortcutExecute(inKeyDownPhase:Boolean, event:KeyboardEvent):void
		{
			if(_shortcuts[event.keyCode] != undefined)
			{
				var shortcutsGroup:Array = _shortcuts[event.keyCode] as Array;
				
				for each(var shortcut:IShortcut in shortcutsGroup)
				{
					if((inKeyDownPhase ? shortcut.keyDownPhase : shortcut.keyUpPhase) && 
						shortcut.ctrlKey == event.ctrlKey && 
						shortcut.shiftKey == event.shiftKey)
					{
						shortcut.shortcutExecute.apply(null, shortcut.shortcutExecuteParametersList);
					}
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------
		// 实现IDestroy接口
		//-------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			if(_container != null)
			{
				removeContainerListeners();
				_container = null;
			}
			
			for each(var shortcutGroup:Array in _shortcuts)
			{
				DestroyUtil.breakArray(shortcutGroup);
			}
			DestroyUtil.breakMap(_shortcuts);
			_shortcuts = null;
		}
	}
}