package sszt.scene.components.group
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.chat.ChatSockethandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.group.groupSec.ChatItemView;
	import sszt.scene.mediators.GroupMediator;
	
	public class GroupChatPanel extends MPanel
	{
		private var _mediator:GroupMediator;
		private var _bg:IMovieWrapper;
		private var _sendBtn:MCacheAsset1Btn;
		private var _chatContent:ChatContentPanel;
		private var _inputText:TextField;
		
		public function GroupChatPanel(mediator:GroupMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.common.buildTeamChat")), true, -1, true, false);	
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(317,334);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,317,210)),
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,229,317,74)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(293,5,2,199),new MCacheSplit4Line())
				]);
			addContent(_bg as DisplayObject);
			
			_sendBtn = new MCacheAsset1Btn(0,LanguageManager.getWord("ssztl.common.send"));
			_sendBtn.move(218,306);
			addContent(_sendBtn);
			
			_chatContent = new ChatContentPanel(_mediator);
			_chatContent.move(2,2);
			addContent(_chatContent);
			
			_inputText = new TextField();
			_inputText.textColor = 0xffffff;
			_inputText.type = TextFieldType.INPUT;
			_inputText.x = 2;
			_inputText.y = 231;
			_inputText.width = 313;
			_inputText.height = 70;
			addContent(_inputText);
			
			move(645,102);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_sendBtn.addEventListener(MouseEvent.CLICK,sendClickHandler);
		}
		
		private function removeEvent():void
		{
			_sendBtn.removeEventListener(MouseEvent.CLICK,sendClickHandler);
		}
				
		private function sendClickHandler(evt:MouseEvent):void
		{
			if(_inputText.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.unableSendNullContent"));
				return ;
			}
			ChatSockethandler.sendMessage(ChannelType.GROUP,_inputText.text);
			_inputText.text = "";
			stage.focus = _inputText;
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_sendBtn)
			{
				_sendBtn.dispose();
				_sendBtn = null;
			}
			if(_chatContent)
			{
				_chatContent.dispose();
				_chatContent = null;
			}
			_inputText = null;
			super.dispose();
		}
	}
}