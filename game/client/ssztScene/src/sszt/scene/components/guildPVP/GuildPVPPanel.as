package sszt.scene.components.guildPVP
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPItemSocketHandler;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPQuitSocketHandler;
	import sszt.scene.socketHandlers.guildPVP.RewardCell;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.scene.FBSideBgTitleAsset;
	import ssztui.ui.ProgressBarExpAsset;
	
	public class GuildPVPPanel extends MSprite
	{
		private const REWARD_LIST:Array = [292700,292701,292702,292703,292704];
		private const REWARD_TIME:Array = [60,180,360,600,840];
//		private const REWARD_TIME:Array = [10,20,30,40,50];
		private const CELL_POINTS:Array = [109,89,69,49,25];
		private const WIDTH:int = 230;
		private const HEIGHT:int = 450;
		private const Y:int = 190;		
		private var _cellState:Array = [0,0,0,0,0];
		
		private var _bg:IMovieWrapper;
		private var _timeLabel:MAssetLabel;
		private var _guildLabel:MAssetLabel;
		private var _rewardTip:MAssetLabel;
		private var _rewardTipShape:MSprite;
		private var _tile:MTile;
		private var _btnQuit:MAssetButton1;
		private var _rewardCells:Array;
		private var _totalTime:int;
		private var _countDownView:CountDownView;
		private var _count:int;
		private var _pageArray:Array;
		private var _pageTitle:MAssetLabel;
		private var _progressBar:ProgressBar;
		
		public function GuildPVPPanel()
		{
			_rewardCells = [];
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
			
			var _proBg:Shape = new Shape();
			_proBg.graphics.beginFill(0x000000,0.5);
			_proBg.graphics.drawRect(0,0,208,10);
			_proBg.graphics.endFill();
			
			var pl:int = 22;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,252),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+25,137,158,13),_proBg),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,89,208,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,160,208,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,230,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,4,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.guildPVP.title"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,34,208,15),new MAssetLabel(LanguageManager.getWord("ssztl.guildPVP.guildOwner"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+7,222,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.leftTime"),MAssetLabel.LABEL_TYPE_TAG,"left")),
			]);
			addChild(_bg as DisplayObject);
			
			_guildLabel = new MAssetLabel('暂无', MAssetLabel.LABEL_TYPE_B14);
			_guildLabel.textColor = 0xffcc00;
			_guildLabel.move(pl+94, 54);
			addChild(_guildLabel);
			
			_rewardTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,"left");
			_rewardTip.move(pl+152,222);
			addChild(_rewardTip);
			_rewardTip.setHtmlValue("<u>" + LanguageManager.getWord("ssztl.bitBoss.rewardTip") + "</u>");
			
			_rewardTipShape = new MSprite();
			_rewardTipShape.graphics.beginFill(0,0);
			_rewardTipShape.graphics.drawRect(pl+152,222,52,16);
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
			_countDownView.move(pl+68, 222);
			addChild(_countDownView);
//			addChild(new BigBossWarResultPanel(true,0));
			
			_pageArray = new Array();
			for(var i:int=0; i<5; i++)
			{
				var dot:Sprite = new Sprite();
				dot.x = pl+95 + 8*i;
				dot.y = 105;
				addChild(dot);
				paintDot(dot,i==0?true:false);
				_pageArray.push(dot);				
			}
			_pageTitle = new MAssetLabel("阶段一", MAssetLabel.LABEL_TYPE20);
			_pageTitle.move(pl+94, 115);
			addChild(_pageTitle);
			
			
			_progressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset()),0,0,154,9,false,false);
			_progressBar.move(pl+27,139);
			addChild(_progressBar);
			
			_timeLabel = new MAssetLabel('', MAssetLabel.LABEL_TYPE1);
			_timeLabel.move(pl+104, 137);
			addChild(_timeLabel);
		}
		private function paintDot(obj:Sprite, select:Boolean):void
		{
			obj.graphics.clear();
			obj.graphics.beginFill(select?0x66ff33:0xffffff,1);
			obj.graphics.drawCircle(0,0,1.5);
			obj.graphics.endFill();
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
			GuildPVPQuitSocketHandler.send();
		}
		protected function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.guildPVP.awardTip"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		protected function tipOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		protected function itemCellClickHandler(e:MouseEvent):void
		{
			var cell:RewardCell = e.currentTarget as RewardCell;
			GuildPVPItemSocketHandler.send(cell.info.templateId);
			var index:int = _rewardCells.indexOf(cell);
			_rewardCells.splice(index,1);			
			index = REWARD_LIST.indexOf(cell.info.templateId);
			_cellState[index] = 1;
			cell.removeEventListener(MouseEvent.CLICK,itemCellClickHandler);
			cell.dispose();
			cell = null;
			updateCellPoint();
		}
		
		public function updateCellPoint():void
		{
			var x:int = CELL_POINTS[_rewardCells.length-1];
			for each(var cell:RewardCell in _rewardCells)
			{
				if(cell.visible == true)
				{
					cell.move(x,173);
					x = x+40;
				}
			}
		}
		
		public function updateReward(totalTime:int,list:Array):void
		{
			_totalTime = totalTime;
			if(list == null) return;
			var i:int=0;
			var x:int = 19;
			var cell:RewardCell;
			var index:int;
			for(i;i<list.length;i++)
			{
				index = REWARD_LIST.indexOf(list[i]);
				_cellState[index] = 1;
			}
			for(i=0;i<5;i++)
			{
				if(_cellState[i] == 0)
				{
					break;
				}
			}
			cell = new RewardCell();
			cell.info = ItemTemplateList.getTemplate(REWARD_LIST[i]);
			addChild(cell);
			_rewardCells.push(cell);
			cell.locked = true;
			updateCellState();
			updateProbar();
			updateCellPoint();
		}
		
		private function getWord(page:int):String
		{
			var re:String = "";
			switch(page)
			{
				case 0:re="阶段一";break;
				case 1:re="阶段二";break;
				case 2:re="阶段三";break;
				case 3:re="阶段四";break;
				case 4:re="阶段五";break;
			}
			return re;
		}
		
		private function updatePage(page:int):void
		{
			_pageTitle.setValue(getWord(page));
			for(var i:int=1;i<=page;i++)
				paintDot(_pageArray[i],true);
		}
		
		public function updateProbar():void
		{
			var time:int = _totalTime;
			var i:int = 0;
			for each(var t:int in REWARD_TIME)
			{
				_pageTitle.setValue(getWord(i));
				paintDot(_pageArray[i],true);
				i++;
				if(_totalTime<t)
				{	
					time = t;
					break
				}
			}
			_progressBar.setValue(time,_totalTime);
		}
		
		private function updateCellState():void
		{
			if(_rewardCells.length==0)
				return;
			var i:int=0,j:int=0;
			var cell:RewardCell;
			for(i;i<5;i++)
			{
				if(_cellState[i] == 0 && _totalTime >= REWARD_TIME[i])
				{
					_cellState[i] = 2;
					cell = _rewardCells[_rewardCells.length-1];
					cell.locked = false;
					cell.setEffect(true);
					cell.addEventListener(MouseEvent.CLICK,itemCellClickHandler);
					for(j=0;j<5;j++)
					{
						if(_cellState[j] == 0)
						{
							cell = new RewardCell();
							cell.info = ItemTemplateList.getTemplate(REWARD_LIST[j]);
							addChild(cell);
							cell.locked = true;
							_rewardCells.push(cell);
							break;
						}
					}
				}
			}
		}
		
		public function updateView(time:int):void
		{
			_totalTime = time;
			updateCellState();
			updateProbar();
			updateCellPoint();
			_timeLabel.setValue(LanguageManager.getWord("ssztl.guildPVP.guildTime",int(_totalTime/60),_totalTime%60));
		}
		
		public function updateNick(nick:String):void
		{			
			_guildLabel.setValue(nick);
		}
		
		public function updateCountDownView(seconds:int):void
		{
			_countDownView.start(seconds);
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
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_rewardCells)
			{
				for each(var cell:RewardCell in _rewardCells)
				{
					cell.removeEventListener(MouseEvent.CLICK,itemCellClickHandler);
					cell.dispose();
					cell = null;
				}
				_rewardCells = null;
			}
			_timeLabel = null;
			_guildLabel = null;
			_rewardTip = null;
			_rewardTipShape = null;
		}
	}
}