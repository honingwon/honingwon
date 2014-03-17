package sszt.marriage.componet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.sendToURL;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.WeddingCandiesType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.AmountFlashView;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.marriage.event.WeddingUIEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.marriage.BtnStartAsset;
	import ssztui.marriage.DistributionBtnAsset1;
	import ssztui.marriage.DistributionBtnAsset2;
	import ssztui.marriage.DistributionBtnAsset3;
	import ssztui.marriage.DistributionBtnAsset4;
	import ssztui.marriage.FBSideBgTitleAsset;
	
	/**
	 * 婚礼主人面板
	 * */
	public class WeddingHostPanel extends MSprite
	{
		private const Y:int = 190;
		
		private var _sideView:MSprite;
		private var _midBtnView:MSprite;
		
		private var _btnWeddingInvitation:MCacheAssetBtn1;
		private var _btnCheckGift:MCacheAssetBtn1;
		private var _btnPresentFreeCandies:MCacheAssetBtn1;
		private var _btnPresentGoodCandies:MAssetButton1;
		private var _btnPresentBetterCandies:MAssetButton1;
		private var _btnPresentBestCandies:MAssetButton1;
		private var _btnPresentSuperCandies:MAssetButton1;
		private var _freeAmount:AmountFlashView;
		private var _presentBtns:Array;
		
		private var _bgSide:IMovieWrapper;
		private var _btnLeave:MCacheAssetBtn1;
		private var _btnWeddingCeremony:MAssetButton1;
		private var _countDownView:CountDownView;
		private var _expAdd:MAssetLabel;
		private var _tipLabel:MAssetLabel;
		
		public function WeddingHostPanel(title:DisplayObject=null, dragable:Boolean=true, mode:Number=0.5, closeable:Boolean=true, toCenter:Boolean=true, rect:Rectangle=null)
		{
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_sideView = new MSprite();
			addChild(_sideView);
			
			_midBtnView = new MSprite();
			addChild(_midBtnView);
			
			gameSizeChangeHandler(null);
			
			_btnPresentFreeCandies = new MCacheAssetBtn1(0,3,'_btnPresentFreeCandies');
			_btnPresentFreeCandies.move(10,100);
//			addChild(_btnPresentFreeCandies);
			
			_btnPresentGoodCandies = new MAssetButton1(new DistributionBtnAsset1());
			_btnPresentGoodCandies.move(-220,0);
			_midBtnView.addChild(_btnPresentGoodCandies);
			
			_btnPresentBetterCandies = new MAssetButton1(new DistributionBtnAsset2());
			_btnPresentBetterCandies.move(-110,0);
			_midBtnView.addChild(_btnPresentBetterCandies);
			
			_btnPresentBestCandies = new MAssetButton1(new DistributionBtnAsset3());
			_btnPresentBestCandies.move(0,0);
			_midBtnView.addChild(_btnPresentBestCandies);
			
			_btnPresentSuperCandies = new MAssetButton1(new DistributionBtnAsset4());
			_btnPresentSuperCandies.move(110,0);
			_midBtnView.addChild(_btnPresentSuperCandies);
			
			_presentBtns = [_btnPresentGoodCandies,_btnPresentBetterCandies,_btnPresentBestCandies,_btnPresentSuperCandies];
			
			var _background:Shape = new Shape();
			_background.graphics.beginFill(0x000000,0.5);
			_background.graphics.drawRect(0,0,208,10);
			_background.graphics.endFill();
			
			var pl:int = 22;
			_bgSide = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,184,265),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,4,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.waddingLive"),MAssetLabel.LABEL_TYPE20)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,66,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.waddingCeremony"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,142,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.marry.weddingHostTip"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,163,184,2),new MCacheSplit2Line()),
			]);
			_sideView.addChild(_bgSide as DisplayObject);
			
			_btnWeddingCeremony = new MAssetButton1(new BtnStartAsset());
			_btnWeddingCeremony.move(66,84);
			_sideView.addChild(_btnWeddingCeremony);
			
			_countDownView = new CountDownView();
			_countDownView.setLabelType(new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),28,0xffff00,true,null,null,null,null,TextFormatAlign.CENTER));
			_countDownView.setSize(184,50);
			_countDownView.move(pl, 24);
			_sideView.addChild(_countDownView);
			
			_expAdd = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_expAdd.move(114,126);
			_sideView.addChild(_expAdd);
			_expAdd.setHtmlValue(LanguageManager.getWord("ssztl.marry.weddingExpAdd",2000));
			
			_tipLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_tipLabel.move(pl+85,66);
			_sideView.addChild(_tipLabel);
			_tipLabel.setHtmlValue(LanguageManager.getWord("ssztl.marriage.waddingCeremony"));
			
			_btnWeddingInvitation = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marriage.inviteFriend'));
			_btnWeddingInvitation.move(80,175);
			_sideView.addChild(_btnWeddingInvitation);
			
			_btnCheckGift = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marriage.onInviteFriend'));
			_btnCheckGift.move(80,203);
			_sideView.addChild(_btnCheckGift);
			
			_btnLeave = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.group.leaveTeamWord'));
			_btnLeave.move(80,231);
//			_sideView.addChild(_btnLeave);
		}
		
		private function initEvent():void
		{
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			
			_btnWeddingInvitation.addEventListener(MouseEvent.CLICK,btnWeddingInvitationClickedHandler);
			_btnCheckGift.addEventListener(MouseEvent.CLICK,btnCheckGiftClickedHandler);
			_btnLeave.addEventListener(MouseEvent.CLICK,btnLeaveClickedHandler);
			_btnWeddingCeremony.addEventListener(MouseEvent.CLICK,btnWeddingCeremonyClickedHandler);
			
			_btnPresentFreeCandies.addEventListener(MouseEvent.CLICK, btnPresentCandiesClickedHandler);
			for(var i:int=0; i<4; i++)
			{
				_presentBtns[i].addEventListener(MouseEvent.CLICK, btnPresentCandiesClickedHandler);
				_presentBtns[i].addEventListener(MouseEvent.MOUSE_OVER, btnPresentCandiesOverHandler);
				_presentBtns[i].addEventListener(MouseEvent.MOUSE_OUT, tipOutHandler);
			}
		}
		private function removeEvent():void
		{
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			
			_btnWeddingInvitation.removeEventListener(MouseEvent.CLICK,btnWeddingInvitationClickedHandler);
			_btnCheckGift.removeEventListener(MouseEvent.CLICK,btnCheckGiftClickedHandler);
			_btnLeave.removeEventListener(MouseEvent.CLICK,btnLeaveClickedHandler);
			_btnWeddingCeremony.removeEventListener(MouseEvent.CLICK,btnWeddingCeremonyClickedHandler);
			
			_btnPresentFreeCandies.removeEventListener(MouseEvent.CLICK, btnPresentCandiesClickedHandler);
			for(var i:int=0; i<4; i++)
			{
				_presentBtns[i].removeEventListener(MouseEvent.CLICK, btnPresentCandiesClickedHandler);
				_presentBtns[i].removeEventListener(MouseEvent.MOUSE_OVER, btnPresentCandiesOverHandler);
				_presentBtns[i].removeEventListener(MouseEvent.MOUSE_OUT, tipOutHandler);
			}
		}
		
		public function updateFreeWeddingCandiesNum(num:int):void
		{
			_btnPresentFreeCandies.label = '_btnPresentFreeCandies('+num+')'; 
			if(num > 0)
			{
				if(!_freeAmount)
				{
					_freeAmount = new AmountFlashView();
					_freeAmount.move(-220,0);
					_midBtnView.addChild(_freeAmount);
					_freeAmount.addEventListener(MouseEvent.MOUSE_OVER, freeNumOverHandler);
					_freeAmount.addEventListener(MouseEvent.MOUSE_OUT, tipOutHandler);
				}
				_freeAmount.setValue(num.toString());
			}else
			{
				if(_freeAmount && _freeAmount.parent)
				{
					_freeAmount.removeEventListener(MouseEvent.MOUSE_OVER, freeNumOverHandler);
					_freeAmount.removeEventListener(MouseEvent.MOUSE_OUT, tipOutHandler);
					_freeAmount.parent.removeChild(_freeAmount);
					_freeAmount.dispose();
					_freeAmount = null;
				}
				_btnPresentFreeCandies.enabled = false
			}
		}
		
		public function disableBtnPresentFreeWeddingCandies():void
		{
			if(_freeAmount && _freeAmount.parent)
			{
				_freeAmount.removeEventListener(MouseEvent.MOUSE_OVER, freeNumOverHandler);
				_freeAmount.removeEventListener(MouseEvent.MOUSE_OUT, tipOutHandler);
				_freeAmount.parent.removeChild(_freeAmount);
				_freeAmount.dispose();
				_freeAmount = null;
			}
			_btnPresentFreeCandies.label = '_btnPresentFreeCandies'; 
			_btnPresentFreeCandies.enabled = false;
		}
		
		public function updateCountDownView(seconds:Number):void
		{
			if(seconds > 0)
			{
				_countDownView.start(seconds);
			}
		}
		
//		public function removeCountDownView():void
//		{
//			_countDownView.start(0);
//		}
		
		public function updateText():void
		{
			_tipLabel.setHtmlValue(LanguageManager.getWord("ssztl.marriage.weddingEnd"));
		}
		
		protected function btnPresentCandiesClickedHandler(event:MouseEvent):void
		{
//			var btn:MCacheAssetBtn1 = event.currentTarget as MCacheAssetBtn1;
			var index:int = _presentBtns.indexOf(event.currentTarget);
			var type:int;
			switch(index)
			{
				case -1 :
					type = WeddingCandiesType.FREE;
					break;
				case 0 :
					if(_freeAmount)
						type = WeddingCandiesType.FREE;
					else
						type = WeddingCandiesType.GOOD;
					break;
				case 1 :
					type = WeddingCandiesType.BETTER;
					break;
				case 2 :
					type = WeddingCandiesType.BEST;
					break;
				case 3 :
					type = WeddingCandiesType.SUPER;
					break;
			}
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.PRESENT_WEDDING_CANDIES,type));
		}
		private function btnPresentCandiesOverHandler(evt:MouseEvent):void
		{
			var index:int = _presentBtns.indexOf(evt.currentTarget);
			var tip:String = "";
			switch(index)
			{
				case 0 :
					if(_freeAmount)
						tip = LanguageManager.getWord("ssztl.marriage.presentBtnsTip",0,LanguageManager.getWord("ssztl.marriage.weddingGoodCandiesName"));
					
					else
						tip = LanguageManager.getWord("ssztl.marriage.presentBtnsTip",5,LanguageManager.getWord("ssztl.marriage.weddingGoodCandiesName"));
					break;
				case 1 :
					tip = LanguageManager.getWord("ssztl.marriage.presentBtnsTip",10,LanguageManager.getWord("ssztl.marriage.weddingBetterCandiesName"));
					break;
				case 2 :
					tip = LanguageManager.getWord("ssztl.marriage.presentBtnsTip",30,LanguageManager.getWord("ssztl.marriage.weddingBestCandiesName"));
					break;
				case 3 :
					tip = LanguageManager.getWord("ssztl.marriage.presentBtnsTip",100,LanguageManager.getWord("ssztl.marriage.weddingGoodCandiesName"));
					break;
			}
			
			TipsUtil.getInstance().show(tip,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function freeNumOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.marriage.presentFreeTip"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		protected function btnWeddingCeremonyClickedHandler(event:MouseEvent):void
		{
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.WEDDING_CEREMONY));
		}
		
		protected function btnLeaveClickedHandler(event:MouseEvent):void
		{
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.LEAVE));
		}
		
		protected function btnCheckGiftClickedHandler(event:MouseEvent):void
		{
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.SHOW_WEDDING_CHECK_GIFT_PANEL));
		}
		
		protected function btnWeddingInvitationClickedHandler(event:MouseEvent):void
		{
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.SHOW_WEDDING_INVITATION_PANEL));
		}
		
		public function get btnWeddingCeremony():MAssetButton1
		{
			return _btnWeddingCeremony;
		}
		
		public function get countDownView():CountDownView
		{
			return _countDownView;
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
//			x = CommonConfig.GAME_WIDTH - PANEL_WIDTH;
//			y = Y;
			_sideView.move(CommonConfig.GAME_WIDTH - 206,190);
			_midBtnView.move(CommonConfig.GAME_WIDTH/2+95,CommonConfig.GAME_HEIGHT-245);
		}
		
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth,parent.stage.stageHeight));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_sideView)
			{
				_sideView.dispose();
				_sideView = null;
			}
			if(_midBtnView)
			{
				_midBtnView.dispose();
				_midBtnView = null;
			}
			if(_btnWeddingInvitation)
			{
				_btnWeddingInvitation.dispose();
				_btnWeddingInvitation = null;
			}
			if(_btnCheckGift)
			{
				_btnCheckGift.dispose();
				_btnCheckGift = null;
			}
			if(_btnPresentFreeCandies)
			{
				_btnPresentFreeCandies.dispose();
				_btnPresentFreeCandies = null;
			}
			if(_btnPresentGoodCandies)
			{
				_btnPresentGoodCandies.dispose();
				_btnPresentGoodCandies = null;
			}
			if(_btnPresentBetterCandies)
			{
				_btnPresentBetterCandies.dispose();
				_btnPresentBetterCandies = null;
			}
			
			if(_btnPresentBestCandies)
			{
				_btnPresentBestCandies.dispose();
				_btnPresentBestCandies = null;
			}
			if(_btnPresentSuperCandies)
			{
				_btnPresentSuperCandies.dispose();
				_btnPresentSuperCandies = null;
			}
			if(_freeAmount)
			{
				_freeAmount.dispose();
				_freeAmount = null;
			}
			_presentBtns = null;
			
			if(_bgSide)
			{
				_bgSide.dispose();
				_bgSide = null;
			}
			if(_btnLeave)
			{
				_btnLeave.dispose();
				_btnLeave = null;
			}
			if(_btnWeddingCeremony)
			{
				_btnWeddingCeremony.dispose();
				_btnWeddingCeremony = null;
			}
			_expAdd = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}