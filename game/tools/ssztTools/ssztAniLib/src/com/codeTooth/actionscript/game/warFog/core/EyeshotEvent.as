package com.codeTooth.actionscript.game.warFog.core
{
	import flash.events.Event;
	
	/**
	 * 迷雾视野事件
	 */	
	public class EyeshotEvent extends Event
	{
		/**
		 * 视野移动
		 */		
		public static const EYESHOT_MOVE:String = "eyeshotMove";
		
		/**
		 * 视野范围变化
		 */		
		public static const EYESHOT_RADIUS_CHANGED:String = "eyeshotRadiusChanged";
		
		public function EyeshotEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new EyeshotEvent(type, bubbles, cancelable);
		}
	}
}