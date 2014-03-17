package sszt.target.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.target.events.AchievementEvent;
	import sszt.target.socketHandlers.AchievementUpdateNumSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.progress.ProgressBar;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.target.BarAchAllAsset;
	import ssztui.target.TagAchAllAsset;
	import ssztui.target.TagSoonAsset;
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressBarGpAsset;
	import ssztui.ui.ProgressTrack2Asset;
	import ssztui.ui.ProgressTrackAsset;
	
	/**
	 * 成就总览 
	 * @author chendong
	 * 
	 */	
	public class AchOverview extends Sprite implements IPanel
	{
		private var _sideBg:Bitmap;
		private var _bg:IMovieWrapper;
		
		private var _cellList:Array;
		private var _tile:MTile;
		
		/**
		 * 成就进度
		 */
		private var _progressBar:ProgressBar1;

		/**
		 *  已获得绑定元宝de进度条
		 */
		private var _getBindedYunbaoProgressBar:ProgressBar;
		
		/**
		 * 已获生命上线de进度条
		 */
		private var _getHpTopProgressBar:ProgressBar;
		
		/**
		 * 获得成就点数：
		 */		
		private var _achTotalNum:MAssetLabel;
		
		/**
		 * 成就排行榜
		 */
		private var _rankBtn:MCacheAssetBtn1;
		
		/**
		 * 已获得绑定元宝 元宝总数
		 */
		private var _completedYuanbaoNum:int = 0;
		/**
		 *元宝总数
		 */
		private var _YuanbaoNum:int = 0;
		/**
		 * 已获生命上限 
		 */
		private var _completedHPNum:int = 0;
		/**
		 * 生命上限总数
		 */
		private var _HPNum:int = 0;
		
		/**
		 * 当前获得总成就点数
		 */
		private var _totalAchNum:int = 0;
		
		/**
		 * 最近获得成就 
		 */		
		private var _achRight:AchRight;
		
		/**
		 * 成就完成总数
		 */
		private var _completedAchNum:int = 0;
		
		/**
		 * 成就总数
		 */
		private var _AchTotalNum:int = 0;
		
		public function AchOverview()
		{
			super();
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_sideBg = new Bitmap();
			_sideBg.x = _sideBg.y = 1;
			addChild(_sideBg);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(308,8,178,26)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(42,27,66,15),new Bitmap(new TagAchAllAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(340,12,120,17),new Bitmap(new TagSoonAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,80,302,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,306,302,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(121,322,157,17),new ProgressTrackAsset()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(121,348,157,17),new ProgressTrackAsset()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,25,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.target.achAllPoint"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,322,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.target.achOv1"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,348,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.target.achOv2"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
			]); 
			addChild(_bg as DisplayObject);
			
			_achTotalNum = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2);
			_achTotalNum.setLabelType([new TextFormat("Tahoma",19,0xffcc33,true)]);
			_achTotalNum.move(154,20);
			addChild(_achTotalNum);
//			_achTotalNum.setValue("526");
			
			_progressBar = new ProgressBar1(new Bitmap(new BarAchAllAsset() as BitmapData),0,0,232,13,true,false);
			_progressBar.move(37,63);
			addChild(_progressBar);
//			_progressBar.setValue(100, 50);
				
			_tile = new MTile(300,28,1);
			_tile.itemGapW = _tile.itemGapH = 0;
			_tile.setSize(300,224);
			_tile.move(4,86);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_getBindedYunbaoProgressBar = new ProgressBar(new Bitmap(new ProgressBarGpAsset()),0,0,151,11,true,false);
			_getBindedYunbaoProgressBar.move(124,325);
			addChild(_getBindedYunbaoProgressBar);
			
			_getHpTopProgressBar = new ProgressBar(new Bitmap(new ProgressBarGpAsset()),0,0,151,11,true,false);
			_getHpTopProgressBar.move(124,351);
			addChild(_getHpTopProgressBar);
			
			_rankBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.rank.achieveRank"));
			_rankBtn.move(207,19);
			addChild(_rankBtn);
			
			_cellList = [];
			
			
			//最近获得的成就
			_achRight = new AchRight();
			_achRight.move(308,35);
			addChild(_achRight);
		}
		
		public function initEvent():void
		{
			_rankBtn.addEventListener(MouseEvent.CLICK,openRank);
			ModuleEventDispatcher.addModuleEventListener(AchievementEvent.UPDATE_ACH_NUM,updateAchNum);
		}
		
		public function removeEvent():void
		{
			_rankBtn.removeEventListener(MouseEvent.CLICK,openRank);
			ModuleEventDispatcher.removeModuleEventListener(AchievementEvent.UPDATE_ACH_NUM,updateAchNum);
		}
		
		private function getAchInt(currentType:int):void
		{
			var achInfo:TargetTemplatInfo;
			var achTemplateArray:Array = TargetUtils.getAchTemplateData(currentType);
			var targetData:TargetData = null;
			//完成已领取
			for each (achInfo in achTemplateArray)
			{
				targetData = GlobalData.targetInfo.achByIdDic[achInfo.target_id];
				if(targetData && targetData.isFinish && targetData.isReceive)
				{
					_completedYuanbaoNum += achInfo.bindYuanbao;
					_completedHPNum += int(achInfo.attribute);
					_totalAchNum += int(achInfo.achievement);
					_completedAchNum ++;
				}
			}
			
			for each (achInfo in achTemplateArray)
			{
				_YuanbaoNum += achInfo.bindYuanbao;
				_HPNum += int(achInfo.attribute);
				_AchTotalNum++;
			}
		}
		
		private function openRank(evt:MouseEvent):void
		{
			SetModuleUtils.addRank();
		}
		
		private function updateAchNum(evt:ModuleEvent):void
		{
//			_progressBar.setValue(int(evt.data.totalNum),int(evt.data.currentNum));
//			_progressBar.setValue(100, 50);
		}
		
		public function initData():void
		{
			clearData();
			var overviewItemView:OverviewItemView;
			for(var i:int = 1;i<= TargetUtils.ACH_TYPE_NUM;i++)
			{
				overviewItemView = new OverviewItemView(i);
				_cellList.push(overviewItemView);
				_tile.appendItem(overviewItemView);
			}
			
			for(i = 1;i<= TargetUtils.ACH_TYPE_NUM;i++)
			{
				getAchInt(i); 
			}
			_getBindedYunbaoProgressBar.setValue(_YuanbaoNum,_completedYuanbaoNum);
			_getHpTopProgressBar.setValue(_HPNum,_completedHPNum);
			_achTotalNum.setValue(_totalAchNum.toString());
//			_progressBar.setValue(GlobalData.targetInfo._achTotalNum, GlobalData.targetInfo._achCurrentNum);
			_progressBar.setValue(_AchTotalNum, _completedAchNum);
			
			_achRight.initData();
		}
		
		public function clearData():void
		{
			var i:int = 0;
			if (_cellList)
			{
				i = 0;
				while (i < _cellList.length)
				{
					
					_cellList[i].dispose();
					i++;
				}
				_cellList = [];
			}
			if(_tile)
			{
				_tile.disposeItems();
			}
			
			_totalAchNum = 0;
			_AchTotalNum = 0;
			_completedAchNum = 0;
			
			_YuanbaoNum = 0;
			_completedYuanbaoNum = 0;
			
			_HPNum = 0;
			_completedHPNum = 0;
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			clearData();
			removeEvent();
		}
		
		public function assetsCompleteHandler():void
		{
			_sideBg.bitmapData = AssetUtil.getAsset("ssztui.target.BgAchAsset",BitmapData) as BitmapData;
		}
	}
}