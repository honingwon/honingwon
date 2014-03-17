package sszt.common.npcStore.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.common.npcStore.components.cell.RepairBtnCell;
	import sszt.common.npcStore.controllers.NPCStoreController;
	import sszt.common.npcStore.events.NPCStoreEvent;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemBuyByExploitHandler;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.socketHandlers.common.ItemRepairSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MTile;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	public class SellPanel extends Sprite
	{
		private var _controller:NPCStoreController;
		private var _shopType:int;
		private var _defaultPlace:int;
		private var _defaultCount:int;
		
		private var _currentCell:ListItem;
//		private var _cellList:Vector.<NPCStoreCell>;
		private var _cellList:Array;
		private var _tile:MTile;
		private var _pageView:PageView;
		private var _currentPage:int = 0;
		
		private var _repairBtn:RepairBtnCell;
		private var _repairAllBtn:MCacheAsset3Btn;
		private var _buyBtn:MCacheAssetBtn1;
		
		private var _addBtn:MBitmapButton;
		private var _reduceBtn:MBitmapButton;	
		private var _totalValue:MAssetLabel;
		private var _countValue:TextField;
		private var _count:int = 1;
		
		private var _bgTxtAccount:MAssetLabel;
		private var _bgTxtTotal:MAssetLabel;
		
		private var _tipBtns:Array;
		private var _labels:Array;
		
		private static const PAGE_SIZE:int = 10;
		private static const DEFAULT_COUNT:int = 99;
		
//		/**
//		 * 个人功勋
//		 */		
//		private var _exploit:MAssetLabel;
		
		public function SellPanel(control:NPCStoreController,type:int, defaultPlace:int, defaultCount:int)
		{
			_controller = control;
			_shopType = type;
			_defaultPlace = defaultPlace;
			_defaultCount = defaultCount;
			super();
			init();
		}
		
		private function init():void
		{
			_tile = new MTile(162, 56, 2);
			_tile.itemGapW = 1;
			_tile.itemGapH = 2;
			_tile.setSize(325, 289);
			_tile.move(7, 7);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
//			_cellList = new Vector.<NPCStoreCell>();
			_cellList = new Array();
			for(var i:int = 0; i < PAGE_SIZE; i++)
			{
				var cell:ListItem = new ListItem(_controller,_shopType);
				_cellList.push(cell);
				_tile.appendItem(cell);
			}
			
			_labels = [LanguageManager.getWord("ssztl.common.fixSingle"),LanguageManager.getWord("ssztl.common.fixBag")];
			
			_pageView = new PageView(PAGE_SIZE, false, 112);
			_pageView.totalRecord = ShopTemplateList.getShop(_shopType).shopItemInfos[0].length;
			_pageView.move(114, 301);
			addChild(_pageView);
			
			_repairBtn = new RepairBtnCell();
			_repairBtn.move(1,287);
			addChild(_repairBtn);
			_repairBtn.visible = false;
			
			_repairAllBtn = new MCacheAsset3Btn(2,LanguageManager.getWord("ssztl.common.fixAll"));
			_repairAllBtn.move(1,313);
			addChild(_repairAllBtn);
			_repairAllBtn.visible = false;
			
			_tipBtns = [_repairBtn,_repairAllBtn];
			
			_addBtn = new MBitmapButton(new SmallBtnAmountUpAsset());
			_addBtn.move(110, 356);
			addChild(_addBtn);
			
			_reduceBtn = new MBitmapButton(new SmallBtnAmountDownAsset());
			_reduceBtn.move(110, 365);
			addChild(_reduceBtn);
			
			_buyBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.buy"));
			_buyBtn.move(259,351);
			addChild(_buyBtn);
			
			_countValue = new TextField();
			_countValue.textColor = 0xffffff;
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.CENTER);
			_countValue.defaultTextFormat = t;
			_countValue.x = 75;
			_countValue.y = 358;
			_countValue.width = 35;
			_countValue.height = 14;
			_countValue.restrict = "0123456789";
			_countValue.maxChars = 3;
			_countValue.type = TextFieldType.INPUT;
			addChild(_countValue);
			_countValue.text = "99";
			
			_totalValue = new MAssetLabel("0",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_totalValue.move(183,358);
			addChild(_totalValue);
			
			_bgTxtAccount = new MAssetLabel(LanguageManager.getWord('ssztl.common.buyCount'), MAssetLabel.LABEL_TYPE_TAG, TextFormatAlign.LEFT);
			_bgTxtAccount.move(12,358);
			addChild(_bgTxtAccount);
			_bgTxtTotal = new MAssetLabel(LanguageManager.getWord('ssztl.common.buyTotalPrice'), MAssetLabel.LABEL_TYPE_TAG, TextFormatAlign.LEFT);
			_bgTxtTotal.move(144,358);
			addChild(_bgTxtTotal);
			
//			if(_shopType == ShopID.GX)
//			{
//				_exploit = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
//				_exploit.move(197,370);
//				_exploit.setValue(LanguageManager.getWord("ssztl.common.exploitValue")+GlobalData.pvpInfo.exploit);
//				addChild(_exploit);
//			}
			updateView(_currentPage);
			initEvent();
		}
		
		private function initEvent():void
		{
			_repairBtn.addEventListener(MouseEvent.CLICK,repairClickHandler);
			_repairAllBtn.addEventListener(MouseEvent.CLICK,repairAllClickHandler);
			_addBtn.addEventListener(MouseEvent.CLICK,addClickHandler);
			_countValue.addEventListener(Event.CHANGE,countChangeHandler);
			_reduceBtn.addEventListener(MouseEvent.CLICK,reduceClickHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyClickHandler);
			for(var i:int = 0;i<_cellList.length;i++)
			{
				_cellList[i].addEventListener(MouseEvent.CLICK,cellClickHandler);
			}
			for(i = 0;i<_tipBtns.length;i++)
			{
				_tipBtns[i].addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
				_tipBtns[i].addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
			
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_EXPLOIT,updateExploit);
		}
		
		private function removeEvent():void
		{
			_repairBtn.removeEventListener(MouseEvent.CLICK,repairClickHandler);
			_repairAllBtn.removeEventListener(MouseEvent.CLICK,repairAllClickHandler);
			_addBtn.removeEventListener(MouseEvent.CLICK,addClickHandler);
			_countValue.removeEventListener(Event.CHANGE,countChangeHandler);
			_reduceBtn.removeEventListener(MouseEvent.CLICK,reduceClickHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			for(var i:int = 0;i<_cellList.length;i++)
			{
				_cellList[i].removeEventListener(MouseEvent.CLICK,cellClickHandler);
			}
			for(i = 0;i<_tipBtns.length;i++)
			{
				_tipBtns[i].removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
				_tipBtns[i].removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
			
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_EXPLOIT,updateExploit);
		}
		
		private function tipOverHandler(evt:MouseEvent):void
		{
			var index:int = _tipBtns.indexOf(evt.currentTarget);
			TipsUtil.getInstance().show(_labels[index],null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
//		private function updateExploit(evt:CommonModuleEvent):void
//		{
//			_exploit.setValue(LanguageManager.getWord("ssztl.common.exploitValue")+GlobalData.pvpInfo.exploit);
//		}
		
		private function addClickHandler(evt:MouseEvent):void
		{
			if(_count>= 999) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_count = _count +1;
			_countValue.text = String(_count);
			_totalValue.setValue(String(_count*_currentCell.shopItem.price));
		}
		
		private function reduceClickHandler(evt:MouseEvent):void
		{
			if(_count <= 1)
			{
				_count = 1;
			}else
			{
				_count = _count - 1;
				SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			}
			_countValue.text = String(_count);
			_totalValue.setValue(String(_count*_currentCell.shopItem.price));
		}
		
		private function countChangeHandler(evt:Event):void
		{
			_count = int(_countValue.text);
			_totalValue.setValue(String(_count*_currentCell.shopItem.price));
		}
		
		private function repairClickHandler(evt:Event):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			GlobalAPI.dragManager.startDrag(evt.target as IDragable,true);
			SetModuleUtils.addBag();
		}
		
		private function repairAllClickHandler(evt:Event):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ItemRepairSocketHandler.sendRepair(999);
		}
		
		private function buyClickHandler(evt:MouseEvent):void
		{
			if(_count <= 0) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var shopItem:ShopItemInfo = _currentCell.shopItem;
			var result:String = shopItem.priceEnough(_count);
			if(result != "")
			{
				QuickTips.show(result + LanguageManager.getWord("ssztl.common.cannotBuy"));
				return;
			}
			if(!shopItem.bagHasEmpty(_count))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.buyFail"));
				return ;
			}
			var message:String = message = LanguageManager.getWord("ssztl.common.buyWillCost2",_count,shopItem.template.name,shopItem.price*_count,shopItem.getPriceTypeString());;
			if(_shopType != ShopID.GX)
			{
				MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);
				function buyMAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MYuanbaoAlert.OK)
					{
						ItemBuySocketHandler.sendBuy(shopItem.id,_count);
						
						if(GlobalData.guideTipInfo != null && GlobalData.guideTipInfo.param1 == GuideTipDeployType.NPC_STORE)
						{
							dispatchEvent(new NPCStoreEvent(NPCStoreEvent.CLOSE_PANEL));
							ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.CLOSE_BAG));
						}
					}
				}
			}
			else
			{
				MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyByExploit);
				function buyByExploit(evt:CloseEvent):void
				{
					if(evt.detail == MYuanbaoAlert.OK)
					{
						ItemBuyByExploitHandler.sendBuy(shopItem.id,_count);
						
						if(GlobalData.guideTipInfo != null && GlobalData.guideTipInfo.param1 == GuideTipDeployType.NPC_STORE)
						{
							dispatchEvent(new NPCStoreEvent(NPCStoreEvent.CLOSE_PANEL));
							ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.CLOSE_BAG));
						}
					}
				}
			}
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			var cell:ListItem = evt.currentTarget as ListItem;
			if(cell.shopItem == null) return;
			if(_currentCell) _currentCell.selected = false;
			_currentCell = cell;
			_currentCell.selected = true;
//			if(cell.shopItem)
//			{
//				_controller.showDealPanel((evt.currentTarget as NPCStoreCell).shopItem,_shopType);
//			}
			changeItem(DEFAULT_COUNT);
		}
		
		private function changeItem(count:int):void
		{
			_count = count;
			_countValue.text = String(_count);
			_totalValue.setValue(String(_count*_currentCell.shopItem.price));
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			_currentPage = _pageView.currentPage -1;
			updateView(_currentPage);
		}
		
		private function clearView():void
		{			
			for(var i:int = 0;i<_cellList.length;i++)
			{
				_cellList[i].shopItem = null;
			}
		}
		
		private function updateView(page:int):void
		{
			clearView();
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
//			var list:Vector.<ShopItemInfo> = shop.getItems(PAGESIZE,page,0);
			var list:Array = shop.getItems(PAGE_SIZE,page,0);
			for(var i:int = 0;i<list.length;i++)
			{
				_cellList[i].shopItem = list[i];
			}
			if(_currentCell) _currentCell.selected = false;
			_currentCell = _cellList[_defaultPlace];
			_currentCell.selected = true;
			changeItem(_defaultCount);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			_controller = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_currentCell)
			{
				_currentCell = null;
			}
			if(_cellList)
			{
				for(var i:int =0;i<_cellList.length;i++)
				{
					_cellList[i].dispose();
				}
				_cellList = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_repairBtn)
			{
				_repairBtn.dispose();
				_repairBtn = null;
			}
			if(_repairAllBtn)
			{
				_repairAllBtn.dispose();
				_repairAllBtn = null;
			}
			if(_buyBtn)
			{
				_buyBtn.dispose();
				_buyBtn = null;
			}
			if(_addBtn)
			{
				_addBtn.dispose();
				_addBtn = null;
			}
			if(_reduceBtn)
			{
				_reduceBtn.dispose();
				_reduceBtn = null;
			}
			_totalValue = null;
			_bgTxtAccount=null;
			_bgTxtTotal =null;
//			if(_shopType == ShopID.GX)
//			{
//				_exploit = null;
//			}
			if(parent) parent.removeChild(this);
		}
	}
}