package sszt.scene.components.cityCraft
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CampType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.cityCraft.CityCraftEvent;
	import sszt.core.data.cityCraft.CityCraftRankItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.socketHandlers.cityCraft.CityCraftQuitSocketHandler;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPQuitSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.scene.FBSideBgTitleAsset;
	
	public class CityCraftPanel extends MSprite
	{
		private const WIDTH:int = 230;
		private const HEIGHT:int = 450;
		private const Y:int = 190;
		
		private var _bg:IMovieWrapper;
		private var _campLabel1:MAssetLabel;
		private var _campLabel2:MAssetLabel;
		private var _halidomLabel:MAssetLabel;
		private var _rankList:Array;
		private var _scoreList:Array;
		private var _myPointLabel:MAssetLabel;
		private var _rewardTip:MAssetLabel;
		private var _rewardTipShape:MSprite;
		private var _tile:MTile;
		private var _btnQuit:MAssetButton1;
		
		private var _countDownView:CountDownView;
		
		public function CityCraftPanel()
		{
			_rankList = [];
			_scoreList = [];
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			mouseEnabled = false;		
			gameSizeChangeHandler(null);
			
			var _background:Shape = new Shape();
			_background.graphics.beginFill(0x000000,0.5);
			_background.graphics.drawRect(0,0,208,10);
			_background.graphics.endFill();
			
			var pl:int = 22;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,310),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,89,208,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,150,208,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,230,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,4,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.title"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,33,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.campTitle"),MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,99,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.halidomHP"),MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,164,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.word1"),MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+7,256,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.myScore"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+7,278,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.leftTime"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,252,184,2),new MCacheSplit2Line()),
			]);
			addChild(_bg as DisplayObject);
			
			_campLabel1 = new MAssetLabel('', MAssetLabel.LABEL_TYPE_B14,"left");
			_campLabel1.textColor = 0xffcc00;
			_campLabel1.move(pl+24, 54);
			addChild(_campLabel1);
			_campLabel2 = new MAssetLabel('', MAssetLabel.LABEL_TYPE_B14,"right");
			_campLabel2.textColor = 0xffcc00;
			_campLabel2.move(pl+184, 54);
			addChild(_campLabel2);
			
			_halidomLabel = new MAssetLabel('', MAssetLabel.LABEL_TYPE_B14);
			_halidomLabel.textColor = 0xffcc00;
			_halidomLabel.move(pl+104, 120);
			addChild(_halidomLabel);
			
			var rankLabel:MAssetLabel;
			var scoreLabel:MAssetLabel;
			var rank:CityCraftRankItemInfo;
			for(var i:int =0;i< 3;i++)
			{
				rankLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				rankLabel.move(40,188+20*i);
				rankLabel.textColor = getRankColor(i);
				addChild(rankLabel);
				_rankList.push(rankLabel);
				
				scoreLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.RIGHT);
				scoreLabel.move(190,188+24*i);
				scoreLabel.textColor = getRankColor(i);
				addChild(scoreLabel);
				_scoreList.push(scoreLabel);
			}
			
			_myPointLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,"left");
			_myPointLabel.move(pl+72,256);
			addChild(_myPointLabel);
			_myPointLabel.setHtmlValue("0分");
			
			_rewardTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,"left");
			_rewardTip.move(pl+152,278);
			addChild(_rewardTip);
			_rewardTip.setHtmlValue("<u>" + LanguageManager.getWord("ssztl.bitBoss.rewardTip") + "</u>");
			
			_rewardTipShape = new MSprite();
			_rewardTipShape.graphics.beginFill(0,0);
			_rewardTipShape.graphics.drawRect(pl+152,278,52,16);
			_rewardTipShape.graphics.endFill();
			addChild(_rewardTipShape);
			
			_tile = new MTile(197,22,1);
			_tile.setSize(197,220);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.move(pl+5,50);
			addChild(_tile);
			
			_btnQuit = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnExitAsset") as MovieClip);
			_btnQuit.move(-40,10);
			addChild(_btnQuit);
			
			_countDownView = new CountDownView();
			_countDownView.setSize(100,15);
			_countDownView.move(pl+68, 278);
			addChild(_countDownView);
			_countDownView.start(GlobalData.cityCraftInfo.continueTime);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			_btnQuit.addEventListener(MouseEvent.CLICK,btnQuitClickHandler);			
			GlobalData.cityCraftInfo.addEventListener(CityCraftEvent.RELOAD_UPDATE,reloadHandler);
			_rewardTipShape.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_rewardTipShape.addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			_btnQuit.removeEventListener(MouseEvent.CLICK,btnQuitClickHandler);
			GlobalData.cityCraftInfo.removeEventListener(CityCraftEvent.RELOAD_UPDATE,reloadHandler);
			_rewardTipShape.removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_rewardTipShape.removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		
		protected function btnQuitClickHandler(event:MouseEvent):void
		{
			
			CityCraftQuitSocketHandler.send();
		}
		protected function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.cityCraft.awardTip"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		protected function tipOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		public function reloadHandler(e:CityCraftEvent):void
		{
			_countDownView.start(GlobalData.cityCraftInfo.continueTime);
		}
		
		public function updateRankList(HP:int,myPoint:int,myCamp:int,rankList:Array):void
		{
			_campLabel1.setHtmlValue(GlobalData.cityCraftInfo.attackGuild);
			_campLabel2.setHtmlValue(GlobalData.cityCraftInfo.defenseGuild);
			_halidomLabel.setHtmlValue(HP.toString());
			_myPointLabel.setHtmlValue(myPoint+"分");
			var rankLabel:MAssetLabel;
			var scoreLabel:MAssetLabel;
			var rank:CityCraftRankItemInfo;
			var i:int = 0;
			for(;i<rankList.length;i++)
			{
				rank = rankList[i];
				rankLabel = _rankList[i];
				rankLabel.setHtmlValue((i+1)+"、"+rank.nick);
				
				scoreLabel = _scoreList[i];
				scoreLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.minuteValue",rank.point));
			}
			for(;i<3;i++)
			{				
				rankLabel = _rankList[i];
				rankLabel.setHtmlValue("");
				
				scoreLabel = _scoreList[i];
				scoreLabel.setHtmlValue("");
			}
		}
		
		private function getRankColor(index:int):int
		{
			var color:int = 0xffcc00;
			switch(index)
			{	
				case 0:
					color = 0xcc00ff;
					break;
				case 1:
					color = 0x0ca1ff;
					break;
				case 2:
					color = 0x5dff1d;
					break;
			}
			return color;
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - WIDTH;
			y = Y;
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
			if(_btnQuit)
			{
				_btnQuit.dispose();
				_btnQuit = null;
			}
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView = null;
			}
			_rewardTip = null;
			_rewardTipShape = null;
		}
	}
}