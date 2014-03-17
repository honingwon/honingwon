package sszt.core.data.store
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.events.MysteryShopMessageEvent;

	public class MysteryShopMessageInfo extends EventDispatcher
	{
		public static const MAX_SIZE:int = 20;
		public var flag:Boolean;
		public var msgList:Array = [];
		private var _gainItemList:Array = [];
		public function MysteryShopMessageInfo()
		{
		}
		
		public function set gainItemList(list:Array):void
		{
			_gainItemList = list;
			dispatchEvent(new MysteryShopMessageEvent(MysteryShopMessageEvent.GAIN_ITEM_LIST_UPDATE,list));
		}
		
		public function get gainItemList():Array
		{
			return _gainItemList;
		}
		
		public function addMessage(serverId:int,nickName:String,item:int):void
		{
			var message:String = LanguageManager.getWord("ssztl.common.mysteryShopChatNotice",
				"{N"+nickName+"}","{I0-0-"+item+"-0}");
			
			var message1:String = LanguageManager.getWord("ssztl.common.mysteryShopChatNotice1",
				"{N"+nickName+"}","{I0-0-"+item+"-0}");
			
			var info:ChatItemInfo = new ChatItemInfo();
			info.type =MessageType.SYSTEM;
			info.message = message1;

			GlobalData.chatInfo.appendMessage(info);
			if(msgList.length >= MAX_SIZE)
			{
				msgList.pop();
				dispatchEvent(new MysteryShopMessageEvent(MysteryShopMessageEvent.Mystery_MSG_REMOVE));
			}
			msgList.unshift(message);
			dispatchEvent(new MysteryShopMessageEvent(MysteryShopMessageEvent.Mystery_MSG_ADD,message));
		}
		
		public function initMysteryShopMsgInfo(list:Array,list1:Array):void
		{
			msgList = list;//.reverse();
			flag = true;
			dispatchEvent(new MysteryShopMessageEvent(MysteryShopMessageEvent.Mystery_MSG_LOADED));
		}
		
		public function clearBoxMsgInfo():void
		{
			msgList = [];
			flag = false;
		}
	}
}