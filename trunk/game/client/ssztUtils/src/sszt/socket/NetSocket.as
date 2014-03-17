package sszt.socket
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.interfaces.socket.ISocketInfo;
	
	public class NetSocket 
	{
		
		private var _reconnectTimer:Timer;
		private var _hasConnect:Boolean;
		private var _socket:Socket;
		private var _bgpIp:String;
		private var _info:ISocketInfo;
		private var _readBuffer:ByteArray;
		private var _writeOffset:int;
		private var _currentTime:int;
		private var _readOffset:int;
		private var _bgpPort:int;
		private var _shouldConnect:Boolean = true;
		private var _socketManager:SocketManager;
		private var _changingConnect:Boolean;
		private var _plat:int;
		
		public function NetSocket(socketManager:SocketManager, bgpIp:String="", bgpPort:int=0,plat:int=0)
		{
			_bgpIp = bgpIp;
			_bgpPort = bgpPort;
			_plat = plat;
			_socketManager = socketManager;
			_readBuffer = new ByteArray();
			_socket = new Socket();
			_changingConnect = false;
			initEvent();
		}
		private function handleIoError(evt:IOErrorEvent):void
		{
			var evt:IOErrorEvent = evt;
			if (evt){
				trace(evt.text);
			};
			if (_socket){
				try {
					_socket.close();
				} catch(e:Error) {
				};
			};
			if (_hasConnect){
				_socketManager.handleConnectFail();
			};
		}
		public function isSameSocket(info:ISocketInfo):Boolean
		{
			if (!(_info)){
				return (false);
			};
			return ((((((((_info.ip == info.ip)) && ((_info.port == info.port)))) && (_socket))) && (_socket.connected)));
		}
		private function handleSecuityError(evt:SecurityErrorEvent):void
		{
			var evt:SecurityErrorEvent = evt;
			if (evt){
				trace(evt.text);
			};
			if (_socket){
				try {
					_socket.close();
				} catch(e:Error) {
				};
			};
			if (_hasConnect){
				_socketManager.handleSecuityError();
			};
		}
		public function send(pkg:IPackageOut):Boolean
		{
			var i:int;
			if (_socket == null || !_socket.connected)
			{
				return (false);
			}
			if (CommonConfig.ISDEBUG){
				trace(ByteUtils.ToHexDump( "Send:" + _info.ip + ":" + _info.port + " proto :" + pkg.code + "--" + getTimer()  , pkg as ByteArray, 0, pkg.length));
			}
			if (CommonConfig.protocolSeer > -1){
				i = 0;
				while (i < pkg.length) {
					pkg[i] = (pkg[i] ^ CommonConfig.protocolSeer);
					i++;
				}
			}
			_socket.writeBytes((pkg as ByteArray), 0, pkg.length);
			_socket.flush();
			return (true);
		}
		private function reconnectTimerHandler(evt:TimerEvent):void
		{
			var evt:TimerEvent = evt;
			if (!(_shouldConnect)){
				return;
			};
			_currentTime++;
			if (_currentTime >= 3 && !_bgpIp == "")
			{
				_info.ip = _bgpIp;
				_info.port = _bgpPort;
			}
			if (_socket && !_socket.connected)
			{
				try {
					_socket.close();
				} catch(e:Error) {
				}
				_socket.connect(_info.ip, _info.port);
			}
		}
		private function readPackage():void
		{
			var lenbyte:ByteArray;
			var len:int;
			var buff:PackageIn;
			var dataLeft:int = (_writeOffset - _readOffset);
			if (dataLeft < CommonConfig.PACKAGE_HEAD_SIZE){
				return;
			}
			do  {
				lenbyte = new ByteArray();
				lenbyte.writeBytes(_readBuffer, _readOffset, 2);
				if (CommonConfig.protocolSeer > -1){
					lenbyte[0] = (lenbyte[0] ^ CommonConfig.protocolSeer);
					lenbyte[1] = (lenbyte[1] ^ CommonConfig.protocolSeer);
				}
				lenbyte.position = 0;
				len = (lenbyte.readUnsignedShort() + 2);
				_readBuffer.position = _readOffset;
				if (dataLeft >= len){
					buff = new PackageIn(_readBuffer, len);
					_readOffset = (_readOffset + len);
					dataLeft = (_writeOffset - _readOffset);
					if (CommonConfig.ISDEBUG){
						trace(ByteUtils.ToHexDump("Receive Pkg:" + _info.ip + ":" + _info.port + " proto "+ buff.code + "--" + getTimer(), buff, 0, buff.length));
					}
					_socketManager.handlePackage(buff);
				} 
				else {
					break;
				}
			} while (dataLeft > 1);
			_readBuffer.position = 0;
			if (dataLeft > 0){
				_readBuffer.writeBytes(_readBuffer, _readOffset, dataLeft);
			}
			_readOffset = 0;
			_writeOffset = dataLeft;
		}
		public function dispose():void
		{
			removeEvent();
			if (_socket){
				if (_socket.connected){
					_socket.close();
				}
			}
			_socket = null;
		}
		public function isConnect():Boolean
		{
			return (((_socket) && (_socket.connected)));
		}
		private function handleIncoming(evt:ProgressEvent):void
		{
			var len:int;
			if (_socket.bytesAvailable > 0){
				len = _socket.bytesAvailable;
				_socket.readBytes(_readBuffer, _writeOffset, _socket.bytesAvailable);
				_writeOffset = (_writeOffset + len);
				if (_writeOffset > 0){
					_readBuffer.position = 0;
					readPackage();
				};
			};
		}
		private function initEvent():void
		{
			_socket.addEventListener(Event.CONNECT, handleConnect);
			_socket.addEventListener(Event.CLOSE, handleClose);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, handleIncoming);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, handleIoError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecuityError);
		}
		private function handleClose(evt:Event):void
		{
			if (!_changingConnect && _hasConnect)
			{
				_socketManager.handleClose();
			};
			_changingConnect = false;
		}
		public function connect(info:ISocketInfo):void
		{
			var info:ISocketInfo = info;
			try {
				if (isSameSocket(info)){
					handleConnect(null);
					return;
				};
				_info = info;
				if (_socket){
					if (_socket.connected){
						_changingConnect = true;
						_socket.close();
					};
				};
				_readBuffer.position = 0;
				_readOffset = 0;
				_writeOffset = 0;
				_socket.connect(_info.ip, _info.port);
				if (((!((_bgpIp == ""))) && (((!((_bgpIp == _info.ip))) || (!((_bgpPort == _info.port))))))){
					_reconnectTimer = new Timer(4000, 3);
					_reconnectTimer.addEventListener(TimerEvent.TIMER, reconnectTimerHandler);
					_reconnectTimer.start();
				};
			} catch(err:Error) {
				trace(err.message);
			};
		}
		private function handleConnect(evt:Event):void
		{
			if(_plat == 1)
			{
				setPrepareHTTPHead();
			}
			
			_hasConnect = true;
			_changingConnect = false;
			_shouldConnect = false;
			if (_reconnectTimer){
				_reconnectTimer.removeEventListener(TimerEvent.TIMER, reconnectTimerHandler);
				_reconnectTimer.stop();
				_reconnectTimer = null;
			};
			_socketManager.handleConnect();
		}
		private function removeEvent():void
		{
			_socket.removeEventListener(Event.CONNECT, handleConnect);
			_socket.removeEventListener(Event.CLOSE, handleClose);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, handleIncoming);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, handleIoError);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecuityError);
		}
		public function close():void
		{
			if (_socket){
				_socket.close();
			};
		}
		
		private function setPrepareHTTPHead():void
		{
			var out:ByteArray = new ByteArray();
			var str:String = "tgw_l7_forward\r\nHost: "+_info.ip+":"+_info.port.toString()+"\r\n\r\n";
			out.writeMultiByte(str,"GBK");
			_socket.writeBytes(out,0,out.length);
			_socket.flush();
		}
		
	}
}