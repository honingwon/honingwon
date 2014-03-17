package sszt.core.data.im
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatInfo;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.player.BasePlayerInfo;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.FlashIcon;
	import sszt.events.FriendModuleEvent;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.module.ModuleEventDispatcher;
	
	public class ImPlayerInfo extends EventDispatcher
	{
		/**
		 *在线与否,0下线，1在线 
		 */		
		public var online:int;
		/**
		 *玩家基本信息 
		 */		
		public var info:BasePlayerInfo;	
		/**
		 *类型，好友状态
		 */		
		public var friendState:int;
		/**
		 *好友职业 
		 */
		public var career:int;
		
		/**
		 * 好友度 
		 */		
		public var amity:int;
		
//		public var level:int
		
		private var _isEnemy:Boolean;
		private var _isFriend:Boolean;
		private var _isBlack:Boolean;
		/**
		 *分组 
		 */		
		public var group:Number;
		/**
		 *聊天信息 
		 */		
//		public var records:Vector.<ImMessage>;
		public var records:Array;
		/**
		 *备注 
		 */		
		public var remark:String;
		
		public var isMarried:Boolean;
		
		public function ImPlayerInfo()
		{
			info = new BasePlayerInfo();
//			records = new Vector.<ImMessage>();
			records = [];
		}
		
		public function parseData(data:IPackageIn):void
		{
			info.userId = data.readNumber();
//			info.serverId = data.readShort();
			info.nick = data.readUTF();
			info.sex = data.readBoolean();
			career = data.readByte();
			info.level = data.readShort();
			friendState = data.readInt();
			_isFriend = Boolean(friendState & (1 << 14));
			_isBlack = Boolean(friendState & (1 << 13));
			_isEnemy = Boolean(friendState & (1 << 12));
			online = data.readInt();
			group = data.readNumber();
			amity = data.readInt();
		}
		
		public function setState():void
		{
			_isFriend = Boolean(friendState & (1 << 14));
			_isBlack = Boolean(friendState & (1 << 13));
			_isEnemy = Boolean(friendState & (1 << 12));
		}
			
		public function get isFriend():Boolean
		{
			return _isFriend;
		}
				
		public function get isBlack():Boolean
		{
			return _isBlack;
		}
				
		public function get isEnemy():Boolean
		{
			return _isEnemy;
		}
		
		public function addChatItem(item:ImMessage):void
		{
			dispatchEvent(new FriendEvent(FriendEvent.NEW_RECENT,info.userId));
			if(isBlack && !item.isSelf) return;
			records.push(item);
			if(!item.isSelf)
			{
				ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:info.serverId,id:info.userId,flag:0})); 
			}
			dispatchEvent(new FriendEvent(FriendEvent.CHATINFO_UPDATE,item));	
		}
		
		public function setRead():void
		{
			if(records.length > 0)	records[records.length - 1].type = ImMessage.READ; 
			dispatchEvent(new FriendEvent(FriendEvent.SET_READ));
		}
		
		public function get isRead():Boolean
		{
			if(records.length > 0 && records[records.length -1].type == ImMessage.UNREAD_TWO)
			{
				return false;
			}
			return true;
		}
		
		public function changeState(flag:Boolean):void
		{
			if(flag)
			{
				online = 1;
			}else
			{
				online = 0;
			}	 
			dispatchEvent(new FriendEvent(FriendEvent.ONLINE_CHANGE,flag));
		}
	}
}