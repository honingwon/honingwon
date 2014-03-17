package sszt.core.data.box
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.events.BoxMessageEvent;

	public class BoxMessageInfo extends EventDispatcher
	{
		public static const MAX_SIZE:int = 20;
		public var flag:Boolean;
		public var msgList:Array = [];
		public var msgList1:Array = [];
		private var _gainItemList:Array = [];
		public function BoxMessageInfo()
		{
		}
		
		public function set gainItemList(list:Array):void
		{
			_gainItemList = list;
			dispatchEvent(new BoxMessageEvent(BoxMessageEvent.GAIN_ITEM_LIST_UPDATE,list));
		}
		
		public function get gainItemList():Array
		{
			return _gainItemList;
		}
		
		public function addMessage(serverId:int,nickName:String,type:int,item:int):void
		{
			var message:String = LanguageManager.getWord("ssztl.common.taoBaoChatNotice",
				"{N"+nickName+"}","{T"+type+"}","{I0-0-"+item+"-0}");
			
			var info:ChatItemInfo = new ChatItemInfo();
			info.type =MessageType.SYSTEM;
			info.message = message;

			GlobalData.chatInfo.appendMessage(info);
			if(msgList.length >= MAX_SIZE)
			{
				msgList.pop();
				msgList1.pop();
				dispatchEvent(new BoxMessageEvent(BoxMessageEvent.BOX_MSG_REMOVE));
			}
			msgList.unshift(message);
			msgList1.unshift({id:item,nickName:nickName});
			dispatchEvent(new BoxMessageEvent(BoxMessageEvent.BOX_MSG_ADD,message));
		}
		
		public function initBoxMsgInfo(list:Array,list1:Array):void
		{
			msgList = list;//.reverse();
			msgList1 = list1;
			flag = true;
			dispatchEvent(new BoxMessageEvent(BoxMessageEvent.BOX_MSG_LOADED));
		}
		
		public function clearBoxMsgInfo():void
		{
			msgList = [];
			msgList1 = [];
			flag = false;
		}
	}
}