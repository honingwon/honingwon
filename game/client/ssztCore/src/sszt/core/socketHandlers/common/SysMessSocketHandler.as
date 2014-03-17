package sszt.core.socketHandlers.common
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.data.systemMessage.SystemMessageType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ChatModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class SysMessSocketHandler extends BaseSocketHandler
	{
		public function SysMessSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SYS_MESS;
		}
		
		override public function handlePackage():void
		{
			var item:SystemMessageInfo = new SystemMessageInfo();
			item.type = _data.readShort();
			item.code = _data.readInt();
			item.color = _data.readByte();
			item.message = _data.readString();
			var itemInfo:ChatItemInfo;
			if(item.type == SystemMessageType.FLOAT)
				QuickTips.show(item.message);
			else if(item.type == SystemMessageType.ALERT)
				MAlert.show(item.message,LanguageManager.getWord("ssztl.common.alertTitle"));
			else if(item.type == SystemMessageType.EVENT)
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,item.message));
			else if(item.type == SystemMessageType.CHAT)
			{
				itemInfo = new ChatItemInfo();
				itemInfo.type = MessageType.CHAT;
				itemInfo.fromNick = "";
				itemInfo.fromId = 0;
				itemInfo.fromSex = 0;
				itemInfo.toNick = "";
				itemInfo.toId = 0;
				itemInfo.message = item.message;
				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,itemInfo));
			}
			else if(item.type == SystemMessageType.NOTICE)
			{
				itemInfo = new ChatItemInfo();
				itemInfo.type = MessageType.NOTICE;
				itemInfo.fromNick = "";
				itemInfo.fromId = 0;
				itemInfo.fromSex = 0;
				itemInfo.toNick = "";
				itemInfo.toId = 0;
				itemInfo.message = item.message;
				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,itemInfo));
			}
			else if(item.type == SystemMessageType.ROLL)
			{
				itemInfo = new ChatItemInfo();
				itemInfo.type = MessageType.SYSTEM;
				itemInfo.fromNick = "";
				itemInfo.fromId = 0;
				itemInfo.fromSex = 0;
				itemInfo.toNick = "";
				itemInfo.toId = 0;
				itemInfo.message = item.message;
				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,itemInfo));
			}
			
			handComplete();
		}
	}
}