package com.codeTooth.actionscript.game.warFog.core
{
	import com.codeTooth.actionscript.lang.utils.uniqueObject.IUniqueObject;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * 迷雾中视野对象实现的接口
	 */	
	public interface IEyeshot extends IEventDispatcher,  IUniqueObject
	{
		/**
		 * 视野的x位置
		 * 
		 * @return 
		 */		
		function eyeshotX():Number;
		
		/**
		 *视野的y位置
		 *  
		 * @return 
		 */		
		function eyeshotY():Number;
		
		/**
		 * 视野半径
		 * 
		 * @return 
		 */		
		function eyeshotRadius():Number;
	}
}