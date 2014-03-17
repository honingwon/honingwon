package sszt.core.data.chat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	
	public class ChatInfo extends EventDispatcher
	{
		public static const MAX_LENGTH:int = 30;
		
		public var worldlist:Array;
		public var cmplist:Array;
		public var clublist:Array;
		public var grouplist:Array;
		public var currentlist:Array;
		public var privatelist:Array;
		public var speakerlist:Array;
		public var updateList:Array;
		public var currentUpdateList:Array;
		
		public var worldShowList:Dictionary;
		public var cmpShowList:Dictionary;
		public var clubShowList:Dictionary;
		public var groupShowList:Dictionary;
		public var currentShowList:Dictionary;
		public var speakerShowList:Dictionary;
		
		private var _currentChannel:int;
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
		
		public function ChatInfo()
		{
			super();
			
			worldlist = [];
			cmplist = [];
			clublist = [];
			grouplist = [];
			currentlist = [];
			privatelist = [];
			speakerlist = [];
			updateList = [];
			currentUpdateList = [];
			
			worldShowList = new Dictionary();
			cmpShowList = new Dictionary();
			clubShowList = new Dictionary();
			groupShowList = new Dictionary();
			currentShowList = new Dictionary();
			speakerShowList = new Dictionary();
			for each(var type:int in MessageType.getAllTypes())
			{
				worldShowList[type] = true;
				cmpShowList[type] = true;
				clubShowList[type] = true;
				groupShowList[type] = true;
				currentShowList[type] = true;
				speakerShowList[type] = true;
			}
		}
		
		public function appendMessage(info:ChatItemInfo):void
		{
			if(info == null)return;
			updateList.push(info);
			var list:Array = ChannelType.getMessageType(currentChannel);
			for(var i:int = 0; i < list.length; i++)
			{
				if(list[i] == info.type && getShowList() != null && getShowList()[info.type] == true)
				{
					currentUpdateList.push(info);
				}
			}
		}
		
		public function addToList():void
		{
			for each(var info:ChatItemInfo in updateList)
			{
				var list:Array = ChannelType.getChannelType(info.type);
				for(var i:int = 0; i < list.length; i++)
				{
					switch(list[i])
					{
						case ChannelType.WORLD:
							if(worldShowList[info.type])worldlist.push(info);
							if(worldlist.length > MAX_LENGTH)worldlist.shift();
							break;
						case ChannelType.CMP:
							if(cmpShowList[info.type])cmplist.push(info);
							if(cmplist.length > MAX_LENGTH)cmplist.shift();
							break;
						case ChannelType.CLUB:
							if(clubShowList[info.type])clublist.push(info);
							if(clublist.length > MAX_LENGTH)clublist.shift();
							break;
						case ChannelType.GROUP:
							if(groupShowList[info.type])grouplist.push(info);
							if(grouplist.length > MAX_LENGTH)grouplist.shift();
							dispatchEvent(new ChatInfoUpdateEvent(ChatInfoUpdateEvent.ADD_GROUP_CHATINFO,info));
							break;
						case ChannelType.CURRENT:
							if(currentShowList[info.type])currentlist.push(info);
							if(currentlist.length > MAX_LENGTH)currentlist.shift();
							break;
						case ChannelType.PRIVATE:
							privatelist.push(info);
							if(privatelist.length > MAX_LENGTH)privatelist.shift();
							break;
						case ChannelType.SPEAKER:
							speakerlist.push(info);
							if(speakerlist.length > MAX_LENGTH)speakerlist.shift();
							showSpeakerMessage(info);
							break;
					}
				}
			}
		}
		
		public function getMessageList(channel:int):Array
		{
			switch(channel)
			{
				case ChannelType.WORLD:return worldlist;
				case ChannelType.CMP:return cmplist;
				case ChannelType.CLUB:return clublist;
				case ChannelType.GROUP:return grouplist;
				case ChannelType.CURRENT:return currentlist;
				case ChannelType.PRIVATE:return privatelist;
				case ChannelType.SPEAKER:return speakerlist;
			}
			return null;
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
			}
			return null;
		}
		
		public function clearUpdateList():void
		{
			addToList();
			updateList = [];
			currentUpdateList = [];
		}
		
		private function showSpeakerMessage(info:ChatItemInfo):void
		{
			dispatchEvent(new ChatInfoUpdateEvent(ChatInfoUpdateEvent.SPEAKERPANEL_UPDATE,info));
		}
	}
}