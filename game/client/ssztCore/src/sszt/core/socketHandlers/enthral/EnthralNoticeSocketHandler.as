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
	
	public class EnthralNoticeSocketHandler extends BaseSocketHandler
	{
		private var _timeoutIndex:int = -1;
		
		public function EnthralNoticeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ENTHRAL_NOTICE;
		}
		
		override public function handlePackage():void
		{
			var p:Boolean = _data.readBoolean();
			GlobalData.onLineTime = _data.readInt();
			
			if(p)
			{
				GlobalData.isEnthral = true;
			}
			else
			{
				if(GlobalData.enthralType == 2)
				{
					_timeoutIndex = setTimeout(showHandler,1000);
					function showHandler():void
					{
						EnthralInPanel.getInstance().show();
						if(_timeoutIndex != -1)
						{
							clearTimeout(_timeoutIndex);
						}
					}
				}
				else if(GlobalData.enthralType == 3)
				{
					var itemInfo:ChatItemInfo = new ChatItemInfo();
					itemInfo.type = MessageType.CHAT;
					itemInfo.fromNick = "";
					itemInfo.fromId = 0;
					itemInfo.fromSex = 0;
					itemInfo.toNick = "";
					itemInfo.toId = 0;
					itemInfo.message = LanguageManager.getWord("ssztl.core.noPassEnthral");
					ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,itemInfo));
				}
				
				ModuleEventDispatcher.dispatchEnthralEvent(new EnthralModuleEvent(EnthralModuleEvent.SHOW_ENTHRAL_ICON));
			}
			
			handComplete();
		}
	}
}