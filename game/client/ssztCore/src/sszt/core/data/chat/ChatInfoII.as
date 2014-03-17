package sszt.core.data.chat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class ChatInfoII extends EventDispatcher
	{
		public static var clientId:int = 0;
		/**
		 * 总的聊天记录数
		 */		
		public static const TOTAL_MAX:int = 120;
		/**
		 * 当一频道聊天记录数
		 */		
		public static const CHANNEL_MAX:int = 30;
		
		public var itemList:Array;
		
		public var currentUpdateList:Array;
		public var grouplist:Array;
		public function clearUpdateList():Array{return [];}
		public function getMessageList(channel:int):Array{return [];}
		
		private var _channelCounts:Dictionary;
		private var _currentChannel:int;
		
		public var worldShowList:Dictionary;
		public var cmpShowList:Dictionary;
		public var clubShowList:Dictionary;
		public var groupShowList:Dictionary;
		public var currentShowList:Dictionary;
		public var speakerShowList:Dictionary;
		public var cityShowList:Dictionary;
		
		public function ChatInfoII()
		{
			itemList = [];
			_channelCounts = new Dictionary();
			_channelCounts[ChannelType.WORLD] = 0;
			_channelCounts[ChannelType.CMP] = 0;
			_channelCounts[ChannelType.CLUB] = 0;
			_channelCounts[ChannelType.GROUP] = 0;
			_channelCounts[ChannelType.CURRENT] = 0;
			_channelCounts[ChannelType.SPEAKER] = 0;
			_channelCounts[ChannelType.CITY] = 0;
			_channelCounts[ChannelType.IM] = 0;
			_channelCounts[ChannelType.PRIVATE] = 0;
			
			worldShowList = new Dictionary();
			cmpShowList = new Dictionary();
			clubShowList = new Dictionary();
			groupShowList = new Dictionary();
			currentShowList = new Dictionary();
			speakerShowList = new Dictionary();
			cityShowList = new Dictionary();
			for each(var type:int in MessageType.getAllTypes())
			{
				worldShowList[type] = true;
				cmpShowList[type] = true;
				clubShowList[type] = true;
				groupShowList[type] = true;
				currentShowList[type] = true;
				speakerShowList[type] = true;
				cityShowList[type] = true;
			}
		}
		
		public function appendMessage(info:ChatItemInfo):void
		{
			if(info == null)return;
			if(itemList.indexOf(info) > -1)return;
			info.clientId = ++clientId;
			itemList.push(info);
			var removeItem:ChatItemInfo;
			var requotes:Array = ChannelType.getChannelType(info.type).slice(0);
			for(var c1:int = requotes.length - 1; c1 >= 0; c1--)
			{
				if(requotes[c1] == ChannelType.WORLD && !worldShowList[info.type])
				{
					requotes.splice(c1,1);
				}
				else if(requotes[c1] == ChannelType.CMP && !cmpShowList[info.type])
				{
					requotes.splice(c1,1);
				}
				else if(requotes[c1] == ChannelType.CLUB && !clubShowList[info.type])
				{
					requotes.splice(c1,1);
				}
				else if(requotes[c1] == ChannelType.GROUP && !groupShowList[info.type])
				{
					requotes.splice(c1,1);
				}
				else if(requotes[c1] == ChannelType.CURRENT && !currentShowList[info.type])
				{
					requotes.splice(c1,1);
				}
				else if(requotes[c1] == ChannelType.SPEAKER && !speakerShowList[info.type])
				{
					requotes.splice(c1,1);
				}
				else if(requotes[c1] == ChannelType.CITY && !cityShowList[info.type])
				{
					requotes.splice(c1,1);
				}
			}
			info.requoteChannels = requotes;
//			for each(var channel:int in requotes)
			for(var c:int = requotes.length - 1; c >= 0; c--)
			{
				var channel:int = requotes[c];
				if(_channelCounts[channel] < CHANNEL_MAX)
				{
					_channelCounts[channel]++;
				}
				else
				{
					for(var i:int = 0; i < itemList.length; i++)
					{
						if(ChatItemInfo(itemList[i]).removeARequote(channel))
						{
							if(itemList[i].isNonRequote())
								removeItem = itemList.splice(i,1)[0];
							break;
						}
					}
				}
			}
			if(!removeItem)
			{
				if(itemList.length > TOTAL_MAX)
					removeItem = itemList.shift() as ChatItemInfo;
			}
			dispatchEvent(new ChatInfoUpdateEvent(ChatInfoUpdateEvent.ADD_MESSAGE,{add:info,remove:removeItem}));
			if(info.type == MessageType.SPEAKER)
				dispatchEvent(new ChatInfoUpdateEvent(ChatInfoUpdateEvent.SPEAKERPANEL_UPDATE,info));
		}
		
		
		public function get currentChannel():int
		{
			return _currentChannel;
		}
		public function set currentChannel(value:int):void
		{
			if(_currentChannel == value)return;
			_currentChannel = value;
			dispatchEvent(new ChatInfoUpdateEvent(ChatInfoUpdateEvent.CHANNEL_CHANGE));
		}
		
		public function getListByChannel(channel:int):Array
		{
			var result:Array = [];
			for(var i:int = 0; i < itemList.length; i++)
			{
				if(ChatItemInfo(itemList[i]).isRequoteByChannel(channel))
				{
					result.push(itemList[i]);
				}
			}
			return result;
		}
		
		public function getShowList():Dictionary
		{
			switch(currentChannel)
			{
				case ChannelType.WORLD:return worldShowList;
				case ChannelType.CMP:return cmpShowList;
				case ChannelType.CLUB:return clubShowList;
				case ChannelType.GROUP:return groupShowList;
				case ChannelType.CURRENT:return currentShowList;
				case ChannelType.SPEAKER:return speakerShowList;
				case ChannelType.CITY:return cityShowList;
			}
			return null;
		}
	}
}