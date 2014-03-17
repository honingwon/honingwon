package sszt.interfaces.moviewrapper
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	import sszt.interfaces.display.IDisplayObject;
	
	public interface IMovieWrapper extends IDisplayObject
	{
		/**
		 * 播放动画
		 * @param updateImmediately 马上显示到屏幕
		 * @param stopAt 只会停止一次
		 */		
		function play(updateImmediately:Boolean = false,stopAt:int = -1):void;
		/**
		 * 停止
		 * 
		 */		
		function stop():void;
		/**
		 * 停止并从屏幕上清除
		 * 
		 */		
		function stopAndClear():void;
		/**
		 * 从屏幕上清除
		 * 
		 */	
		function clear():void;
		/**
		 * 从第frame帧开始播放
		 * @param frame
		 * @param updateImmediately 马上显示到屏幕
		 * 
		 */		
		function gotoAndPlay(frame:int,updateImmediately:Boolean = false):void;
		/**
		 * 跳转到frame 帧并停止
		 * @param frame
		 * 
		 */		
		function gotoAndStop(frame:int):void;
		/**
		 * 
		 * 设置和返回当前帧
		 * 
		 */		
		function get currentFrame():int;
		function set currentFrame(value:int):void;
		function get totalFrame():int;
		/**
		 * 添加帧代码
		 * @param frame
		 * @param script
		 * 
		 */		
		function addFrameScript(frame:int,script:Function):void;
		/**
		 * 设置和获取帧间隔时间
		 * 
		 */		
		function get tick():int;
		function set tick(value:int):void;
		function move(x:Number,y:Number):void;
	}
}