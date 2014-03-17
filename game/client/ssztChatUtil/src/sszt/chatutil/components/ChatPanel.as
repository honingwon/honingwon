package sszt.chatutil.components
{
	import sszt.ui.container.MSprite;
	
	import sszt.chatutil.data.ChatInfo;
	import sszt.core.data.chat.ChatItemInfo;
	
	public class ChatPanel extends MSprite
	{
		private var _chatView:ChatView;
		private var _chatController:ChatController;
		private var _chatInfo:ChatInfo;
		
		public function ChatPanel()
		{
			super();
			init();
			initView();
		}
		
		private function init():void
		{
			_chatInfo = new ChatInfo();
		}
		
		private function initView():void
		{
			_chatView = new ChatView(_chatInfo);
			_chatView.move(19,0);
			addChild(_chatView);
			
			_chatController = new ChatController(_chatInfo);
			_chatController.move(0,210);
			addChild(_chatController);
		}
		
		public function addItem(info:ChatItemInfo):void
		{
			_chatInfo.appendMessage(info);
		}
	}
}