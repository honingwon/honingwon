package com.codeTooth.actionscript.interaction.shortcut.core
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	
	/**
	 * 快捷键
	 */	
	
	public class Shortcut implements IShortcut
	{
		/**
		 * 构造函数
		 *  
		 * @param keyCode 键的键控代码值
		 * @param shortcutExecute 快捷键执行的函数
		 * @param shortcutExecuteParametersList 快捷键执行函数的参数列表
		 * @param keyDownPhase 是否在按下键时触发
		 * @param keyUpPhase 是否在释放键时触发
		 * @param ctrlKey 是否按下control键
		 * @param shiftKey 是否按下shift键
		 * 
		 */		
		public function Shortcut(keyCode:uint, 
												shortcutExecute:Function, shortcutExecuteParametersList:Array, 
												ctrlKey:Boolean = true, shiftKey:Boolean = false,
												keyDownPhase:Boolean = true, keyUpPhase:Boolean = false)
		{			
			_keyCode = keyCode;
			_ctrlKey = ctrlKey;
			_shiftKey = shiftKey;
			_keyDownPhase = keyDownPhase;
			_keyUpPhase = keyUpPhase;
			this.shortcutExecute = shortcutExecute;
			this.shortcutExecuteParametersList = shortcutExecuteParametersList;
		}
		
		//-------------------------------------------------------------------------------------------
		// 实现IDestroy接口
		//-------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_shortcutExecute = null;
			
			DestroyUtil.breakArray(_shortcutExecuteParametersList);
			_shortcutExecuteParametersList = null;
		}
		
		//-------------------------------------------------------------------------------------------
		// 实现IShortcut接口
		//-------------------------------------------------------------------------------------------
		
		private var _keyCode:uint = 0;
		
		private var _ctrlKey:Boolean = false;
		
		private var _shiftKey:Boolean = false;
		
		private var _keyDownPhase:Boolean = true;
		
		private var _keyUpPhase:Boolean = false;
		
		private var _shortcutExecute:Function = null;
		
		private var _shortcutExecuteParametersList:Array = null;
		
		/**
		 * @inheritDoc
		 */		
		public function set keyCode(keyCode:uint):void
		{
			_keyCode = keyCode;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get keyCode():uint
		{
			return _keyCode;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set ctrlKey(ctrlKey:Boolean):void
		{
			_ctrlKey = ctrlKey;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get ctrlKey():Boolean
		{
			return _ctrlKey;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set shiftKey(shiftKey:Boolean):void
		{
			_shiftKey = shiftKey;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get shiftKey():Boolean
		{
			return _shiftKey;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function set keyDownPhase(bool:Boolean):void
		{
			_keyDownPhase = bool;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function get keyDownPhase():Boolean
		{
			return _keyDownPhase; 
		}
		
		/**
		 * @inheritDoc
		 */	
		public function set keyUpPhase(bool:Boolean):void
		{
			_keyUpPhase = bool;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get keyUpPhase():Boolean
		{
			return _keyUpPhase;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function set shortcutExecute(shortcutExecute:Function):void
		{
			if(shortcutExecute == null)
			{
				throw new NullPointerException("Null shotcutExecute");
			}
			
			_shortcutExecute = shortcutExecute;
		}
			
		/**
		 * @inheritDoc
		 */	
		public function get shortcutExecute():Function
		{
			return _shortcutExecute;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function set shortcutExecuteParametersList(shortcutExecuteParametersList:Array):void
		{
			if(shortcutExecuteParametersList == null)
			{
				throw new NullPointerException("Null shortcutExecuteParametersList");
			}
			
			_shortcutExecuteParametersList = shortcutExecuteParametersList;
		}
		
		/**
		 * @inheritDoc
		 */	
		public function get shortcutExecuteParametersList():Array
		{
			return _shortcutExecuteParametersList;
		}
		
	}
}