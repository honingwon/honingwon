package sszt.core.action
{
	import sszt.interfaces.tick.ITick;

	public interface IAction extends ITick
	{
		
		/**
		 * 播放动作 
		 * 
		 */		
		function doAction():void;
		
		/**
		 * 是否完成
		 * @return 
		 * 
		 */		
		function get isFinished():Boolean;
		function set isFinished(value:Boolean):void;
		/**
		 * 动作类型
		 * @return 
		 * 
		 */		
		function get type():String;
		/**
		 * 动作级别
		 * @return 
		 * 
		 */		
		function get level():int;
		/**
		 * 是否替换,是执行替换并返回true，否则直接返回false
		 * @param action
		 * @return 
		 * 
		 */		
		function replace(action:IAction):Boolean;
		/**
		 * 是否忽略动作
		 * @param action
		 * @return 
		 * 
		 */		
		function beIgnore(action:IAction):Boolean;
		/**
		 * 删除 
		 * @param manager
		 * 
		 */		
		function doRemove(manager:IActionManager):void;
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
		function setManager(manager:IActionManager):void;
		function get hadDoPlay():Boolean;
		function get canPlay():Boolean;
		function play():void;
		/**
		 * 从管理器上清除
		 * 
		 */		
		function managerClear():void;
		function dispose():void;
	}
}