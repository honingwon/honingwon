package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class QueryFriendInfoSocketHandler extends BaseSocketHandler
	{
		public function QueryFriendInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.QUERY_FRIEND_INFO;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
//				var serverId:int = _data.readShort();
				var id:Number = _data.readNumber();
				var nick:String = _data.readString();
				var sex:Boolean = _data.readBoolean();
				var level:int = _data.readByte();
				var camp:int = _data.readByte();
				var career:int = _data.readByte();
				var clubName:String = _data.readString();
				GlobalData.imPlayList.queryResult({id:id,nick: nick,sex:sex,level:level,camp:camp,career:career,clubName:clubName});
			}else
			{
				GlobalData.imPlayList.queryResult(null);
			}
			
			handComplete();
		}
		
		public static function sendQuery(serverId:int,nick:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.QUERY_FRIEND_INFO);
//			pkg.writeShort(serverId);
			pkg.writeString(nick);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}