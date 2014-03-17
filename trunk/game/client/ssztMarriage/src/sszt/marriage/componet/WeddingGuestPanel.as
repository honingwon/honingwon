package sszt.marriage.componet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.WeddingCandiesType;
	import sszt.core.manager.LanguageManager;
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
	
	import ssztui.marriage.DistributionBtnAsset1;
	import ssztui.marriage.DistributionBtnAsset2;
	import ssztui.marriage.DistributionBtnAsset3;
	import ssztui.marriage.DistributionBtnAsset4;
	import ssztui.marriage.FBSideBgTitleAsset;
	
	/**
	 * 婚礼宾客面板
	 * */
	public class WeddingGuestPanel extends MSprite
	{
		private var _sideView:MSprite;
		private var _midBtnView:MSprite;
		
		private var _btnCheckGift:MCacheAssetBtn1;
		private var _btnLeave:MCacheAssetBtn1;
		
		private var _btnPresentGoodCandies:MAssetButton1;
		private var _btnPresentBetterCandies:MAssetButton1;
		private var _btnPresentBestCandies:MAssetButton1;
		private var _btnPresentSuperCandies:MAssetButton1;
		private var _presentBtns:Array;
		
		private var _bgSide:IMovieWrapper;
		private var _countDownView:CountDownView;
		private var _expAdd:MAssetLabel;
		private var _tipLabel:MAssetLabel;
		private var _txtBridegroom:MAssetLabel;
		private var _txtBrideg:MAssetLabel;
		
		public function WeddingGuestPanel()
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
			
			mouseEnabled = false;		
			gameSizeChangeHandler(null);			
			
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
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,184,235),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,4,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.waddingLive"),MAssetLabel.LABEL_TYPE20)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,66,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.waddingCeremony"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,137,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.marry.weddingHostTip"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(85,75,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.groom")+"：",MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(85,95,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.bride")+"：",MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,158,184,2),new MCacheSplit2Line()),
			]);
			_sideView.addChild(_bgSide as DisplayObject);
			
			_countDownView = new CountDownView();
			_countDownView.setLabelType(new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),28,0xffff00,true,null,null,null,null,TextFormatAlign.CENTER));
			_countDownView.setSize(184,50);
			_countDownView.move(pl, 24);
			_sideView.addChild(_countDownView);
			
			_txtBridegroom = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			_txtBridegroom.move(117,75);
			_sideView.addChild(_txtBridegroom);
			
			_txtBrideg = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			_txtBrideg.move(117,95);
			_sideView.addChild(_txtBrideg);
			
			_expAdd = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_expAdd.move(121,118);
			_sideView.addChild(_expAdd);
			_expAdd.setHtmlValue(LanguageManager.getWord("ssztl.marry.weddingExpAdd",2000));
			
			_tipLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_tipLabel.move(pl+85,66);
			_sideView.addChild(_tipLabel);
//			_tipLabel.setHtmlValue(LanguageManager.getWord("ssztl.marriage.waddingCeremony"));
			
			_btnCheckGift = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marriage.onInviteFriend'));
			_btnCheckGift.move(80,170);
			_sideView.addChild(_btnCheckGift);
			
			_btnLeave = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.group.leaveTeamWord'));
			_btnLeave.move(80,198);
			_sideView.addChild(_btnLeave);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			
			_btnCheckGift.addEventListener(MouseEvent.CLICK,btnCheckGiftClickedHandler);
			_btnLeave.addEventListener(MouseEvent.CLICK,btnLeaveClickedHandler);
			
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
			
			_btnCheckGift.removeEventListener(MouseEvent.CLICK,btnCheckGiftClickedHandler);
			_btnLeave.removeEventListener(MouseEvent.CLICK,btnLeaveClickedHandler);
			
			for(var i:int=0; i<4; i++)
			{
				_presentBtns[i].removeEventListener(MouseEvent.CLICK, btnPresentCandiesClickedHandler);
				_presentBtns[i].removeEventListener(MouseEvent.MOUSE_OVER, btnPresentCandiesOverHandler);
				_presentBtns[i].removeEventListener(MouseEvent.MOUSE_OUT, tipOutHandler);
			}
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
		
//		public function updateText():void
//		{
//			_tipLabel.setHtmlValue(LanguageManager.getWord("ssztl.marriage.weddingEnd"));
//		}
		
		public function updateNewlywedsName(bridegroom:String,bride:String):void
		{
			_txtBridegroom.setValue(bridegroom);
			_txtBrideg.setValue(bride);
		}
		
		private function btnPresentCandiesOverHandler(evt:MouseEvent):void
		{
			var index:int = _presentBtns.indexOf(evt.currentTarget);
			var tip:String = "";
			switch(index)
			{
				case 0 :
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
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		protected function btnPresentCandiesClickedHandler(event:MouseEvent):void
		{
			var btn:MAssetButton1 = event.currentTarget as MAssetButton1;
			var type:int;
			switch(btn)
			{
				case _btnPresentGoodCandies :
					type = WeddingCandiesType.GOOD;
					break;
				case _btnPresentBetterCandies :
					type = WeddingCandiesType.BETTER;
					break;
				case _btnPresentBestCandies :
					type = WeddingCandiesType.BEST;
					break;
				case _btnPresentSuperCandies :
					type = WeddingCandiesType.SUPER;
					break;
			}
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.PRESENT_WEDDING_CANDIES,type));
		}
		
		protected function btnLeaveClickedHandler(event:MouseEvent):void
		{
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.LEAVE));
		}
		
		protected function btnCheckGiftClickedHandler(event:MouseEvent):void
		{
			dispatchEvent(new WeddingUIEvent(WeddingUIEvent.SHOW_WEDDING_CHECK_GIFT_PANEL));
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
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
			super.dispose();
		}
	}
}