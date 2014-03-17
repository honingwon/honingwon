package sszt.club.components.clubMain
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.club.components.clubMain.pop.ActivityRaidResultPanel;
	import sszt.club.components.clubMain.pop.sec.ClubInfoPanel;
	import sszt.club.components.clubMain.pop.sec.ClubListPanel;
	import sszt.club.components.clubMain.pop.sec.ClubManagerPanel;
	import sszt.club.components.clubMain.pop.sec.IClubMainPanel;
	import sszt.club.components.clubMain.pop.sec.MemberInfoPanel;
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.ClubTitleAsset;
	
	public class ClubMainPanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int;
		
		public var clubId:Number;
		private var _index:int;
		private var _assetsComplete:Boolean;
		
		public function ClubMainPanel(mediator:ClubMediator,id:Number,argIndex:int)
		{
			_assetsComplete = false;
			_mediator = mediator;
			_index = argIndex;
			clubId = id;
			_currentIndex = -1;
			super(new MCacheTitle1("",new Bitmap(new ClubTitleAsset())),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(651,396);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,635,363)),								
			]);
			addContent(_bg as DisplayObject);
			
			_labels = [
				LanguageManager.getWord("ssztl.club.clubList"),
				LanguageManager.getWord("ssztl.club.clubInfo"),
				LanguageManager.getWord("ssztl.club.memberInfo"),
				LanguageManager.getWord("ssztl.club.clubManage")]
			_classes = [ClubListPanel,ClubInfoPanel,MemberInfoPanel,ClubManagerPanel];
			_panels = new Array(_labels.length);
			_btns = [];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(15+69*i,0);
				addContent(btn);
				_btns.push(btn);
			}
			
			setBtns();
			
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
		
		public function setBtns():void
		{
			setIndex(_index);
			
			for(var i:int = 1; i < _btns.length; i++)
			{
				_btns[i].visible = GlobalData.selfPlayer.clubId != 0;
			}
			if(GlobalData.selfPlayer.clubDuty == ClubDutyType.PREPARE || GlobalData.selfPlayer.clubDuty == ClubDutyType.NULL)
			{
//				_btns[_btns.length -1].visible = false;
			}
		}
		
		public function setIndex(index:int):void
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
				if(_assetsComplete)
				{
					(_panels[_currentIndex] as IClubMainPanel).assetsCompleteHandler();
				}
				_panels[_currentIndex].move(8,26);
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
		}
		
		public function setIndexFromOut(argIndex:int):void
		{
			_index = argIndex;
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			for(var i:int = 0; i < _panels.length; i++)
			{
				if(_panels[i] != null)
					(_panels[_currentIndex] as IClubMainPanel).assetsCompleteHandler();
			}
		}
		
		public function get panels():Array
		{
			return _panels;
		}
		
		override public function dispose():void
		{
			removeEvent();
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
				for each(var panel:IClubMainPanel in _panels)
				{
					if(panel)panel.dispose();
				}
			}
			_panels = null;
			_labels = null;
			_classes = null;
//			_mediator.clubInfo.clearDetailInfo();
			_mediator = null;
			super.dispose();
		}
	}
}