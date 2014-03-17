package sszt.interfaces.pool
{
	import sszt.interfaces.dispose.IDispose;
	
	public interface IPoolObj extends IDispose
	{
		function setManager(manager:IPoolManager):void;
		/**
		 * 重置，manager getObj时调用
		 * @param param
		 * 
		 */		
		function reset(param:Object):void;
		/**
		 * 外部调用回收
		 * 
		 */		
		function collect():void;
		/**
		 * 完全删除
		 * 
		 */		
		function poolDispose():void;
	}
}