package sszt.task.components.sec
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAccordion;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.container.accordionItems.AccordionGroupItemView;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.task.TaskAccordionData;
	import sszt.core.data.task.TaskEntrustItemInfo;
	import sszt.core.data.task.TaskType;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.task.TaskTrustSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.task.components.sec.items.TaskEntrustItem;
	import sszt.task.events.TaskInnerEvent;
	import sszt.task.mediators.TaskMediator;
	
	public class TaskEntrustPanel extends MSprite implements ITaskMainPanel
	{
		private var _mediator:TaskMediator;
		private var _bg:IMovieWrapper;
		private var _listView:MAccordion;
		private var _selectAllBtn:MCacheAsset1Btn,_enstrustBtn:MCacheAsset1Btn,_finishBtn:MCacheAsset1Btn;
		private var _tile:MTile;
//		private var _list:Vector.<TaskEntrustItem>;
		private var _list:Array;
		private var _infoList:Array;
		private var _Yuanbao:MAssetLabel,_needYuanbao:MAssetLabel;
		private var _yuanbao:int;
		
		private const PAGESIZE:int = 10;
		
		public function TaskEntrustPanel(mediator:TaskMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(155,5,605,280)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(155,5,607,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(271,7,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(347,7,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(422,7,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(485,7,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(555,7,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(625,7,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(690,7,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,48,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,73,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,98,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,123,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,148,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,173,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,198,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,223,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,248,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(158,273,600,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(218,300,132,19)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(449,300,132,19))
			]);
			addChild(_bg as DisplayObject);
			
			var labels:Array = [LanguageManager.getWord("ssztl.common.taskName"),
				LanguageManager.getWord("ssztl.common.finishTimes"),
				LanguageManager.getWord("ssztl.scene.expAward"),
				LanguageManager.getWord("ssztl.task.lifeExpAward"),
				LanguageManager.getWord("ssztl.task.bindCopperAward"),
				LanguageManager.getWord("ssztl.common.time"),
				LanguageManager.getWord("ssztl.task.yuanBaoCost"),
				LanguageManager.getWord("ssztl.common.state"),
				LanguageManager.getWord("ssztl.sszt.common.leftYuanBao") ,
				LanguageManager.getWord("ssztl.task.yuanBaoCost")];
			
			var poses:Array = [new Point(193,7),new Point(287,7),new Point(363,7),new Point(433,7),
				new Point(495,7),new Point(580,7),new Point(636,7),new Point(700,7),new Point(155,301),new Point(387,301)];
			for(var i:int = 0; i < labels.length; i++)
			{
				var label:MAssetLabel = new MAssetLabel(labels[i],MAssetLabel.LABELTYPE14);
				label.move(poses[i].x,poses[i].y);
				addChild(label);
			}
			
			_Yuanbao = new MAssetLabel("0",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
			_Yuanbao.move(223,301);
			addChild(_Yuanbao);
			_Yuanbao.setValue(String(GlobalData.selfPlayer.userMoney.yuanBao));
			_needYuanbao = new MAssetLabel("0",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
			_needYuanbao.move(454,301);
			addChild(_needYuanbao);
			
			_selectAllBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.selectAll"));
			_selectAllBtn.move(30,296);
			addChild(_selectAllBtn);
			
			_enstrustBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.task.startEntrust"));
			_enstrustBtn.move(680,296);
			addChild(_enstrustBtn);
			_enstrustBtn.enabled = false;
			
			_finishBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.task.finishRightNow"));
			_finishBtn.move(595,296);
			addChild(_finishBtn);
			_finishBtn.enabled = false;
			
			_listView = new MAccordion(GlobalData.taskInfo.getCanEntrustTasks(),135,-1);
			_listView.setSize(153,278);
			_listView.move(0,4);
			_listView.verticalScrollPolicy = "on";
			addChild(_listView);
			_listView.setSelectedGroup(0);
			
//			_list = new Vector.<TaskEntrustItem>();
			_list = [];
			_infoList = [];
			_tile = new MTile(600,18);
			_tile.move(160,28);
			_tile.setSize(600,243);
			_tile.itemGapH = 7;
			_tile.horizontalScrollPolicy = "off";
			_tile.verticalScrollBar.lineScrollSize = 25;
			addChild(_tile);
			
			createList();
		}
		
		private function initEvent():void
		{
			_listView.addEventListener(MAccordion.ITEM_SELECT,itemSelectHandler);
			_enstrustBtn.addEventListener(MouseEvent.CLICK,enstrustBtnClickHandler);
			_finishBtn.addEventListener(MouseEvent.CLICK,finishBtnClickHandler);
			_selectAllBtn.addEventListener(MouseEvent.CLICK,allBtnClickHandler);
//			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
		}
		
		private function removeEvent():void
		{
			_listView.removeEventListener(MAccordion.ITEM_SELECT,itemSelectHandler);
			_enstrustBtn.removeEventListener(MouseEvent.CLICK,enstrustBtnClickHandler);
			_finishBtn.removeEventListener(MouseEvent.CLICK,finishBtnClickHandler);
			_selectAllBtn.removeEventListener(MouseEvent.CLICK,allBtnClickHandler);
//			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
		}
		
		private function moneyUpdateHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			_Yuanbao.setValue(String(GlobalData.selfPlayer.userMoney.yuanBao));
		}
		
		private function itemSelectHandler(e:Event):void
		{
			var itemView:AccordionGroupItemView = _listView.selectedItem;
			var info:TaskEntrustItemInfo = _listView.selectedItemData as TaskEntrustItemInfo;
			var item:TaskEntrustItem = new TaskEntrustItem(info,itemDoubleClickHandler);
			item.addEventListener(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE,entrustInfoUpdateHandler);
			item.addEventListener(TaskInnerEvent.TASK_ENTRUST_REMOVE,entrustRemoveHandler);
			item.addEventListener(MouseEvent.CLICK,itemClickHandler);
			_tile.appendItem(item);
			_list.push(item);
			_infoList.push(info.taskId);
			_listView.removeItem(TaskType.getEntrustTaskTypes().indexOf(info.template.type),itemView);
			entrustInfoUpdateHandler(null);
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			var item:TaskEntrustItem = e.currentTarget as TaskEntrustItem;
			if(item.itemInfo.isEntrusting == false)
				DoubleClickManager.addClick(item);
		}
		
		private function itemDoubleClickHandler(item:TaskEntrustItem):void
		{
			item.removeEventListener(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE,entrustInfoUpdateHandler);
			item.removeEventListener(TaskInnerEvent.TASK_ENTRUST_REMOVE,entrustRemoveHandler);
			item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
			_tile.removeItem(item);
			_infoList.splice(_list.indexOf(item),1);
			_list.splice(_list.indexOf(item),1);
			_listView.appendItem(TaskType.getEntrustTaskTypes().indexOf(item.itemInfo.template.type),item.itemInfo );
			item.dispose();
			entrustInfoUpdateHandler(null);
		}
		
		private function allBtnClickHandler(e:MouseEvent):void
		{
			var list:Array = GlobalData.taskInfo.getCanEntrustTasks();
			for each(var l:TaskAccordionData in list)
			{
				for each(var info:TaskEntrustItemInfo in l.data)
				{
					if(_infoList.indexOf(info.taskId) == -1)
					{
						var item:TaskEntrustItem = new TaskEntrustItem(info,itemDoubleClickHandler);
						item.addEventListener(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE,entrustInfoUpdateHandler);
						item.addEventListener(TaskInnerEvent.TASK_ENTRUST_REMOVE,entrustRemoveHandler);
						item.addEventListener(MouseEvent.CLICK,itemClickHandler);
						_tile.appendItem(item);
						_list.push(item);
						_infoList.push(info.taskId);
					}
				}
			}
			_listView.clearItems();
			entrustInfoUpdateHandler(null);
		}
		
		private function enstrustBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var list:Array = [];
			for(var i:int = 0; i < _list.length; i++)
			{
				if(_list[i].selected && _list[i].itemInfo.isEntrusting == false)
				{
					list.push({taskId:_list[i].itemInfo.taskId,type:_list[i].type,count:_list[i].count})
				}
			}
			if(list.length > 0)
			{
//				MAlert.show("确定开始委托任务吗？委托任务需要花费" + _yuanbao + "元宝。","提示",MAlert.OK | MAlert.CANCEL,null,closeHandler);
				MAlert.show(LanguageManager.getWord("ssztl.common.isSureEntrustTask",_yuanbao),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			}
			
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					if(GlobalData.selfPlayer.userMoney.yuanBao < _yuanbao)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.task.cannotEntrust"));
						return;
					}
					TaskTrustSocketHandler.send(list);
				}
			}
		}
		
		private function finishBtnClickHandler(e:MouseEvent):void
		{
			_mediator.showEntrustFinishPanel();
		}
		
		private function createList():void
		{
//			var list:Vector.<TaskItemInfo> = GlobalData.taskInfo.getEntrustingTask();
			var list:Array = GlobalData.taskInfo.getEntrustingTask();
			for(var i:int = 0; i < list.length; i++)
			{
				var info:TaskEntrustItemInfo = new TaskEntrustItemInfo();
				info.taskId = list[i].taskId;
				info.dayLeftCount = list[i].dayLeftCount;
				info.isEntrusting = list[i].isEntrusting;
				info.entrustCount = list[i].entrustCount;
				info.entrustEndTime = list[i].entrustEndTime;
				var item:TaskEntrustItem = new TaskEntrustItem(info,itemDoubleClickHandler);
				item.addEventListener(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE,entrustInfoUpdateHandler);
				item.addEventListener(TaskInnerEvent.TASK_ENTRUST_REMOVE,entrustRemoveHandler);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_tile.appendItem(item);
				_list.push(item);
				_infoList.push(info.taskId);
			}
			entrustInfoUpdateHandler(null);
		}
		
		private function entrustInfoUpdateHandler(e:TaskInnerEvent):void
		{
			_yuanbao = 0;
			for(var i:int = 0; i < _list.length; i++)
			{
				if(_list[i].selected && _list[i].itemInfo.isEntrusting == false)
				{
					_yuanbao += _list[i].needYuanbao;
				}
			}
			_Yuanbao.setValue(String(GlobalData.selfPlayer.userMoney.yuanBao));
			_needYuanbao.setValue(String(_yuanbao));
			if(_yuanbao > 0)_enstrustBtn.enabled = true;
			else _enstrustBtn.enabled = false;
			if(GlobalData.taskInfo.getEntrustingTask().length > 0)_finishBtn.enabled = true;
			else _finishBtn.enabled = false;
		}
		
		private function entrustRemoveHandler(e:TaskInnerEvent):void
		{
			var item:TaskEntrustItem = e.currentTarget as TaskEntrustItem;
			item.removeEventListener(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE,entrustInfoUpdateHandler);
			item.removeEventListener(TaskInnerEvent.TASK_ENTRUST_REMOVE,entrustRemoveHandler);
			item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
			_tile.removeItem(item);
			_infoList.splice(_list.indexOf(item),1);
			_list.splice(_list.indexOf(item),1);
			item.dispose();
			entrustInfoUpdateHandler(null);
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_enstrustBtn)
			{
				_enstrustBtn.dispose();
				_enstrustBtn = null;
			}
			if(_finishBtn)
			{
				_finishBtn.dispose();
				_finishBtn = null;
			}
			if(_selectAllBtn)
			{
				_selectAllBtn.dispose();
				_selectAllBtn = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_list)
			{
				for each(var item:TaskEntrustItem in _list)
				{
					item.removeEventListener(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE,entrustInfoUpdateHandler);
					item.removeEventListener(TaskInnerEvent.TASK_ENTRUST_REMOVE,entrustRemoveHandler);
					item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
					item.dispose();
				}
			}
			_list = null;
			_infoList = null;
			if(_listView)
			{
				_listView.dispose();
				_listView = null;
			}
			_mediator = null;
			super.dispose();
		}
	}
}