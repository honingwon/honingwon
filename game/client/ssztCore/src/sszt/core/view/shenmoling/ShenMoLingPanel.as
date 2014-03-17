package sszt.core.view.shenmoling
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskItemList;
	import sszt.core.data.task.TaskStateTemplateInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.socketHandlers.shenmoling.RefreshTaskStateHandler;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class ShenMoLingPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _promptLabel:MAssetLabel;
//		private var _promptBtmp:Bitmap;
		
		private var _taskNameField:TextField;
		private var _taskLevelField:TextField;
		private var _taskTargetField:TextField;
		private var _expAwardField:TextField;
		private var _copperAwardField:TextField;
		
		private var _finishTimesField:TextField;
		
		private var _buyBtn:MCacheAsset1Btn;
		private var _refreshBtn:MCacheAsset1Btn;
		private var _acceptBtn:MCacheAsset1Btn;
		
		private var _itemInfo:ItemInfo;
		private var _taskInfo:TaskTemplateInfo;
		
		private var _instance:ShenMoLingPanel;
		
//		private var _curDayFinishTimes:int;
//		private var _canFinishTimes:int;
		
		public function ShenMoLingPanel(itemInfo:ItemInfo)
		{
			_itemInfo = itemInfo;
			var taskId:int = _itemInfo.enchase1;
			_taskInfo = TaskTemplateList.getSMLTaskTemplate(taskId);
//			_canFinishTimes = _taskInfo.repeatCount;
			
//			var taskId:int = 519002;
//			_taskInfo = TaskTemplateList.getTaskTemplate(taskId);
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.common.ShenMoLingTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.common.ShenMoLingTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title));
			
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(364,375);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,364,375)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,6,351,362)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,135,338,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,320,338,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(105,336,48,19))
			]);
			
			addContent(_bg as DisplayObject);
			
			_promptLabel = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_promptLabel.setSize(342,112);
			_promptLabel.defaultTextFormat =  new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,5);

			_promptLabel.setValue(LanguageManager.getWord("ssztl.core.shenMoLingPrompt"));
			
			_promptLabel.move(16,18);
			
			addContent(_promptLabel);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,146,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.taskName"),MAssetLabel.LABELTYPE3)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,163,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.taskLevel"),MAssetLabel.LABELTYPE3)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,180,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.taskTask"),MAssetLabel.LABELTYPE3)));
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,207,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.taskAward"),MAssetLabel.LABELTYPE3)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,231,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.expAward")  + "：",MAssetLabel.LABELTYPE3)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,248,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.copperAward"),MAssetLabel.LABELTYPE3)));
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,338,88,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.todayFinishTimes"),MAssetLabel.LABELTYPE3)));
			
			_taskNameField = new TextField();
			_taskNameField.width = 88;
			_taskNameField.height = 18;
			_taskNameField.x = 80;
			_taskNameField.y = 145;
			_taskNameField.selectable = false;
			_taskNameField.text = _taskInfo.title;
			_taskNameField.textColor = 0xFFFFFF;
			addContent(_taskNameField);
			
			_taskLevelField = new TextField();
			_taskLevelField.width = 50;
			_taskLevelField.height = 18;
			_taskLevelField.x = 80;
			_taskLevelField.y = 162;
			_taskLevelField.selectable = false;
			_taskLevelField.text = LanguageManager.getWord("ssztl.common.levelValue",_taskInfo.minLevel + "-" +_taskInfo.maxLevel);
			_taskLevelField.textColor = 0xFFFFFF;
			addContent(_taskLevelField);
			
			_taskTargetField = new TextField();
			_taskTargetField.width = 202;
			_taskTargetField.height = 18;
			_taskTargetField.x = 80;
			_taskTargetField.y = 179;
			_taskTargetField.selectable = false;
			if(_taskInfo.target==null || _taskInfo.target == "undefined")
			{
				_taskTargetField.text = LanguageManager.getWord("ssztl.common.none");
			}
			else
			{
				_taskTargetField.text = _taskInfo.target;
			}
			_taskTargetField.textColor = 0xFFFFFF;
			addContent(_taskTargetField);
			
			 var taskStateInfo:TaskStateTemplateInfo = _taskInfo.states[_itemInfo.enchase2] as TaskStateTemplateInfo;
			
//			var taskStateInfo:TaskStateTemplateInfo = _taskInfo.states[0] as TaskStateTemplateInfo;
			
			_expAwardField = new TextField();
			_expAwardField.width = 46;
			_expAwardField.height = 18;
			_expAwardField.x = 79;
			_expAwardField.y = 229;
			_expAwardField.selectable = false;
			_expAwardField.text = taskStateInfo.awardExp.toString();
			_expAwardField.textColor = 0xFFFFFF;
			addContent(_expAwardField);
			
			_copperAwardField = new TextField();
			_copperAwardField.width = 46;
			_copperAwardField.height = 18;
			_copperAwardField.x = 79;
			_copperAwardField.y = 248;
			_copperAwardField.selectable = false;
			_copperAwardField.text = taskStateInfo.awardCopper.toString();
			_copperAwardField.textColor = 0xFFFFFF;
			addContent(_copperAwardField);
			
			_finishTimesField = new TextField();
			_finishTimesField.width = 48;
			_finishTimesField.height = 17;
			_finishTimesField.x = 105;
			_finishTimesField.y = 336;
			_finishTimesField.selectable = false;
			_finishTimesField.textColor = 0xFFFFFF;

			_finishTimesField.text = getFinshTimes()+ "/6";
			
			_finishTimesField.autoSize = TextFieldAutoSize.CENTER;
			addContent(_finishTimesField);
			
			_buyBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.core.buyLingLongStone"));
			_buyBtn.move(58, 285);
			addContent(_buyBtn);
			
			_refreshBtn = new MCacheAsset1Btn(2, LanguageManager.getWord("ssztl.core.lingLongStoneRefresh"));
			_refreshBtn.move(222, 285);
//			if(_itemInfo.enchase2 == 4)
//			{
//				_refreshBtn.enabled = false;
//			}
			addContent(_refreshBtn);
			
			_acceptBtn = new MCacheAsset1Btn(2, LanguageManager.getWord("ssztl.core.acceptTask"));
			_acceptBtn.move(222,333);
			addContent(_acceptBtn);
		}
		
		private function initEvents():void
		{
//			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE, itemUpdateHandler);
			
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE, itemUpdateHandler);
			
			_buyBtn.addEventListener(MouseEvent.CLICK, buyBtnClickHandler);
			_refreshBtn.addEventListener(MouseEvent.CLICK, refreshBtnClickHandler);
			_acceptBtn.addEventListener(MouseEvent.CLICK, acceptBtnClickHandler);
			
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_FINISH,taskUpdateHandler);
		}
		
		private function removeEvents():void
		{
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE, itemUpdateHandler);
			
			_buyBtn.removeEventListener(MouseEvent.CLICK, buyBtnClickHandler);
			_refreshBtn.removeEventListener(MouseEvent.CLICK, refreshBtnClickHandler);
			_acceptBtn.removeEventListener(MouseEvent.CLICK, acceptBtnClickHandler);
			
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_FINISH,taskUpdateHandler);
		}
		
		//当日神魔令完成次数
		private function getFinshTimes():int
		{
			var smlTasks:Array = GlobalData.taskInfo.getAllShenMoLingTask();
			var times:int = 0;
			for each(var item:TaskItemInfo in smlTasks)
			{
				times += (item.template.repeatCount - item.dayLeftCount);
			}
			return times;
		}
		
		//是否存在已接取但未完成的神魔令任务
		private function isAcceptSame():Boolean
		{
			var smlTasks:Array = GlobalData.taskInfo.getAllShenMoLingTask();
			for each(var item:TaskItemInfo in smlTasks)
			{
				if(!item.isFinish)
				{
					return true;
				}
			}
			return false;
		}
		
		private function taskUpdateHandler(e:TaskModuleEvent):void
		{
			_finishTimesField.text = getFinshTimes()+ "/6";
		}
		
		private function itemUpdateHandler(evt:BagInfoUpdateEvent):void
		{
//			var places:Array = evt.data as Array;
//			for each(var place:int in places)
//			{
//				var item:ItemInfo = GlobalData.bagInfo._itemList[place];
//				if(_itemInfo && item && item.itemId == _itemInfo.itemId)
//				{
////					var item:ItemInfo = GlobalData.bagInfo._itemList[place];
//					_itemInfo = item;
//					
//					if(_itemInfo)
//					{
//						var taskStateInfo:TaskStateTemplateInfo = _taskInfo.states[_itemInfo.enchase2] as TaskStateTemplateInfo;
//						
//						//var taskStateInfo:TaskStateTemplateInfo = _taskInfo.states[_itemInfo.enchase2] as TaskStateTemplateInfo;
//						_expAwardField.text = taskStateInfo.awardExp.toString();
//						_copperAwardField.text = taskStateInfo.awardCopper.toString();
//						_refreshBtn.enabled = true;
//					}
//				}
//			}
			
			var itemIds:Array = evt.data as Array;
			for each(var id:Number in itemIds)
			{
				if(_itemInfo.itemId == id)
				{
					_itemInfo = GlobalData.bagInfo.getItemByItemId(id);
					if(_itemInfo)
					{
						var taskStateInfo:TaskStateTemplateInfo = _taskInfo.states[_itemInfo.enchase2] as TaskStateTemplateInfo;
						_expAwardField.text = taskStateInfo.awardExp.toString();
						_copperAwardField.text = taskStateInfo.awardCopper.toString();
						_refreshBtn.enabled = true;
					}	
				}
			}
		}
		
		//购买玲珑石
		private function buyBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			var shopItemList:Array = ShopTemplateList.shopList[103].shopItemInfos[3];
			var templateList:Array = [];
			for each(var item:ShopItemInfo in shopItemList)
			{
				templateList.push(item.templateId);
			}
			BuyPanel.getInstance().show(templateList,new ToStoreData(ShopID.QUICK_BUY));
		}
		
		//玲珑石刷新
		private function refreshBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			var count:int =  GlobalData.bagInfo.getCategoryCount(CategoryType.LINGLONGSTONE);
			if(count < 1)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.lingLongStoneNotEnough"));
			}
			else if(!_itemInfo)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.refreshFail"));
			}
			else if(_itemInfo.enchase2 == 4)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.taskAchieveMaxQuality"));
			}
			else
			{
				var llsArray:Array = GlobalData.bagInfo.getListByType([CategoryType.LINGLONGSTONE]); //103025:玲珑石模版ID
				var lingLongStone:ItemInfo = llsArray[0];
				RefreshTaskStateHandler.sendRefreshState(_itemInfo.itemId, lingLongStone.itemId);
				_refreshBtn.enabled = false;
			}
		}
		
		//接受任务
		private function acceptBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			if(!_itemInfo)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.taskAccpetFail"));
			}
			else if(getFinshTimes() >= 6)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.taskDayLeftNull"));
			}
			else if(isAcceptSame())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.acceptSameTask"));
			}
//			else if(!_itemInfo)
//			{
//				QuickTips.show("任务接受失败，所需物品已丢失或使用");
//			}
			else
			{
				ItemUseSocketHandler.sendItemUse(_itemInfo.place);
				dispose();
			}
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_buyBtn)
			{
				_buyBtn.dispose();
				_buyBtn = null;
			}
			
			if(_refreshBtn)
			{
				_refreshBtn.dispose();
				_refreshBtn = null;
			}
			
			if(_acceptBtn)
			{
				_acceptBtn.dispose();
				_acceptBtn = null;
			}
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			super.dispose();
		}
	}
}