package sszt.friends.component
{
	import fl.controls.CheckBox;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.WordFilterUtils;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class AutoReplyPanel extends Sprite
	{
		public static const PARENT_CLOSE:String = "parent dispose";
		private var _bg:IMovieWrapper;
		private var _checkBox:CheckBox;
		private var _replyContext:TextField;
		private var _okBtn:MCacheAsset1Btn;
		private var _closeBtn:MCacheAsset1Btn;
		private var _autoReply:Boolean;
		private var _mediator:FriendsMediator;
		
		public function AutoReplyPanel(mediator:FriendsMediator)
		{
			_mediator = mediator;
			super();
			initView();
			_autoReply = false;
			initEvent();
		}
		
		public function get autoReply():Boolean
		{
			return _autoReply;
		}
		
		public function get replyContext():String
		{
			return _replyContext.text;
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(3,52,300,109)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(1,25,303,2),new MCacheSplit2Line()),
				]);
			addChild(_bg as DisplayObject);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(3,33,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.setContent"),MAssetLabel.LABELTYPE1)));
			
			_checkBox = new CheckBox();
			_checkBox.label = LanguageManager.getWord("ssztl.friends.openAutoReplay");
			_checkBox.setSize(120,20);
			_checkBox.move(9,0);
			addChild(_checkBox);
			_checkBox.selected = _mediator.friendsModule.autoReply;
			
			_replyContext = new TextField();
			_replyContext.textColor = 0xffffff;
			_replyContext.maxChars = 30;
			_replyContext.width = 300;
			_replyContext.height = 109;
			_replyContext.x = 4;
			_replyContext.y = 53;
			_replyContext.text = _mediator.friendsModule.replyContext;
			_replyContext.type = TextFieldType.INPUT;
			addChild(_replyContext);
			
			_okBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.sure"));
			_closeBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.close"));
			_okBtn.move(3,174);
			_closeBtn.move(232,174);
			addChild(_okBtn);
			addChild(_closeBtn);
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,okBtnHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
		}
		
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,okBtnHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
		}
		
		private function okBtnHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_checkBox.selected)
			{
				_autoReply = true;
			}
			else
			{
				_autoReply = false;
			}
			var t:String = WordFilterUtils.filterChatWords(_replyContext.text);
			dispatchEvent(new FriendEvent(FriendEvent.SET_CHANGE,{auto:_autoReply,replyContext:t}));
			_replyContext.text = t;
			dispatchEvent(new Event(PARENT_CLOSE));
		}
		
		private function closeHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispatchEvent(new Event(PARENT_CLOSE));
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_checkBox = null;
			_replyContext = null;
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn = null;
			}
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
		
	}
}