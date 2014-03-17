package sszt.chatutil.components
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	
	import sszt.chatutil.data.ChatInfo;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	
	public class ChatController extends MSprite
	{
		private var _worldBtn:MCacheSelectBtn;
		private var _cmpBtn:MCacheSelectBtn;
		private var _clubBtn:MCacheSelectBtn;
		private var _groupBtn:MCacheSelectBtn;
		private var _currentBtn:MCacheSelectBtn;
		private var _speakerBtn:MCacheSelectBtn;
		private var _selectedBtn:MCacheSelectBtn;
		private var channelBtn:MBitmapButton;
		private var _btnList:Array;
		private var _selectedChannel:int;
		private var _chatInfo:ChatInfo;
		private var _messageTypeView:MessageTypeView;
		public function ChatController(info:ChatInfo)
		{
			_chatInfo = info;
			super();
			initView();
			addEvents();
			_chatInfo.currentChannel = ChannelType.WORLD;
		}
		
		private function initView():void
		{
			_worldBtn = new MCacheSelectBtn(0,1,"世界");
			_worldBtn.move(18,0);
			addChild(_worldBtn);
			_cmpBtn = new MCacheSelectBtn(0,1,"阵营");
			_cmpBtn.move(57,0);
			addChild(_cmpBtn);
			_clubBtn = new MCacheSelectBtn(0,1,"帮会");
			_clubBtn.move(96,0);
			addChild(_clubBtn);
			_groupBtn = new MCacheSelectBtn(0,1,"队伍");
			_groupBtn.move(135,0);
			addChild(_groupBtn);
			_currentBtn = new MCacheSelectBtn(0,1,"附近");
			_currentBtn.move(174,0);
			addChild(_currentBtn);
			_speakerBtn = new MCacheSelectBtn(0,1,"喇叭");
			_speakerBtn.move(213,0);
			addChild(_speakerBtn);
			
			_btnList = [_worldBtn,_cmpBtn,_clubBtn,_groupBtn,_currentBtn,_speakerBtn];
		}
		
		private function addEvents():void
		{
			_worldBtn.addEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_cmpBtn.addEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_clubBtn.addEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_groupBtn.addEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_currentBtn.addEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_speakerBtn.addEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_chatInfo.addEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
		}
		
		private function removeEvents():void
		{
			_worldBtn.removeEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_cmpBtn.removeEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_clubBtn.removeEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_groupBtn.removeEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_currentBtn.removeEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_speakerBtn.removeEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			_chatInfo.removeEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
		}
		
		private function channelBtnClickHandler(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			if(_selectedBtn == MCacheSelectBtn(evt.currentTarget) && _btnList.indexOf(_selectedBtn) < 5)
			{
				if(_messageTypeView == null)
				{
					_messageTypeView = new MessageTypeView(_chatInfo);
				}
				var point:Point;
				if(_btnList.indexOf(_selectedBtn) == 0)
				{
					point = localToGlobal(new Point(_selectedBtn.x,_selectedBtn.y-111));
					_messageTypeView.move(point.x,point.y);
				}
					
				else 
				{
					point = localToGlobal(new Point(_selectedBtn.x,_selectedBtn.y-36));
					_messageTypeView.move(point.x,point.y);
				}
					
				if(_messageTypeView && _messageTypeView.parent)
					_messageTypeView.hide();
				else
				{
					if(_btnList.indexOf(_selectedBtn) == 0)_messageTypeView.show(1);
					else _messageTypeView.show(2);
				}
			}
			else
			{
				if(_messageTypeView && _messageTypeView.parent)
					_messageTypeView.hide();
				_chatInfo.currentChannel = _btnList.indexOf(MCacheSelectBtn(evt.currentTarget)) + 1;
			}
		}
		
		private function channelChangeHandler(e:ChatInfoUpdateEvent):void
		{
			_selectedChannel = _chatInfo.currentChannel;
			if(_selectedBtn)
				_selectedBtn.selected = false;
			_selectedBtn = _btnList[_selectedChannel - 1];
			_selectedBtn.selected = true;
//			_channelBt.labelField.text = ChannelType.getChannelName(_selectedChannel) + "  ";
		}
		
		override public function dispose():void
		{
			if(_btnList)
			{
				for each(var btn:MSelectButton in _btnList)
				{
					btn.dispose();
				}
				_btnList = null;
			}
		}
	}
}