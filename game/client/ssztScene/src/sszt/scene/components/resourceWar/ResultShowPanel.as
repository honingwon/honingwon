package sszt.scene.components.resourceWar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import sszt.constData.CampType;
	import sszt.constData.ShopID;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pvp.ActiveResourceWarLeaveSocketHandler;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.resourceWar.item.GoodsCell;
	import sszt.scene.data.resourceWar.ResourceWarCampRankItemInfo;
	import sszt.scene.socketHandlers.resourceWar.ResourceWarCampChangeSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.scene.DotaTextWinAsset;
	import ssztui.scene.DotaTitleResultAsset;
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class ResultShowPanel extends MPanel
	{
		private static var _instance:ResultShowPanel;
		
		private var _bg:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _bgLayoutPath:String;
		private var _btnConfirm:MCacheAssetBtn1;
		
		private const CONTENT_WIDTH:int = 326;
		private const CONTENT_HEIGHT:int = 390;
		
		private var _sorceList:Array;
		private var _iconWin:Bitmap;
		private var _tile:MTile;
		
		private var _timer:Timer;
		
		private var _myCamp:MAssetLabel;
		private var _rewardTip:MAssetLabel;
		private var _gxReward:MAssetLabel;
		
		public function ResultShowPanel()
		{
			super(new Bitmap(new DotaTitleResultAsset()),true,-1,true,true);
		}
		
		public static function getInstance():ResultShowPanel
		{
			if (_instance == null){
				_instance = new ResultShowPanel();
			};
			return (_instance);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(CONTENT_WIDTH, CONTENT_HEIGHT);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,302,335)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,340,346,25),new Bitmap(new SplitCompartLine2())),
			]);
			addContent(_bg as DisplayObject);
			
			_bgLayout = new Bitmap();
			_bgLayout.x = 14;
			_bgLayout.y = 8;
			addContent(_bgLayout);
			
			_bgLayoutPath = GlobalAPI.pathManager.getBannerPath("dotaResultBg.jpg");
			GlobalAPI.loaderAPI.getPicFile(_bgLayoutPath, loadBgComplete,SourceClearType.NEVER);
			
			_sorceList = [];
			for(var i:int = 0; i<3; i++)
			{
				var t:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
				t.move(78+87*i,189);
				addContent(t);
				_sorceList.push(t);
			}
			_iconWin = new Bitmap(new DotaTextWinAsset());
			_iconWin.y = 77;
			addContent(_iconWin);
			
			_myCamp = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_myCamp.move(163,42);
			addContent(_myCamp);
			
			_tile = new MTile(50,50,4);
			_tile.setSize(212, 50);
			_tile.move(117,252);
			_tile.itemGapH = _tile.itemGapW = 3;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_tile);
			
			_gxReward = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,"left");
			_gxReward.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),18,0xffcc00,true)]);
			_gxReward.move(185,265);
			addContent(_gxReward);
			_gxReward.setHtmlValue(LanguageManager.getWord("ssztl.common.pvpExploit") + "+50");
			
			_rewardTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_rewardTip.move(111,312);
			addContent(_rewardTip);
			_rewardTip.setValue(LanguageManager.getWord("ssztl.resourceWar.getRewardTip"));
			
			_btnConfirm = new MCacheAssetBtn1(0, 3,LanguageManager.getWord('ssztl.resourceWar.quit'));
			_btnConfirm.move(138,350);
			addContent(_btnConfirm);
			
			_btnConfirm.addEventListener(MouseEvent.CLICK,btnClickHandler);
			
			_timer = new Timer(1000,60);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.start();
		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			var n:int = 20 - _timer.currentCount;
			if(n <= 0)
				btnClickHandler(null);
			else
			_btnConfirm.label = LanguageManager.getWord('ssztl.resourceWar.quitN',n.toString());
			
		}
		
		protected function btnClickHandler(event:MouseEvent):void
		{
			dispose();
		}
		
		public function show(winningCampType:int, campRankList:Array, myRewards:Array, exploit:int):void
		{
			_iconWin.x = 36+87*(winningCampType - 1);
			
			_myCamp.setValue(CampType.getCampName(GlobalData.selfPlayer.camp));
			
			campRankList.sortOn(['campType'],[Array.NUMERIC]);
			var pointLabelItem:MAssetLabel;
			var campRankItem:ResourceWarCampRankItemInfo;
			var i:int;
			for(i = 0; i < _sorceList.length; i++)
			{
				pointLabelItem = _sorceList[i];
				campRankItem = campRankList[i];
				pointLabelItem.setValue(campRankItem.totalPoint.toString());
			}
			
			var itemTemplateInfo:ItemTemplateInfo;
			var cell:ResourceWarRewardCell;
			for(i = 0; i < myRewards.length; i++)
			{
				itemTemplateInfo = ItemTemplateList.getTemplate(myRewards[i])
				cell = new ResourceWarRewardCell();
				cell.info = itemTemplateInfo;
				_tile.appendItem(cell);
			}
			_tile.x = Math.round((111 - 53*myRewards.length)/2) + 40;
			
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}else
			{
				dispose();
			}
			
			_gxReward.setHtmlValue(LanguageManager.getWord("ssztl.common.pvpExploit") + "+"+exploit);
		}
		private function loadBgComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
		}
		
		override public function dispose():void
		{
			ActiveResourceWarLeaveSocketHandler.send();
			_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			_btnConfirm.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			GlobalAPI.loaderAPI.removeAQuote(_bgLayoutPath,loadBgComplete);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgLayout)
			{
				_bgLayout = null;
			}
			if(_iconWin && _iconWin.bitmapData)
			{
				_iconWin.bitmapData.dispose();
				_iconWin = null;
			}
			if(_btnConfirm)
			{
				_btnConfirm.dispose();
				_btnConfirm = null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			_gxReward= null;
			_rewardTip = null;
			_myCamp = null;
			_sorceList = null;
			_bgLayoutPath = null;
			_instance = null;
			super.dispose();
		}
	}
}