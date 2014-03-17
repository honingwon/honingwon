package sszt.core.queue
{
	import sszt.interfaces.tick.ITick;

	public interface IQueue extends ITick
	{
		/**
		 * 是否完成
		 * @return 
		 * 
		 */		
		function get isFinished():Boolean;
		function set isFinished(value:Boolean):void;
		/**
		 * 跳过动作（快速执行，直接完成）
		 * 
		 */		
		function skip():void;
		/**
		 * 更新参数
		 * @param args
		 * 
		 */		
		function configure(...args):void;
		function get hadDoInit():Boolean;
		function init():void;
		/**
		 * 从管理器上清除
		 * 
		 */		
		function managerClear():void;
		function dispose():void;
	}
}