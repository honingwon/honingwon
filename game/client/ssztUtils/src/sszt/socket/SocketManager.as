package sszt.socket
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import sszt.events.SocketEvent;
	import sszt.constData.CommonConfig;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.interfaces.socket.ISocketInfo;
	import flash.utils.ByteArray;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.ISocketHandler;
	import sszt.interfaces.socket.*;
	
	public class SocketManager extends EventDispatcher implements ISocketManager 
	{
		
		private var _connectSuccessHandler:Function;
		private var _bgpIp:String = "";
		private var _socket:NetSocket;
		private var _socketHandlers:Dictionary;
		private var _bgpPort:int = 0;
		private var _connectErrorHandler:Function;
		private var _plat:int;
		
		public function SocketManager(bgpIp:String="", bgpPort:int=0,plat:int=0)
		{
			_bgpIp = bgpIp;
			_bgpPort = bgpPort;
			_plat = plat;
			_socketHandlers = new Dictionary();
		}
		public function handleSecuityError():void
		{
			if (_connectErrorHandler != null)
			{
				_connectErrorHandler();
			}
			dispatchEvent(new SocketEvent(SocketEvent.SECURITY_ERROR));
		}
		public function send(pkg:IPackageOut):Boolean
		{
			if (_socket == null){
				return (false);
			}
			if (pkg.length > CommonConfig.PACKAGE_COMRESS_LEN)
			{
				pkg.doCompress();
			}
			pkg.setPackageLen();
			return (_socket.send(pkg));
		}
		public function isSameSocket(info:ISocketInfo):Boolean
		{
			if (!_socket){
				return (false);
			}
			return (_socket.isSameSocket(info));
		}
		public function disConnect():void
		{
			if (_socket)
			{
				_socket.dispose();
				_socket = null;
			}
		}
		public function getPackageIn(src:ByteArray, len:int, autoDecode:Boolean=true):IPackageIn
		{
			return (new PackageIn(src, len, autoDecode));
		}
		public function getPackageOut(code:int):IPackageOut
		{
			return (new PackageOut(code));
		}
		public function isConnect():Boolean
		{
			return _socket && _socket.isConnect();
		}
		public function handleConnect():void
		{
			if (_connectSuccessHandler != null)
			{
				_connectSuccessHandler();
			}
			dispatchEvent(new SocketEvent(SocketEvent.CONNECT_SUCCESS));
		}
		public function handleConnectFail():void
		{
			if (_connectErrorHandler != null){
				_connectErrorHandler();
			}
			dispatchEvent(new SocketEvent(SocketEvent.CONNECT_FAIL));
		}
		public function handleClose():void
		{
			dispatchEvent(new SocketEvent(SocketEvent.SOCKET_CLOSE));
		}
		public function setSocket(info:ISocketInfo, successHandler:Function=null, errorHandler:Function=null):void
		{
			if (_socket == null)
			{
				_socket = new NetSocket(this, _bgpIp, _bgpPort,_plat);
			}
			_connectSuccessHandler = successHandler;
			_connectErrorHandler = errorHandler;
			_socket.connect(info);
		}
		public function close():void
		{
			if (_socket){
				try 
				{
					_socket.close();
				} 
				catch(e:Error) {
				}
			}
		}
		public function removeSocketHandler(code:int):void
		{
			if (_socketHandlers[code] != null){
				_socketHandlers[code].dispose();
				_socketHandlers[code] = null;
				delete _socketHandlers[code];
			}
		}
		public function addSocketHandler(handler:ISocketHandler):void
		{
			if (_socketHandlers[handler.getCode()] == null || _socketHandlers[handler.getCode()] == undefined)
			{
				_socketHandlers[handler.getCode()] = handler;
			}
		}
		public function handlePackage(pkg:IPackageIn):void
		{
			var handler:ISocketHandler = (_socketHandlers[pkg.code] as ISocketHandler);
			if (handler != null)
			{
				pkg.position = CommonConfig.PACKAGE_HEAD_SIZE;
				handler.configure(pkg);
				handler.handlePackage();
			}
			pkg.position = CommonConfig.PACKAGE_HEAD_SIZE;
			dispatchEvent(new SocketEvent(SocketEvent.SOCKET_DATA, pkg));
		}
		
	}
}