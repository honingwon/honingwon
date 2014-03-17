package sszt.club.components.clubMain.pop.store
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.ClubStoreTitleAsset;
	
	public class ClubStorePanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
//		private var _btns:Vector.<MCacheTabBtn1>;
//		private var _panels:Vector.<IClubStoreView>;
//		private var _classes:Vector.<Class>;
//		private var _labels:Vector.<String>;
		/**
		 * 选项卡按钮
		 * */
		private var _btns:Array;
		private var _panels:Array;
		private var _classes:Array;
		private var _labels:Array;
		private var _currentIndex:int;
		
		public function ClubStorePanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initStoreInfo();
			super(new MCacheTitle1("",new Bitmap(new ClubStoreTitleAsset())),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(414,280);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,398,247))
			]);
			addContent(_bg as DisplayObject);			
						
			_labels = [
				LanguageManager.getWord("ssztl.club.checkStore"),
				LanguageManager.getWord("ssztl.club.checkLog"),
				LanguageManager.getWord("ssztl.club.appliedItemRecords"),
				LanguageManager.getWord("ssztl.club.examineAndVerify")
			];
			_classes = [ClubStoreView, ClubStoreEventView,ClubStoreApplyView,ClubStoreExamineView];
			_panels = new Array(_labels.length);
			_btns = [];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(15+69*i,0);
				addContent(btn);
				_btns.push(btn);
			}			
			_currentIndex = -1;
			setIndex(0);
			
			if(!ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				_btns[3].visible = false;
			}
		}
		
		private function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			if(_currentIndex > -1)
			{
				if(_btns[_currentIndex])
					_btns[_currentIndex].selected = false;
				if(_panels[_currentIndex])
					_panels[_currentIndex].hide();
			}
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(12,29);
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		public function assetsCompleteHandler():void
		{
//			_bg.bitmapData = AssetUtil.getAsset("ssztui.club.ClubStoreViewBgAsset",BitmapData) as BitmapData;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btns)
			{
				for each(var btn:MCacheTabBtn1 in _btns)
				{
					btn.dispose();
				}
			}
			_btns = null;
			if(_panels)
			{
				for each(var panel:IClubStoreView in _panels)
				{
					if(panel)panel.dispose();
				}
			}
			_panels = null;
			_labels = null;
			_classes = null;
//			_mediator.clubInfo.clearStoreInfo();
			_mediator = null;
		}
	}
}