package sszt.interfaces.scene
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import sszt.interfaces.dispose.IDispose;
	
	public interface ISceneObj extends IEventDispatcher,IDispose
	{
		/**
		 * 在场景中的坐标
		 * @return 
		 * 
		 */		
		function get sceneX():Number;
		function get sceneY():Number;
		function setScenePos(x:Number,y:Number):void;
		/**
		 * 场景中的方向
		 * @return 
		 * 
		 */		
		function get dir():int;
		
		function getFigure():DisplayObject;
		
		function get scene():IScene;
		function set scene(s:IScene):void;
		
		function isMouseOver():Boolean;
		function doMouseOver():void;
		function doMouseOut():void;
		function doMouseClick():void;
		function setMouseAvoid(value:Boolean):void;
	}
}
