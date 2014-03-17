package
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class SocketProxy
	{
		public static var socket:Socket;
		private static var _readBuffer:ByteArray = new ByteArray();
		private static var _readOffset:int;
		private static var _writeOffset:int;
		private static var _user:String;
		private static var _site:String;
		private static var _serverid:int;
		private static var _tick:String;
		private static var _sign:String;
		private static var _cm:String;
		
		private static var _is_yellow_vip:int;
		private static var _is_yellow_year_vip:int;
		private static var _yellow_vip_level:int;
		private static var _is_yellow_high_vip:int;
		
		private static var _isguest:Boolean;
		private static var _loginIp:String;
		private static var _loginPort:int;
		private static var _backupIp:String;
		private static var _backupPort:int;
		
		public static var roleList:ByteArray;
		private static var _getRolesCallback:Function;
		private static var _createRolesCallback:Function;
		private static var _guestLoginCallback:Function;
		private static var _alert:RoleAlert;
		private static var _parent:DisplayObjectContainer;
		private static var _connectTimer:Timer;
		private static var _doStat:Function;
		private static var _officalPath:String;
		private static var _reconnectCount:int;
		private static var _timer:Timer;
		private static var _useBgp:Boolean = false;
		//连上再断开的不需要重连
		private static var _shouldReconnect:Boolean = true;
		private static var _serverId:int;
		
		private static var _plat:int;
		
		private static var _index:int=0;
		private static var _key:int = 0;
		
		public static function setup(plat:int,ip:String,port:int,user:String,site:String,serverid:int,tick:String,sign:String,cm:String,isguest:Boolean,
									 is_yellow_vip:int,is_yellow_year_vip:int,yellow_vip_level:int,is_yellow_high_vip:int,
									alert:RoleAlert,parent:DisplayObjectContainer,officalPath:String,doStat:Function = null,backupIp:String = "",backupPort:int = 0,serverId:int = 0):void
		{
			_plat = plat;
			_key = int(Math.random() * 255);
			_user = user;
			_site = site;
			_serverid = serverid;
			_tick = tick;
			_sign = sign;
			_cm = cm;
			_isguest = isguest;
			
			_is_yellow_vip = is_yellow_vip;
			_is_yellow_year_vip = is_yellow_year_vip;
			_yellow_vip_level = yellow_vip_level;
			_is_yellow_high_vip = is_yellow_high_vip;
			
			_alert = alert;
			_parent = parent;
			_officalPath = officalPath;
			_doStat = doStat;
			_loginIp = ip;
			_loginPort = port;
			_serverId = serverId;
			if(backupIp == null)_backupIp = "";
			else _backupIp = backupIp;
			_backupPort = backupPort;
			socket = new Socket();
			socket.addEventListener(Event.CONNECT,socketConnectHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			socket.addEventListener(Event.CLOSE,closeHandler);
			socket.connect(ip,port);
			if(_backupIp != "")
			{
				_connectTimer = new Timer(4000,3);
				_connectTimer.addEventListener(TimerEvent.TIMER,reconnectTimerHandler);
				_connectTimer.start();
			}
		}
		
		private static function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace(evt.text);
//			_alert.show("登陆服务器失败，请重新登陆",_parent,_officalPath);
			if(_doStat != null)
			{
				_doStat(1);
			}
		}
		private static function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace(evt.text);
//			_alert.show("登陆服务器失败，请重新登陆",_parent,_officalPath);
			if(_doStat != null)
			{
				_doStat(2);
			}
		}
		private static function reconnectTimerHandler(evt:TimerEvent):void
		{
			if(!_shouldReconnect)return;
			var ip:String;
			var port:int;
			_reconnectCount++;
			if(_reconnectCount >= 3 && _backupIp != "")
			{
				ip = _backupIp;
				port = _backupPort;
				_useBgp = true;
			}
			else
			{
				ip = _loginIp;
				port = _loginPort;
			}
			if(socket)
			{
				if(!socket.connected)
				{
					try
					{
						socket.close();
					}
					catch(e:Error){}
					socket.connect(ip,port);
				}
			}
		}
		
		private static function closeHandler(evt:Event):void
		{
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.stop();
			}
		}
		
		private static function socketConnectHandler(evt:Event):void
		{
			if(_plat == 1)
			{
				setPrepareHTTPHead();
			}
			_shouldReconnect = false;
			if(_connectTimer)
			{
				_connectTimer.removeEventListener(TimerEvent.TIMER,reconnectTimerHandler);
				_connectTimer.stop();
				_connectTimer = null;
			}
			if(!_isguest)
				sendLogin();
			else
				createGuest();
			
			_timer = new Timer(30000);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.start();
		}
		private static function socketDataHandler(evt:ProgressEvent):void
		{
			if(socket.bytesAvailable > 0)
			{
				var len:int = socket.bytesAvailable;
				socket.readBytes(_readBuffer,_writeOffset,socket.bytesAvailable);
				_writeOffset += len;
				if(_writeOffset > 0)
				{
					_readBuffer.position = 0;
					readPackage();
				}
			}
		}
		
		//只要有数据就写入缓存，缓存中够一条协议的长度时才会被读出
		private static function readPackage():void
		{
			//已写入缓存的长度和已读出的长度差()
			var dataLeft:int = _writeOffset - _readOffset;
			if( dataLeft < 5)
			{
				return;
			}
			do
			{
				//读出2位长度
				var lenbyte:ByteArray = new ByteArray();
				lenbyte.writeBytes(_readBuffer,_readOffset,2);
				lenbyte.position = 0;
				//erlang内置长度,少二个字节
				//				var len:int = lenbyte.readUnsignedShort();
				var len:int = lenbyte.readUnsignedShort() + 2;
				//重设位置
				_readBuffer.position = _readOffset;
				//有协议完整才读出
				if(dataLeft >= len)
				{
					//生成一条完整的协议
					var buff:ByteArray = getIn(_readBuffer,len);
					_readOffset += len;
					dataLeft = _writeOffset - _readOffset;
					handleSocket(buff);
				}
				else
				{
					break;
				}
			}
			while(dataLeft > 1);	
			//剩下不到一条协议，先写入缓存，再有数据进入继续拼接
			_readBuffer.position = 0;
			if(dataLeft > 0)
			{
				_readBuffer.writeBytes(_readBuffer,_readOffset,dataLeft);
			}
			_readOffset = 0;
			_writeOffset = dataLeft;
		}
		
		private static function getOut(pro:int):ByteArray
		{
			var out:ByteArray = new ByteArray();
			out.writeShort(0);
			out.writeByte(0);
			out.writeByte(_index^_key);
			out.writeShort(pro);
			_index++;
			return out;
		}
		
		private static function getOut1(pro:int):ByteArray
		{
			var out:ByteArray = new ByteArray();
			out.writeShort(0);
			out.writeByte(0);
			out.writeByte(_index);
			out.writeShort(pro);
			_index++;
			return out;
		}
		
		
		private static function getIn(src:ByteArray,len:int):ByteArray
		{
			var iin:ByteArray = new ByteArray();
			src.readBytes(iin,0,len);
			iin.readShort();
			iin.readBoolean();
			return iin;
		}
		
		private static function send(out:ByteArray):void
		{
			var t:ByteArray = new ByteArray();
			t.writeShort(out.length - 2);
			out[0] = t[0];
			out[1] = t[1];
			socket.writeBytes(out,0,out.length);
			socket.flush();
		}
		
		public static function sendLogin():void
		{
			var out:ByteArray = getOut1(10001);
			out.writeInt(_key);
			out.writeUTF(_user ? _user : "");
			out.writeUTF(_site ? _site : "");
			out.writeShort(_serverid);
			out.writeUTF(_tick ? _tick : "");
			out.writeUTF(_sign ? _sign : "");
//			out.writeUTF(_cm ? _cm : "");
//			out.writeByte(_is_yellow_vip);
//			out.writeByte(_is_yellow_year_vip);
			
//			out.writeByte(_yellow_vip_level);
//			out.writeByte(_is_yellow_high_vip);
			send(out);
		}
		
		private static function setPrepareHTTPHead():void
		{
			var out:ByteArray = new ByteArray();
			var str:String = "tgw_l7_forward\r\nHost: "+_loginIp+":"+_loginPort.toString()+"\r\n\r\n";
			out.writeMultiByte(str,"GBK");
			socket.writeBytes(out,0,out.length);
			socket.flush();
		}
		
		private static function handleSocket(data:ByteArray):void
		{
			var code:int = data.readShort();
			switch(code)
			{
				case 10001:
//					if(data.readBoolean())
//					{
//						_gameIp = data.readUTF();
//						_gamePort = data.readShort();
//					}
//					else
//					{
//						//登陆失败
//					}
					if(!data.readBoolean())
					{
						var t:String = data.readUTF();
						if(t == "服务器人数已满1，请稍后再试。")
						{
							_alert.show("服务器人数已满，请选择其他服务器登陆！",_parent,_officalPath);
						}
						else
						{
							_alert.show(t,_parent);
						}
					}
					break;
				case 10002:
					if(_getRolesCallback != null)
					{
						_getRolesCallback(data,_useBgp);
					}
					else
					{
						roleList = data;
					}
					break;
				case 10004:
					if(_createRolesCallback != null)
					{
						_createRolesCallback(data);
					}
					break;
				case 10010:
					break;
			}
		}
		
		public static function getRoleData(callback:Function):void
		{
			if(roleList)callback(roleList,_useBgp);
			else _getRolesCallback = callback;
		}
		
		public static function createRole(career:int,sex:Boolean,nick:String,callback:Function):void
		{
			_createRolesCallback = callback;
			var out:ByteArray = getOut(10004);
			out.writeInt(career);
			out.writeBoolean(sex);
//			out.writeInt(_serverId);
			out.writeUTF(nick);
			send(out);
		}
		
		public static function createGuest():void
		{
			var out:ByteArray = getOut(10010);
			out.writeBoolean(true);
			send(out);
		}
		
		public static function guestLogin(id:Number,user:String,guestLoginCallback:Function):void
		{
			_guestLoginCallback = guestLoginCallback;
			var out:ByteArray = getOut(10011);
			out.writeUnsignedInt(int(id / 0xffffffff));
			out.writeUnsignedInt(int(id));
			out.writeUTF(user);
			send(out);
		}
		
		private static function timerHandler(evt:TimerEvent):void
		{
			if(socket && socket.connected)
			{
				var out:ByteArray = getOut(10006);
				out.writeBoolean(true);
				send(out);
			}
		}
		
		public static function close():void
		{
			if(socket && socket.connected)
				socket.close();
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.stop();
				_timer = null;
			}
				
		}
	}
}