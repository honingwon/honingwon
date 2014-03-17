package sszt.core.socketHandlers.chat
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.chat.club.ClubChatItemInfo;
	import sszt.core.data.im.ImMessage;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ChatSockethandler extends BaseSocketHandler
	{
		public function ChatSockethandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CHAT;
		}
		
		override public function handlePackage():void
		{
			var info:ChatItemInfo = new ChatItemInfo();
//			info.serverId = _data.readShort();
			info.type = _data.readByte();
			info.vipType = _data.readShort();
			info.fromNick = _data.readString();
			info.fromId = _data.readNumber();
			info.fromSex = _data.readInt();
			info.toNick = _data.readString();
			info.toId = _data.readNumber();
			info.message = _data.readString();
			if(info.type == ChannelType.IM)
			{
				var player:ImPlayerInfo;
				var item:ImMessage = new ImMessage();
				if(info.fromId == GlobalData.selfPlayer.userId)
				{
					player = GlobalData.imPlayList.getPlayer(info.toId);
					if(player == null)
					{
						player = new ImPlayerInfo();
						player.info.serverId = info.serverId;
						player.info.userId = info.fromId;
						player.info.nick = info.fromNick;
						player.info.sex = Boolean(info.fromSex);
						player.online = 1;
						GlobalData.imPlayList.addStranger(player);
					}
					if(!GlobalData.imPlayList.getRecent(info.toId))
					{
						GlobalData.imPlayList.addRecent(player);
					}
					item.isSelf = true ;
				}
				else
				{
					player = GlobalData.imPlayList.getPlayer(info.fromId);
					if(player == null)
					{
						player = new ImPlayerInfo();
						player.info.serverId = info.serverId;
						player.info.userId = info.fromId;
						player.info.nick = info.fromNick;
						player.info.sex = Boolean(info.fromSex);
						player.online = 1;
						GlobalData.imPlayList.addStranger(player);
					}
					if(!GlobalData.imPlayList.getRecent(info.fromId))
					{
						GlobalData.imPlayList.addRecent(player);
					}
					item.isSelf = false;
				}
				item.message = info.message;
				item.time = GlobalData.systemDate.getSystemDate().toLocaleTimeString();
				player.addChatItem(item);
			}
			if(info.type == ChannelType.CURRENT)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_PAOPAO,{id:info.fromId,message:info.message}));
			}
			
			if (info.type == ChannelType.CLUB ){
				var clubChatItem:ClubChatItemInfo = new ClubChatItemInfo();
				clubChatItem.info = info;
				clubChatItem.time = GlobalData.systemDate.getSystemDate().toLocaleTimeString();
				GlobalData.clubChatInfo.addItem(clubChatItem);
			}
			
			GlobalData.chatInfo.appendMessage(info);
			
			handComplete();
		}
		
		public static function sendMessage(channel:int,message:String,toNick:String = "",toId:Number = 0):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CHAT);
			pkg.writeByte(channel);	
			pkg.writeString(GlobalData.selfPlayer.nick);
			pkg.writeNumber(GlobalData.selfPlayer.userId);
			pkg.writeInt(GlobalData.selfPlayer.sex ? 1 : 2);
			pkg.writeString(toNick);
			pkg.writeNumber(toId);
			pkg.writeString(message);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}