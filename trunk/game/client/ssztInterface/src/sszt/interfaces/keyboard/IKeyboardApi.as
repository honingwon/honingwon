package sszt.interfaces.keyboard
{
	import flash.events.IEventDispatcher;

	public interface IKeyboardApi
	{
		/**
		 * 数组中是否有键被按下
		 * @param keys
		 * @return 
		 * 
		 */		
		function hasKeyDown(keys:Array):Boolean;
		/**
		 * 按钮是否被按下
		 * @param keyCode
		 * @return 
		 * 
		 */		
		function keyIsDown(keyCode:int):Boolean;
		/**
		 * 获取键盘侦听器（场景）
		 * @return 
		 * 
		 */		
		function getKeyListener():IEventDispatcher;
		function dispose():void;
	}
}
