package sszt.interfaces.pool
{
	import sszt.interfaces.dispose.IDispose;

	public interface IPoolApi
	{
		/**
		 * 设置对象
		 * @param cl
		 * @param maxCount
		 * 
		 */		
		function setPool(cl:Class,maxCount:int):void;
		/**
		 * 删除对象设置
		 * @param cl
		 * 
		 */		
		function disposePool(cl:Class):void;
		/**
		 * 获取一个对象
		 * @param cl
		 * @param args
		 * @return 
		 * 
		 */		
		function getInstance(cl:Class,...args):IDispose;
		/**
		 * 回收一个对象
		 * @param cl
		 * @param instance
		 * 
		 */		
		function removeInstance(cl:Class,instance:IDispose):void;
	}
}
