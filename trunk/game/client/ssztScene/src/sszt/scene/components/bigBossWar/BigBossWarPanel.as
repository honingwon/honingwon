package sszt.scene.components.bigBossWar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.bigBossWar.BigBossWarRankingItemInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.bigBossWar.BigBossWarQuitSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.scene.FBSideBgTitleAsset;
	
	public class BigBossWarPanel extends MSprite
	{
		private const WIDTH:int = 230;
		private const HEIGHT:int = 450;
		private const Y:int = 190;
		
		private var _bg:IMovieWrapper;
		private var _myPointLabel:MAssetLabel;
		private var _rewardTip:MAssetLabel;
		private var _rewardTipShape:MSprite;
		private var _tile:MTile;
		private var _btnQuit:MAssetButton1;
		
		private var _countDowView:CountDownView;
		
		public function BigBossWarPanel()
		{
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
			
			var _rowBg:Shape = new Shape();
			_rowBg.graphics.beginFill(0xcbb193,0.1);
			_rowBg.graphics.drawRect(0,0,197,22);
			_rowBg.graphics.drawRect(0,44,197,22);
			_rowBg.graphics.drawRect(0,88,197,22);
			_rowBg.graphics.drawRect(0,132,197,22);
			_rowBg.graphics.drawRect(0,176,197,22);
			_rowBg.graphics.endFill();
			
			var pl:int = 22;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,320),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+5,50,197,198),_rowBg),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,230,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,4,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.bitBoss.title"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,285,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.bitBoss.myHurt"),MAssetLabel.LABEL_TYPE_TAG,"left")),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,305,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.welfare.activityLeftTime"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,272,184,2),new MCacheSplit2Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+5,30,35,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.rank"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+41,30,85,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.playerName"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+127,30,75,15),new MAssetLabel(LanguageManager.getWord("ssztl.bitBoss.hurtExport"),MAssetLabel.LABEL_TYPE_TITLE2)),
			]);
			addChild(_bg as DisplayObject);
			
			_myPointLabel = new MAssetLabel('', MAssetLabel.LABEL_TYPE20,'left');
			_myPointLabel.move(pl+72, 285);
			addChild(_myPointLabel);
			
			_rewardTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,"left");
			_rewardTip.move(pl+152,285);
			addChild(_rewardTip);
			_rewardTip.setHtmlValue("<u>" + LanguageManager.getWord("ssztl.bitBoss.rewardTip") + "</u>");
			
			_rewardTipShape = new MSprite();
			_rewardTipShape.graphics.beginFill(0,0);
			_rewardTipShape.graphics.drawRect(pl+152,285,52,16);
			_rewardTipShape.graphics.endFill();
			addChild(_rewardTipShape);
			
			_tile = new MTile(197,22,1);
			_tile.setSize(197,220);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.move(pl+5,50);
			addChild(_tile);
			
			var i:int;
			var item:BigBossWarRankingItemView;
			for(i=0;i<10;i++)
			{
				item = new BigBossWarRankingItemView();
				_tile.appendItem(item);
			}
			
			_btnQuit = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnExitAsset") as MovieClip);
			_btnQuit.move(-40,10);
			addChild(_btnQuit);
			
			_countDowView = new CountDownView();
			addChild(_countDowView);
			
//			addChild(new BigBossWarResultPanel(true,0));
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			_btnQuit.addEventListener(MouseEvent.CLICK,btnQuitClickHandler);
			
			_rewardTipShape.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_rewardTipShape.addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			_btnQuit.removeEventListener(MouseEvent.CLICK,btnQuitClickHandler);
			
			_rewardTipShape.removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_rewardTipShape.removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		
		protected function btnQuitClickHandler(event:MouseEvent):void
		{
			BigBossWarQuitSocketHandler.send();
		}
		protected function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.bitBoss.rewardTipCont"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		protected function tipOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function updateView(damageRank:Array,myDamage:int,totalDamage:int,nick:String):void
		{
			clearView();
			_myPointLabel.setValue(myDamage.toString());
			var viewList:Array = _tile.getItems();
			var viewItem:BigBossWarRankingItemView;
			var itemInfo:BigBossWarRankingItemInfo;
			for(var i:int = 0; i < damageRank.length; i++)
			{
				itemInfo = damageRank[i];
				viewItem = viewList[i];
				viewItem.updateView(itemInfo,totalDamage,nick);
			}
		}
		
		private function clearView():void
		{
			_myPointLabel.setValue('');
			var viewList:Array = _tile.getItems();
			var viewItem:BigBossWarRankingItemView;
			for(var i:int = 0; i < viewList.length; i++)
			{
				viewItem = viewList[i];
				viewItem.clearView();
			}
		}
		
		public function updateCountDownView(seconds:int):void
		{
			_countDowView.start(seconds);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - WIDTH;
			y = Y;
		}
		
		override public function dispose():void
		{
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
			if(_countDowView)
			{
				_countDowView.dispose();
				_countDowView = null;
			}
			_rewardTip = null;
			_rewardTipShape = null;
		}
	}
}