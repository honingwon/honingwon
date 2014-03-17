package sszt.scene.components.copyGroup
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.copy.CopyEnterNumberList;
	import sszt.core.data.copy.CopyEvent;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ChatModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.copyGroup.sec.AwardItemView;
	import sszt.scene.components.copyGroup.sec.CopyItemView;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.scene.socketHandlers.CopyTeamApplySocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class CopyGroupPanel extends MPanel
	{
		private var _mediator:CopyGroupMediator;
		
		private var _bg:IMovieWrapper;
		private var _applyInBtn:MCacheAsset1Btn;
		private var _cancelApplyBtn:MCacheAsset1Btn;
		private var _teamApplyBtn:MCacheAsset1Btn;
		private var _cancelTeamApplyBtn:MCacheAsset1Btn;
		public static var SelectBorder:SelectedBorder;
		
//		private var _labels:Vector.<String>;
//		private var _btns:Vector.<MCacheTab1Btn>;
		private var _labels:Array;
		private var _btns:Array;
		private var _currentType:int = 0;
		
		private var _tile:MTile;
//		private var _itemList:Vector.<CopyItemView>;
		private var _itemList:Array;
		private var _currentItem:CopyItemView;
		
		private var _tile1:MTile;
//		private var _awardList:Vector.<AwardItemView>;
		private var _awardList:Array;
		
		public function CopyGroupPanel(mediator:CopyGroupMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.CopyTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.CopyTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		override protected function configUI():void
		{
			SelectBorder = new SelectedBorder();
			SelectBorder.setSize(334,27);
			SelectBorder.mouseEnabled = false;
			
			super.configUI();
			setContentSize(525,317);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,525,317)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,35,354,242)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(361,35,159,242)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,30,514,5),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(10,38,347,24)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(365,38,152,24)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(66,41,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(206,41,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(272,41,11,17),new MCacheSplit3Line()),			
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,80,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,101,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,122,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,143,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,164,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,185,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,206,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,227,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,248,322,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,269,322,2),new MCacheSplit2Line()),				
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(24,42,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.suggestDegree"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(115,42,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.copyName")  + "：",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(222,42,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.signUpState"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(282,42,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.enterTimes"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(412,42,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.copyItem"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			
			
//			_labels = Vector.<String>([
//				"全部副本","装备副本","活动副本","PVP副本"
//			]);
//			var poses:Vector.<Point> = Vector.<Point>([new Point(15,8),new Point(81,8),new Point(147,8),new Point(213,8)]);
//			_btns = new Vector.<MCacheTab1Btn>();
			
//			_labels = [
//				"全部副本","经验副本","装备副本","材料副本","趣味副本","活动副本","PVP副本"
//			];
			_labels = [
				LanguageManager.getWord("ssztl.common.allCopy"),
				LanguageManager.getWord("ssztl.common.expCopy"),
				LanguageManager.getWord("ssztl.common.equipCopy"),
				LanguageManager.getWord("ssztl.common.materialCopy"),
				LanguageManager.getWord("ssztl.common.funnyCopy"),
				LanguageManager.getWord("ssztl.common.activityCopy"),
				LanguageManager.getWord("ssztl.common.pvpCopy")
			];
			var poses:Array = [new Point(15,8),new Point(81,8),new Point(147,8),new Point(213,8),new Point(279,8),new Point(345,8),new Point(411,8)];
			_btns = [];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTab1Btn = new MCacheTab1Btn(0,1,_labels[i]);
				btn.move(poses[i].x,poses[i].y);
				_btns.push(btn);
				addContent(btn);
			}
			_btns[0].selected = true;

			_applyInBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.personalSignUp"));
			_applyInBtn.move(337,283);
			addContent(_applyInBtn);
			
			_cancelApplyBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.cannelSignUp"));
			_cancelApplyBtn.move(337,283);
			addContent(_cancelApplyBtn);
			_cancelApplyBtn.visible = false;
			
			_teamApplyBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.cannelSignUp"));
			_teamApplyBtn.move(423,283);
			addContent(_teamApplyBtn);
			
			_cancelTeamApplyBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.cannelTeamSignUp"));
			_cancelTeamApplyBtn.move(423,283);
			addContent(_cancelTeamApplyBtn);
			_cancelTeamApplyBtn.visible = false;
			
			if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
			{
				_teamApplyBtn.visible = true;
			}else
			{
				_teamApplyBtn.visible = false;
			}
			
			_tile = new MTile(330,21,1);
			_tile.itemGapH = 0;
			_tile.setSize(345,212);
			_tile.move(10,62);
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollBar.lineScrollSize = 21;
			_tile.verticalScrollPolicy = ScrollPolicy.ON;
			addContent(_tile);
			
			_tile1 = new MTile(40,40,3);
			_tile1.itemGapH = _tile1.itemGapW = 2;
			_tile1.setSize(149,212);
			_tile1.move(365,62);
			_tile1.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile1.verticalScrollPolicy = ScrollPolicy.ON;
			_tile1.verticalScrollBar.lineScrollSize = 42;
			addContent(_tile1);
			
//			_itemList = new Vector.<CopyItemView>();
//			_awardList = new Vector.<AwardItemView>();
			_itemList = [];
			_awardList = [];
	
			initEvent();
			getData();
		}
		
		public function getData():void
		{
			_mediator.getCopyEnterCount();
		}
		
		private function loadStart(evt:Event):void
		{
			loadCopyData(0);
		}
		
		
		private function clearCopyView():void
		{
			_tile.clearItems();
			for(var i:int = 0; i< _itemList.length; i++)
			{
				_itemList[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
				_itemList[i].dispose();
			}
//			_itemList = new Vector.<CopyItemView>();
			_itemList = [];
			_currentItem = null;
		}
		
		private function loadCopyData(type:int):void
		{
			clearCopyView();
//			var list:Vector.<CopyTemplateItem> = CopyTemplateList.getListByType(type);
			var list:Array = CopyTemplateList.getListByType(type);
			for(var i:int = 0;i<list.length;i++)
			{
				var item:CopyItemView = new CopyItemView(list[i]);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_tile.appendItem(item);
				_itemList.push(item);
			}
			if(_itemList.length > 0)
			{
				loadAward(_itemList[0].info);
				if(_itemList[0].enabled)
				{
					_currentItem = _itemList[0];
					_currentItem.selected = true;
				}
			}else
			{
				clearAwardView();
			}
		}
		
		private function clearAwardView():void
		{
			_tile1.clearItems();
			for(var i:int = 0;i<_awardList.length;i++)
			{
				_awardList[i].dispose();
			}
//			_awardList = new Vector.<AwardItemView>();
			_awardList = [];
		}
		
		private function loadAward(item:CopyTemplateItem):void
		{
			clearAwardView();
//			var ids:Vector.<Number> = item.dropItemList;
			var ids:Array = item.award;
			for(var i:int = 0;i<ids.length;i++)
			{
				var template:ItemTemplateInfo = ItemTemplateList.getTemplate(ids[i]);
				var award:AwardItemView = new AwardItemView(template);
				_tile1.appendItem(award);
				_awardList.push(award);
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			if(_currentItem) _currentItem.selected = false;
			_currentItem = evt.currentTarget as CopyItemView;
			_currentItem.selected = true;
			if(GlobalData.copyEnterCountList.isApply && GlobalData.copyEnterCountList.applyId == _currentItem.info.id)
			{
				_applyInBtn.visible = false;
				_cancelApplyBtn.visible = true;
			}else
			{
				_applyInBtn.visible = true;
				_cancelApplyBtn.visible = false;
			}
			loadAward(_currentItem.info);
		}
		
		private function initEvent():void
		{
			_applyInBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_teamApplyBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelApplyBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelTeamApplyBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			GlobalData.copyEnterCountList.addEventListener(CopyEnterNumberList.SETDATACOMPLETE,loadStart);
			GlobalData.copyEnterCountList.addEventListener(CopyEvent.COPYAPPLY,applyHandler);
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,tabBtnClickHandler);
			}
			for(i=0;i<_itemList.length;i++)
			{
				_itemList[i].addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
		}
		
		private function removeEvent():void
		{
			_applyInBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_teamApplyBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelApplyBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelTeamApplyBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			GlobalData.copyEnterCountList.removeEventListener(CopyEvent.COPYAPPLY,applyHandler);
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,tabBtnClickHandler);
			}
			for(i=0;i<_itemList.length;i++)
			{
				_itemList[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
		}
		
		private function applyHandler(evt:CopyEvent):void
		{
			var id:int = evt.data as int;
			for(var i:int = 0;i<_itemList.length;i++)
			{
				if((_itemList[i] as CopyItemView).info.id == id)
				{
					(_itemList[i] as CopyItemView).isApply = true;
					if(_currentItem == _itemList[i])
					{
						_applyInBtn.visible = false;
						_cancelApplyBtn.visible = true;
						if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
						{
							_teamApplyBtn.visible = false;
							_cancelTeamApplyBtn.visible = true;
						}
					}
				}
			}
		}
		
		private function leaderChangeHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var id:Number = evt.data as Number;
			if(id == GlobalData.selfPlayer.userId)
				_teamApplyBtn.visible = true;
			else
				_teamApplyBtn.visible = false;
		}
		
		private function tabBtnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget);
			if(_currentType == index) return;
			_btns[_currentType].selected = false;
			_currentType = index;
			_btns[_currentType].selected = true;
			loadCopyData(_currentType);
		}
				
		private function btnClickHandler(evt:MouseEvent):void
		{
			switch(evt.currentTarget)
			{
				case _applyInBtn:
					applyClickHandler();
					break;
				case _cancelApplyBtn:
					cancelApplyClickHandler();
					break;
				case _teamApplyBtn:
					teamApplyClickHandler();
					break;
				case _cancelTeamApplyBtn:
					cancelTeamApplyClickHandler();
					break;
			}
		}
		
		private function applyClickHandler():void
		{	
//			_mediator.showCopyEnterAlert();
			if(GlobalData.copyEnterCountList.isInCopy || _mediator.sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			if(_currentItem == null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.noSelectCopy"));
				return;
			}
			var temp:Number = getTimer();
			if(temp - GlobalData.copyEnterCountList.lastCancelTime < 300000)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.refuseQuickCopy"));
				return;
			}
			if(GlobalData.copyEnterCountList.isApply)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.signUpManyCopy"));
				return ;
			}
			var info:ChatItemInfo = new ChatItemInfo();
			info.type = MessageType.SYSTEM;
			info.message = LanguageManager.getWord("ssztl.scene.startPersonalSignUp");
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,info));
			GlobalData.copyEnterCountList.isApply = true;
			GlobalData.copyEnterCountList.applyId = _currentItem.info.id;
			_currentItem.isApply = true;
			_applyInBtn.visible = false;
			_cancelApplyBtn.visible = true;
//			CopyApplySocketHandler.send(GlobalData.selfPlayer.userId,true);
		}
		
		private function cancelApplyClickHandler():void
		{			
			var info:ChatItemInfo = new ChatItemInfo();
			info.type = MessageType.SYSTEM;
			info.message = LanguageManager.getWord("ssztl.scene.cannelPersonalSignUp");
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,info));
			_currentItem.isApply = false;
			GlobalData.copyEnterCountList.isApply = false;
			GlobalData.copyEnterCountList.applyId = 0;
			_applyInBtn.visible = true;
			_cancelApplyBtn.visible = false;
//			CopyApplySocketHandler.send(GlobalData.selfPlayer.userId,true);
		}
		
		private function teamApplyClickHandler():void
		{
//			_mediator.showCopyEnterAlert();
//			_teamApplyBtn.visible = false;
//			_cancelTeamApplyBtn.visible = true;
			if(GlobalData.copyEnterCountList.isInCopy || _mediator.sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			CopyTeamApplySocketHandler.send(GlobalData.selfPlayer.userId,true);
		}
		
		private function cancelTeamApplyClickHandler():void
		{
			CopyTeamApplySocketHandler.send(GlobalData.selfPlayer.userId,false);
			_teamApplyBtn.visible = true;
			_cancelTeamApplyBtn.visible = false;
		}
	}
}