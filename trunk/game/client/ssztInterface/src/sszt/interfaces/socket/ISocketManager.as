package sszt.interfaces.socket
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	public interface ISocketManager extends IEventDispatcher
	{
		/**
		 * 断开连接
		 * 
		 */		
		function disConnect():void;
		/**
		 * 关闭连接
		 * 
		 */		
		function close():void;
		/**
		 * 检测是否是当前服务器
		 * @param info
		 * @return 
		 * 
		 */		
		function isSameSocket(info:ISocketInfo):Boolean;
		/**
		 * 设置连接
		 * @param info
		 * @param successHandler
		 * @param errorHandler
		 * 
		 */		
		function setSocket(info:ISocketInfo,successHandler:Function = null,errorHandler:Function = null):void;
		/**
		 * 添加包处理方法
		 * @param handler
		 * 
		 */		
		function addSocketHandler(handler:ISocketHandler):void;
		/**
		 * 删除包处理方法
		 * @param code
		 * 
		 */		
		function removeSocketHandler(code:int):void;
		/**
		 * 处理协议
		 * @param pkg
		 * 
		 */	
		function handlePackage(pkg:IPackageIn):void;
		/**
		 * 返回一个发送包
		 * @return 
		 * 
		 */		
		function getPackageOut(code:int):IPackageOut;
		/**
		 * 返回一个接收包
		 * @param src
		 * @param len
		 * @param autoDecode 是否自动解密
		 * @return 
		 * 
		 */		
		function getPackageIn(src:ByteArray,len:int,autoDecode:Boolean = true):IPackageIn;
		/**
		 * 发送包
		 * @param pkg
		 * @return 
		 * 
		 */		
		function send(pkg:IPackageOut):Boolean;
		/**
		 * 是否连接
		 * @return 
		 * 
		 */		
		function isConnect():Boolean;
	}
}
