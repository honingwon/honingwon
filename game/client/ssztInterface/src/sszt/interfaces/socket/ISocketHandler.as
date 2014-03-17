package sszt.interfaces.socket
{
	import flash.events.IEventDispatcher;
	
	import sszt.interfaces.dispose.IDispose;
	
	public interface ISocketHandler extends IEventDispatcher,IDispose
	{
		/**
		 * 获得协议值
		 * @return 
		 * 
		 */		
		function getCode():int;
		/**
		 * 更新协议数据
		 * @param param
		 * 
		 */		
		function configure(param:Object):void;
		/**
		 * 处理协议
		 * 
		 */		
		function handlePackage():void;
	}
}