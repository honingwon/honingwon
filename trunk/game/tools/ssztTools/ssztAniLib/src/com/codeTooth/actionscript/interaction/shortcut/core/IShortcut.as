package com.codeTooth.actionscript.interaction.shortcut.core
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * 快捷键对象实现的接口
	 */	
	
	public interface IShortcut extends IDestroy
	{
		/**
		 * 键的键控代码值
		 */		
		function set keyCode(keyCode:uint):void;
		
		/**
		 * @private
		 */		 
		function get keyCode():uint;
		
		/**
		 * 是否按下control键
		 */		
		function set ctrlKey(ctrlKey:Boolean):void;
		 
		/**
		 * @private
		 */
		function get ctrlKey():Boolean;
		
		/**
		 * 是否按下shift键
		 */		
		function set shiftKey(shiftKey:Boolean):void;
		 
		/**
		 * @private
		 */
		function get shiftKey():Boolean;
		
		/**
		 * 是否在按下键时触发
		 */		
		function set keyDownPhase(bool:Boolean):void;
		
		/**
		 * @private
		 */		
		function get keyDownPhase():Boolean; 
		
		/**
		 * 是否在释放键时触发
		 */	
		function set keyUpPhase(bool:Boolean):void;
		
		/**
		 * @private
		 */	
		function get keyUpPhase():Boolean;
		
		/**
		 * 设置快捷键执行的函数
		 * 
		 * @throw com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的函数是null
		 */		
		function set shortcutExecute(shortcutExecute:Function):void
		
		/**
		 * @private
		 */		
		function get shortcutExecute():Function;
		
		/**
		 * 设置快捷键执行的函数的参数列表
		 * 
		 * @throw com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的函数参数列表是null
		 */		
		function set shortcutExecuteParametersList(shortcutExecuteParametersList:Array):void;
		
		/**
		 * @private
		 */		
		function get shortcutExecuteParametersList():Array;
	}
}