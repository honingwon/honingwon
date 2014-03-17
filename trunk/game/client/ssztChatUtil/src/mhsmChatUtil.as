package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import sszt.ui.UIManager;
	
	import sszt.chatutil.StageUtil;
	import sszt.chatutil.components.ChatPanel;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.player.SelfPlayerInfo;
//	import sszt.moviewrapper.MovieManager;

	[SWF(width=999,height=580,backgroundColor=0xffffff,frameRate=25)]
	public class mhsmChatUtil extends Sprite
	{
		private var _chatPanel:ChatPanel;
		private var _count:int;
		public function mhsmChatUtil()
		{
//			StageUtil.stage = this.stage;
//			GlobalData.selfPlayer = new SelfPlayerInfo();
//			GlobalData.selfPlayer.userId = 10100001;
//			GlobalData.selfPlayer.nick = "尼玛";
//			var t:MovieManager = new MovieManager();
//			t.setup();
//			UIManager.setup(this,t);
//			
//			_chatPanel = new ChatPanel();
//			_chatPanel.move(50,50);
//			addChild(_chatPanel);
//			
//			var timer:Timer = new Timer(1000,0);
//			timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
//			timer.start();
			
//			addEventListener(MouseEvent.CLICK,onTimerHandler);
		}
		
		private function onTimerHandler(evt:Event):void
		{
//			_count++;
//			var item:ChatItemInfo = new ChatItemInfo();
//			item.serverId = 2;
//			item.fromNick = "测试者";
//			item.fromId = 10100001 + _count%2;
//			item.type = _count%7==0?10:_count%7;
//			item.message = "聊天测试"+_count;
//			_chatPanel.addItem(item);
		}
	}
}