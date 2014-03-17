package sszt.interfaces.moviewrapper
{
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public interface IRemanceParam
	{
		function setMatrix(value:Matrix):void;
		/**
		 * 设置scale
		 * 
		 */		
		function setScaleX(n:Number):void;
		function setScaleY(n:Number):void;
		function setScaleXY(x:Number,y:Number):void;
		/**
		 * 设置颜色和透明度
		 * 
		 */	
		function setAlpha(n:Number):void;
		function setColorTransform(value:ColorTransform):void;
		/**
		 * 设置九宫
		 * @param value
		 * 
		 */		
		function set scale9Grid(value:Rectangle):void;
		function get scale9Grid():Rectangle;
		function get width():Number;
		function get height():Number;
		function dispose():void;
	}
}