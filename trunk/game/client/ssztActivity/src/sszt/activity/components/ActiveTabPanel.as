package sszt.activity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.activity.components.itemView.ActiveItemView;
	import sszt.activity.components.itemView.ActiveRewardsItemView;
	import sszt.activity.data.ActivityInfo;
	import sszt.activity.data.itemViewInfo.ActiveItemInfo;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.activity.socketHandlers.PlayerActiveAwardSocketHandler;
	import sszt.activity.socketHandlers.PlayerActiveInfoSocketHandler;
	import sszt.activity.socketHandlers.PlayerActiveStateSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveRewardsTemplateInfo;
	import sszt.core.data.activity.ActiveRewardsTemplateInfoList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.activity.ActiveBarAsset;
	import ssztui.activity.ActiveIntervalAsset;
	import ssztui.activity.ActiveTrackrAsset;
	import ssztui.activity.BarBgAsset;
	import ssztui.yellowVip.BtnGetRewardAsset;
	
	/**
	 * ‘每日活动’面板下‘活跃度’选项卡
	 */
	public class ActiveTabPanel extends Sprite implements IActivityTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ActivityMediator;
		private var _activeItemViewList:Array;
		private var _rewardsItemViewList:Array;
		
		private var _itemViewMTile:MTile;
		private var _progressBar:ProgressBar1;
		private var _btnGetRewards:MAssetButton1;
		
		private var _canGetRewards:Boolean;
		
		private var _aciveValue:MAssetLabel;
		private var _giftView:MSprite;
		public static var COLWidth:Array = [240,80,80,100,80];
		
		public function ActiveTabPanel(argMediator:ActivityMediator)
		{
			_mediator = argMediator;
			super();
			initView();
			initTemplateData();
			initEvents();
		}
		
		private function initView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+COLWidth[i]:COLWidth[0]+i*2);
			}
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,600,139)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,142,600,241)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(6,145,594,24)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5+colX[0],146,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5+colX[1],146,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5+colX[2],146,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5+colX[3],146,2,22),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,199,594,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,229,594,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,259,594,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,289,594,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,319,594,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,349,594,2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,17,594,26),new Bitmap(new BarBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(40,54,524,20),new ActiveTrackrAsset()),
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6,149,COLWidth[0],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityName"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[0],149,COLWidth[1],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[1],149,COLWidth[2],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.times"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[2],149,COLWidth[3],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityDegree"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(225,23,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityDegree3"),MAssetLabel.LABEL_TYPE_TITLE2,"left")));
		
			_activeItemViewList = [];
			_rewardsItemViewList = [];
			
			_itemViewMTile = new MTile(594,30);
			_itemViewMTile.itemGapH = _itemViewMTile.itemGapW = 0;
			_itemViewMTile.setSize(594,210);
			_itemViewMTile.move(6,170);
			addChild(_itemViewMTile);
			_itemViewMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemViewMTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_itemViewMTile.verticalScrollBar.lineScrollSize = 30;
			
			var barMc:MovieClip = new ActiveBarAsset() as MovieClip;
			barMc.width = 520;
			
			_progressBar = new ProgressBar1(barMc,0,0,520,15,false,false);
			_progressBar.move(42,56);
			addChild(_progressBar);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(81,56,443,15),new Bitmap(new ActiveIntervalAsset())));
			
			_aciveValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_aciveValue.setLabelType([new TextFormat("Tahoma",18,0xffdf91,true)]);
			_aciveValue.move(320,17);
			addChild(_aciveValue);
			
			_giftView = new MSprite();
			_giftView.move(42,73);
			addChild(_giftView);
			
			_btnGetRewards = new MAssetButton1(new BtnGetRewardAsset() as MovieClip);
			_btnGetRewards.label = LanguageManager.getWord('ssztl.common.getAward');
			_btnGetRewards.move(475,15);
			addChild(_btnGetRewards);
			_btnGetRewards.enabled = false;
		}
		
		private function initTemplateData():void
		{
			for each(var i:ActiveRewardsTemplateInfo in ActiveRewardsTemplateInfoList.list)
			{
				var item:ActiveRewardsItemView = new ActiveRewardsItemView(i);
				_rewardsItemViewList.push(item);
//				_rewardsItemViewMTile.appendItem(item);
				_giftView.addChild(item);
			}
		}
		
		private function initEvents():void
		{
			activityInfo.addEventListener(ActivityInfoEvents.ACTIVE_REWARDS_STATE_UPDATE,activeRewardsStateUpdateHandler);
			activityInfo.addEventListener(ActivityInfoEvents.ACTIVE_DATA_UPDATE,activeDataUpdateHandler);
			activityInfo.addEventListener(ActivityInfoEvents.GET_REWARDS_SUCCESS,getRewardsSuccessHandler);
			_btnGetRewards.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvnets():void
		{
			activityInfo.removeEventListener(ActivityInfoEvents.ACTIVE_REWARDS_STATE_UPDATE,activeRewardsStateUpdateHandler);
			activityInfo.removeEventListener(ActivityInfoEvents.ACTIVE_DATA_UPDATE,activeDataUpdateHandler);
			activityInfo.removeEventListener(ActivityInfoEvents.GET_REWARDS_SUCCESS,getRewardsSuccessHandler);
			_btnGetRewards.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function getRewardsSuccessHandler(e:Event):void
		{
			_btnGetRewards.enabled = false;
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			if(_canGetRewards)
			{
				PlayerActiveAwardSocketHandler.send();
			}
			_canGetRewards = false;
			_btnGetRewards.enabled = false;
		}
		
		private function activeRewardsStateUpdateHandler(e:Event):void
		{
			var activeRewardsStateInfo:Dictionary = _mediator.moduel.activityInfo.activeRewardsStateInfo;
			var itemState:Boolean;
			var item:ActiveRewardsItemView;
			for(var id:String in activeRewardsStateInfo)
			{
				if(activeRewardsStateInfo[id])
				{
					item = getActiveRewardsItemView(int(id));
					if(item)
					{
						item.canGet = false;
						item.got = true;
					}
				}
			}
			
			PlayerActiveInfoSocketHandler.send();
		}
		
		private function activeDataUpdateHandler(e:Event):void
		{
			var activeMyNum:int = activityInfo.activeMyNum;
			//根据已经获取的活跃度计算哪些奖励可以领取，并提示给用户。
			var i:int;
			var activeRewardsItemView:ActiveRewardsItemView 
			for(i = 0; i < _rewardsItemViewList.length; i++)
			{
				activeRewardsItemView = _rewardsItemViewList[i];
				//如果奖励需求活跃度小于等于已经获取的活跃度  并且
				//此活跃度奖励状态不是已经获取
				if(activeRewardsItemView.rewardsInfo.needActive <= activeMyNum && !activeRewardsItemView.got)
				{
					activeRewardsItemView.canGet = true;
					_canGetRewards = true;
				}
			}
			if(_canGetRewards)
			{
				_btnGetRewards.enabled = true;
			}
			
			clearActiveItemViewList();
			
			var selfLevel:int = GlobalData.selfPlayer.level;
			var activeItemView:ActiveItemView;
			var activeItemInfo:ActiveItemInfo;
			var activeSum:int = 0;
			var list:Dictionary = activityInfo.activeItemList;
			for each(activeItemInfo in list)
			{
				activeItemView = new ActiveItemView(_mediator,activeItemInfo);
				_itemViewMTile.appendItem(activeItemView);
				_activeItemViewList.push(activeItemView);
				activeSum += activeItemInfo.activeTemplateInfo.activeNum;
			}
			
			_itemViewMTile.sortOn(['sortAttrEnable', 'sortAttrMinlevel'],[Array.NUMERIC, Array.NUMERIC]);
//			for(var j:int = 0;j<list.length;j++)
//			{
//				activeItemInfo = list[j];
////				if(activeItemInfo.activeTemplateInfo.type == ActiveType.ACTIVE_TASK)
////				{
////					var taskId:int = activeItemInfo.activeTemplateInfo.others;
////					var task:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(taskId);
////					var matchCareer:Boolean = ((task.needCareer == -1)||(GlobalData.selfPlayer.career == task.needCareer));
////					var matchClub:Boolean = task.type != TaskType.CLUB || (task.type == TaskType.CLUB && GlobalData.selfPlayer.clubId != 0);
////					if(selfLevel < task.minLevel || selfLevel > task.maxLevel || !matchCareer || !matchClub) continue;
////				}
////				if(activeItemInfo.activeTemplateInfo.type == ActiveType.ACTIVE_COPY)
////				{
////					var copyId:int = activeItemInfo.activeTemplateInfo.others;
////					var copy:CopyTemplateItem = CopyTemplateList.getCopy(copyId);
////					if(selfLevel < copy.minLevel || selfLevel > copy.maxLevel) continue;
////				}
//				activeItemView = new ActiveItemView(_mediator,activeItemInfo);
//				_itemViewMTile.appendItem(activeItemView);
//				_activeItemViewList.push(activeItemView);
//				activeSum += activeItemInfo.activeTemplateInfo.activeNum;
//			}
//			
			_progressBar.setValue(activeSum, activeMyNum)
			_aciveValue.setHtmlValue(activeMyNum.toString());
		}
		
		private function clearActiveItemViewList():void
		{
			_activeItemViewList.length = 0;
			_itemViewMTile.disposeItems();
		}
		
		private function clearActiveRewardsItemViewList():void
		{
			_rewardsItemViewList.length = 0;
			
			while(_giftView && _giftView.numChildren>0) _giftView.removeChildAt(0);
		}
		
		private function getActiveRewardsItemView(id:int):ActiveRewardsItemView
		{
			var ret:ActiveRewardsItemView;
			for each(var item:ActiveRewardsItemView in _rewardsItemViewList)
			{
				if(item.rewardsInfo.id == id)
				{
					ret = item;
					break;
				}
			}
			return ret;
		}
		
		private function get activityInfo():ActivityInfo
		{
			return _mediator.moduel.activityInfo;
		}
		
		public function show():void
		{
			PlayerActiveStateSocketHandler.send();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvnets();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for(var i:int = 0;i < _activeItemViewList.length;i++)
			{
				_activeItemViewList[i].dispose();
				_activeItemViewList[i] = null;
			}
			_activeItemViewList = null;
			for(var j:int = 0;j < _rewardsItemViewList.length;j++)
			{
				_rewardsItemViewList[j].dispose();
				_rewardsItemViewList[j] = null;
			}
			_rewardsItemViewList = null;
			if(_giftView)
			{
				while(_giftView && _giftView.numChildren>0) _giftView.removeChildAt(0);
				_giftView = null;
			}
			if(_itemViewMTile)
			{
				_itemViewMTile.dispose();
				_itemViewMTile = null;
			}
			
			if(_progressBar)
			{
				_progressBar.dispose();
				_progressBar = null;
			}
			if(_btnGetRewards)
			{
				_btnGetRewards.dispose();
				_btnGetRewards = null;
			}
			_aciveValue = null;
		}
	}
}