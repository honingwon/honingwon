package sszt.friends.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ConfigurePanel extends MPanel
	{
		private var _mediator:FriendsMediator;
		private var _bg:IMovieWrapper;
		private var _groupTabBtn:MCacheTab1Btn;
		private var _replyTabBtn:MCacheTab1Btn;
		private var _groupPanel:GroupSetupPanel;
		private var _replyPanel:AutoReplyPanel;
		private var _btns:Array;
		private var _currentTab:int;
		
		public function ConfigurePanel(mediator:FriendsMediator)
		{
			_mediator = mediator;
//			super(new MCacheTitle1("",new Bitmap(new SetupTitleAsset())), true, -1);
			initEvent();
		}
		
		public function get replyPanel():AutoReplyPanel
		{
			return _replyPanel;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(312,240);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,312,240)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,30,302,5),new MCacheSplit1Line())
				]);
			addContent(_bg as DisplayObject);
			
			_groupTabBtn = new MCacheTab1Btn(0,1,LanguageManager.getWord("ssztl.friends.groupSetting"));
			_groupTabBtn.move(12,8);
			_groupTabBtn.selected = true;
			addContent(_groupTabBtn);
			
			_replyTabBtn = new MCacheTab1Btn(0,1,LanguageManager.getWord("ssztl.friends.autoReply"));
			_replyTabBtn.move(79,8);
			addContent(_replyTabBtn);

//			_replyTabBtn = new MCacheTab1Btn(0,1,"自动回复");
//			_replyTabBtn.move(79,8);
//			addContent(_replyTabBtn);
			
			_currentTab = 0;
			_btns = [_groupTabBtn,_replyTabBtn];
			
			_groupPanel = new GroupSetupPanel();
			_groupPanel.move(5,35);
			addContent(_groupPanel);
			
//			_replyPanel = new AutoReplyPanel(_mediator);
//			_replyPanel.move(5,35);
//			addContent(_replyPanel);
//			_replyPanel.hide();
		}
		
		private function initEvent():void
		{
			_groupTabBtn.addEventListener(MouseEvent.CLICK,tabBtnClickHandler);
//			_replyTabBtn.addEventListener(MouseEvent.CLICK,tabBtnClickHandler);
			_groupPanel.addEventListener(GroupSetupPanel.PARENT_CLOSE,closeHandler);
//			_replyPanel.addEventListener(AutoReplyPanel.PARENT_CLOSE,closeHandler);
		}
		
		private function removeEvent():void
		{
			_groupTabBtn.removeEventListener(MouseEvent.CLICK,tabBtnClickHandler);
//			_replyTabBtn.removeEventListener(MouseEvent.CLICK,tabBtnClickHandler);
			_groupPanel.removeEventListener(GroupSetupPanel.PARENT_CLOSE,closeHandler);
//			_replyPanel.removeEventListener(AutoReplyPanel.PARENT_CLOSE,closeHandler);
		}
		
		private function closeHandler(evt:Event):void
		{
			dispose();
		}
		
		private function tabBtnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget);
			if(index == _currentTab) return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			_currentTab = index;
			_btns[0].selected = _btns[1].selected = false;
			_btns[index].selected = true;
			if(index == 0)
			{
				_replyPanel.hide();
				addContent(_groupPanel);
			}else
			{
				_groupPanel.hide();
				addContent(_replyPanel);
			}
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
			if(_groupTabBtn)
			{
				_groupTabBtn.dispose();
				_groupTabBtn = null;
			}
			if(_replyTabBtn)
			{
				_replyTabBtn.dispose();
				_replyTabBtn = null;
			}
			if(_groupPanel)
			{
				_groupPanel.dispose();
				_groupPanel = null;
			}
			if(_replyPanel)
			{
				_replyPanel.dispose();
				_replyPanel = null;
			}
			_btns = null;
			super.dispose();
		}
		
	}
}