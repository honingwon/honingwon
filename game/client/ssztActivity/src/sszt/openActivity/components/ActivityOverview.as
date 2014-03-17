package sszt.openActivity.components
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
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.progress.ProgressBar;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressBarGpAsset;
	import ssztui.ui.ProgressTrack2Asset;
	import ssztui.ui.ProgressTrackAsset;
	
	/**
	 * 活动总览 
	 * @author chendong
	 * 
	 */	
	public class ActivityOverview extends Sprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _cellList:Array;
		private var _tile:MTile;
		
		/**
		 * 标题 
		 */
		private var _titleLable:MAssetLabel;
		
		/**
		 * 剩余时间:0天0时0分
		 */
		private var _remainingTime:MAssetLabel;
		
		/**
		 * 活动介绍: 
		 */
		private var _activityIntro:MAssetLabel;
		
		/**
		 * 有用该类型的数量值 ,如:累计充值元宝数量:1
		 */
		private var _haveNumValue:MAssetLabel;
		
		/**
		 * 操作按钮 
		 */
		private var _operationBtn:MCacheAssetBtn1;
		
		private var _activityType:int = -1;
		
		private var pageSize:int = 10;

		
		public function ActivityOverview()
		{
			super();
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(308,8,178,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,80,302,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,306,302,25),new MCacheCompartLine2()),
			]); 
			addChild(_bg as DisplayObject);
			
			_cellList = [];
			_tile = new MTile(300,28,1);
			_tile.itemGapW = _tile.itemGapH = 0;
			_tile.setSize(300,196);
			_tile.move(4,100);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			 
			_titleLable = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_titleLable.move(0,0);
			addChild(_titleLable);
			
			_remainingTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_remainingTime.move(0,0);
			addChild(_remainingTime);
			
			_activityIntro = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_activityIntro.move(0,0);
			addChild(_activityIntro);
			
			_haveNumValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_haveNumValue.move(0,0);
			addChild(_haveNumValue);
			
			_operationBtn = new MCacheAssetBtn1(0,1,"");
			_operationBtn.move(0,0);
			addChild(_operationBtn);
		}
		
		public function initEvent():void
		{
			
		}
		
		public function setActivityData():void
		{
			switch(activityType)
			{
				case 0:  //充值礼包
					setActivityZero();
					break;
				case 1:  //消费礼包
					setActivityOne();
					break;
				case 2:  //冲级礼包
					setActivityThree();
					break;
			}
		}
		
		private function setActivityZero():void
		{
			clearData();
			var challItem:ActivityItemView;
			for(var i:int = 0;i < pageSize;i++)
			{
				challItem = new ActivityItemView();
				_tile.appendItem(challItem);
				_cellList.push(challItem);
			}
		}
		
		private function setActivityOne():void
		{
			clearData();
			var challItem:ActivityItemView;
			for(var i:int = 0;i < pageSize;i++)
			{
				challItem = new ActivityItemView();
				_tile.appendItem(challItem);
				_cellList.push(challItem);
			}
		}
		
		private function setActivityThree():void
		{
			clearData();
			var challItem:ActivityItemView;
			for(var i:int = 0;i < pageSize;i++)
			{
				challItem = new ActivityItemView();
				_tile.appendItem(challItem);
				_cellList.push(challItem);
			}
		}
		
		
		public function removeEvent():void
		{
			
		}
		
		
		public function initData():void
		{
			clearData();
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
			
		}

		public function get activityType():int
		{
			return _activityType;
		}

		public function set activityType(value:int):void
		{
			_activityType = value;
		}

	}
}