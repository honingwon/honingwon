package sszt.club.components.clubMain.pop.sec
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	import sszt.club.components.clubMain.pop.sec.src.ClubApplyView;
	import sszt.club.components.clubMain.pop.sec.src.ClubContributeView;
	import sszt.club.components.clubMain.pop.sec.src.ClubEventView;
	import sszt.club.components.clubMain.pop.sec.src.ContributeLogView;
	import sszt.club.mediators.ClubMediator;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubLogPanel extends MSprite implements IClubMainPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _applyBtn:MCacheAsset3Btn,_eventBtn:MCacheAsset3Btn,_contributeBtn:MCacheAsset3Btn,_logBtn:MCacheAsset3Btn;
		private var _btnList:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int;
		
		public function ClubLogPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,2,98,368)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(102,2,573,368)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(107,6,565,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,58,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,91,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,124,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,157,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,190,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,223,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,256,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,289,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,322,562,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,355,562,2),new MCacheSplit2Line())
			]);
			addChild(_bg as DisplayObject);
			
			_applyBtn = new MCacheAsset3Btn(2,LanguageManager.getWord("ssztl.club.dealApply"));
			_applyBtn.move(12,15);
			addChild(_applyBtn);
			_eventBtn = new MCacheAsset3Btn(2,LanguageManager.getWord("ssztl.club.clubEvent"));
			
			_eventBtn.move(12,55);
			addChild(_eventBtn);
			_contributeBtn = new MCacheAsset3Btn(2,LanguageManager.getWord("ssztl.club.contributeCount"));
			_contributeBtn.move(12,95);
			addChild(_contributeBtn);
			_logBtn = new MCacheAsset3Btn(2,LanguageManager.getWord("ssztl.club.contributeLog"));
			_logBtn.move(12,135);
			addChild(_logBtn);
			
			_btnList = [_applyBtn,_eventBtn,_contributeBtn,_logBtn];
			_classes = [ClubApplyView,ClubEventView,ClubContributeView,ContributeLogView];
			_panels = new Array(_btnList.length);
			_currentIndex = -1;
			setIndex(0);
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		private function initEvent():void
		{
			_applyBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_eventBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_contributeBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_logBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			_applyBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_eventBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_contributeBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_logBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btnList.indexOf(e.currentTarget as MCacheAsset3Btn);
			setIndex(index);
		}
		
		private function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			if(_currentIndex > -1)
			{
				if(_panels[_currentIndex])_panels[_currentIndex].hide();
			}
			_currentIndex = index;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(107,6);
			}
			_panels[_currentIndex].show();
			addChild(_panels[_currentIndex] as DisplayObject);
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_panels)
			{
				for(var i:int = 0;i<_panels.length;i++)
				{
					if(_panels[i])
					{
						_panels[i].dispose();
					}
				}
				_panels = null;
			}
			if(_applyBtn)
			{
				_applyBtn.dispose();
				_applyBtn = null;
			}
			if(_eventBtn)
			{
				_eventBtn.dispose();
				_eventBtn = null;
			}
			if(_contributeBtn)
			{
				_contributeBtn.dispose();
				_contributeBtn = null;
			}
			if(_logBtn)
			{
				_logBtn.dispose();
				_logBtn = null;
			}
			_mediator = null;
			super.dispose();
		}
	}
}