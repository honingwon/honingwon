package sszt.core.socketHandlers.enthral
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.enthral.EnthralInPanel;
	import sszt.core.view.enthral.EnthralPanel;
	import sszt.events.ChatModuleEvent;
	import sszt.events.EnthralModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	
	public class EnthralSendStateSocketHandler extends BaseSocketHandler
	{
		private var _timeoutIndex:int = -1;
		
		public function EnthralSendStateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ENTHRAL_SEND_STATE;
		}
		
		override public function handlePackage():void
		{
			var state:int = _data.readShort();
			GlobalData.onLineTime = _data.readInt();
			
			if(state != 1)
			{
				GlobalData.isEnthral = true;
				GlobalData.enthralState = state;
				var str:String = "";
				str = "ssztl.cors.enthralNotice" + state;
//				var itemInfo:ChatItemInfo = new ChatItemInfo();
//				itemInfo.type = MessageType.CHAT;
//				itemInfo.fromNick = "";
//				itemInfo.fromId = 0;
//				itemInfo.fromSex = 0;
//				itemInfo.toNick = "";
//				itemInfo.toId = 0;
//				itemInfo.message = LanguageManager.getWord(str);
//				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,itemInfo));
				
				MAlert.show(LanguageManager.getWord(str),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null,null);
			}
				
			//ModuleEventDispatcher.dispatchEnthralEvent(new EnthralModuleEvent(EnthralModuleEvent.SHOW_ENTHRAL_ICON));
			
			handComplete();
		}
	}
}