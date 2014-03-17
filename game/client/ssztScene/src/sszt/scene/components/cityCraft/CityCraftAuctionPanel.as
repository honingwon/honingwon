package sszt.scene.components.cityCraft
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.cityCraft.CityCraftAuctionSocketHandler;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.cityCraft.CityCraftAuctionInfoSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;

	public class CityCraftAuctionPanel extends MPanel
	{
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _auctionBtn:MCacheAssetBtn1;
		private var _giveUpBtn:MCacheAssetBtn1;
		
		private var _priceLabel:MAssetLabel;
		private var _guildLabel:MAssetLabel;
		private var _myPriceLabel:MAssetLabel;
		private var _myGuildLabel:MAssetLabel;
		private var _topPriceLabel:MAssetLabel;
//		private var _tip:Sprite;
		
		public function CityCraftAuctionPanel(mediator:SceneMediator)
		{
			CityCraftAuctionInfoSocketHandler.send();
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.commonCityTitleAsset2"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.commonCityTitleAsset2") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(365,205);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,4,345,190)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(34,61,140,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(185,61,140,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,131,345,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(35,11,65,20),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.auctionTip"),MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(35,33,65,20),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.auctionNowPrice"),MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(186,33,65,20),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.auctionMyPrice"),MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(35,98,90,70),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.auctionLeftTime"),MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
						
			_auctionBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.cityCraft.auctionDo'));
			_auctionBtn.move(132,146);
			addContent(_auctionBtn);
			
			_priceLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.RIGHT);
			_priceLabel.textColor = 0xffcc00;
			_priceLabel.move(166,62);
			addContent(_priceLabel);
			
			_guildLabel = new MAssetLabel("一二三四五六七",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_guildLabel.textColor = 0xcc9966;
			_guildLabel.move(38,62);
			addContent(_guildLabel);
			
			_myPriceLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.RIGHT);
			_myPriceLabel.textColor = 0x33ff00;
			_myPriceLabel.move(317,62);	
			addContent(_myPriceLabel);
			
			_myGuildLabel = new MAssetLabel(GlobalData.selfPlayer.clubName+"：",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_myGuildLabel.textColor = 0xcc9966;
			_myGuildLabel.move(189,62);	
			addContent(_myGuildLabel);
			
			_topPriceLabel = new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.auctionLeadPrice"),MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_topPriceLabel.move(196,98);
			_topPriceLabel.visible = false;
			addContent(_topPriceLabel);	
			
//			_tip = new Sprite();
//			_tip.graphics.beginFill(0,0);
//			_tip.graphics.drawRect(35,11,65,20);
//			_tip.graphics.endFill();
//			addContent(_tip);
			
			updateAuction();			
		}
		private function initEvent():void
		{
			_auctionBtn.addEventListener(MouseEvent.CLICK,btnAuctionClickHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CITY_CRAFT_NEW_AUCTION,updateAuctionHandler);
//			_tip.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
//			_tip.addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		
		private function removeEvent():void
		{
			_auctionBtn.removeEventListener(MouseEvent.CLICK,btnAuctionClickHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CITY_CRAFT_NEW_AUCTION,updateAuctionHandler);
//			_tip.removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
//			_tip.removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		
		private function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.cityCraft.auctionTip1"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function btnAuctionClickHandler(event:MouseEvent):void
		{			
			CityCraftAuctionSocketHandler.send();
		}	
		
		private function updateAuctionHandler(event:SceneModuleEvent):void
		{			
			updateAuction();
		}
		public function updateAuction():void
		{
			var now:int = GlobalData.cityCraftInfo.nowPrice;
			var my:int = GlobalData.cityCraftInfo.selfPrice;
			var nick:String = GlobalData.cityCraftInfo.guildNick;
			if(now == my && now != 0)
			{
				_topPriceLabel.visible = true;
				_auctionBtn.enabled = false;
			}
			else
			{
				_topPriceLabel.visible = false;
				_auctionBtn.enabled = true;
			}
			if(nick.length < 1)
				nick = "暂无";
			_guildLabel.setHtmlValue(nick+"：");
			_priceLabel.setHtmlValue(now.toString());
			_myPriceLabel.setHtmlValue(my.toString());
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_auctionBtn)
			{
				_auctionBtn.dispose();
				_auctionBtn = null;
			}
			super.dispose();
		}
	}
}