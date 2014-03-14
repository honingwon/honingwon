package com.codeTooth.actionscript.interaction.mouse.core
{
	import flash.events.MouseEvent;
	
	/**
	 * 鼠标目标对象
	 */
	 
	public interface IMouseTarget
	{
		/**
		 * 触发动作时调用的函数
		 * 
		 * @param 触发的事件的类型
		 */		
		function mouseTargetExecute(event:MouseEvent):void;
	}
}