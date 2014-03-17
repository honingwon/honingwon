package sszt.interfaces.scene
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public interface IViewPort extends IEventDispatcher
	{
		/**
		 * 视窗矩形
		 * @return 
		 * 
		 */		
		function get viewRect():Rectangle;
		function set viewRect(rect:Rectangle):void;
		/**
		 * 最大可视矩形
		 * @return 
		 * 
		 */		
		function get maxRect():Rectangle;
		function set maxRect(rect:Rectangle):void;
		/**
		 * 移动范围，出一这个范围就要开始移动视窗了
		 * @return 
		 * 
		 */		
		function get movableRect():Rectangle;
		function set movableRect(rect:Rectangle):void;
		/**
		 * 焦点
		 * @return 
		 * 
		 */		
		function get focusPoint():Point;
		function set focusPoint(value:Point):void;
		/**
		 * 获取指定层容器
		 * @param layer
		 * @return 
		 * 
		 */		
		function getLayerContainer(layer:uint):Sprite;
	}
}