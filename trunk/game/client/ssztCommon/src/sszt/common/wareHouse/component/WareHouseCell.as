package sszt.common.wareHouse.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.common.wareHouse.WareHouseController;
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.DragActionType;
	import sszt.core.caches.CellAssetCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.BagExtendSocketHandler;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.core.view.tips.WareHouseTip;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import ssztui.ui.LockAsset;
	
	public class WareHouseCell extends BaseCell implements IAcceptDrag,IDoubleClick
	{
		
		private var _itemInfo:ItemInfo;
		private var _place:int;
		private var _isOpen:Boolean;
		private var _closeIcon:Bitmap;
		private var _countLabel:TextField;
		private var _tempPoint:Point;
		private var _controller:WareHouseController;
		private var _promptText:TextField;
		private var _lockIcon:Bitmap;
		
		public function WareHouseCell(controller:WareHouseController)
		{
			super();
			_controller = controller;
			_isOpen = true;
			_closeIcon = new Bitmap(CellAssetCaches.cellCloseAsset);
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,41,41);
			graphics.endFill();
			
			_countLabel = new TextField();
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countLabel.defaultTextFormat = t;
			_countLabel.setTextFormat(t);
			_countLabel.x = 4;
			_countLabel.y = 22;
			_countLabel.width = 33;
			_countLabel.height = 14;
			_countLabel.mouseEnabled = false;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
			_promptText = new TextField();
			_promptText.textColor = 0xffffff;
			_promptText.x = 2;
			_promptText.y = 9;
			_promptText.width = 35;
			_promptText.height = 35;
			_promptText.mouseEnabled = _promptText.mouseWheelEnabled = false;
			_promptText.filters = [new GlowFilter(0x000000,1,2,2,10)];
			var t2:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_promptText.defaultTextFormat = t2;
			_promptText.setTextFormat(t2);
		}
		
		public function doubleClick():void
		{
			if(_itemInfo)
			{
				var toPlace:int = GlobalData.bagInfo.getEmptyPlace();
				if(toPlace == -1)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
					return ;
				}
				ItemMoveSocketHandler.sendItemMove(CommonBagType.WAREHOUSE,_place,CommonBagType.BAG,toPlace,_itemInfo.count);
			}		
		}
		
		public function click():void
		{
			if(!isOpen)
			{
//				BuyPanel.getInstance().show(CategoryType.WARE_QUICK_BUY_LIST,new ToStoreData(103));
				var list:Array = GlobalData.bagInfo.getItemById(CategoryType.WARE_EXTEND_S);
				if(list.length == 0) list =  GlobalData.bagInfo.getItemById(CategoryType.WARE_EXTEND_T);
				if(list.length == 0)
				{
					MAlert.show(LanguageManager.getWord("ssztl.bag.WareHouseExtendAlert",48),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,wareHouseExtendCloseHandler);
				}else
				{
					ItemUseSocketHandler.sendItemUse(list[0].place);
				}
			}
			if(_itemInfo)
			{
				WareHouseTip.getInstance().show(this,_tempPoint);
			}
		}
		
		private function wareHouseExtendCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				BagExtendSocketHandler.sendExtend(21);
			}
		}
		
		public function set tempPoint(value:Point):void
		{
			_tempPoint = value;
		}
		
		public function set isOpen(value:Boolean):void
		{
			if(_isOpen == value) return;
			_isOpen = value;
			if(!_isOpen)
			{
				_closeIcon.x = 0;
				_closeIcon.y = 0;
				addChild(_closeIcon);
//				mouseChildren = mouseEnabled = false;
			}
			else
			{
				if(_closeIcon.parent)
				{
					removeChild(_closeIcon);
				}
			}
		}
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		private function setEnable():void
		{
			mouseChildren = mouseEnabled = (_itemInfo != null);
		}
		
		public function get place():int
		{
			return _place;
		}
		
		public function set place(pos:int):void
		{
			_place = pos;
			if(_place < 108 && _place >= GlobalData.selfPlayer.wareHouseMaxCount && _place < GlobalData.selfPlayer.wareHouseMaxCount + 6)
			{
				addChild(_promptText);
				if(_place == GlobalData.selfPlayer.wareHouseMaxCount) _promptText.text = LanguageManager.getWord("ssztl.bag.Dian");
				else if(_place == GlobalData.selfPlayer.wareHouseMaxCount + 1) _promptText.text = LanguageManager.getWord("ssztl.bag.Ji");
				else if(_place == GlobalData.selfPlayer.wareHouseMaxCount + 2) _promptText.text = LanguageManager.getWord("ssztl.bag.Kuo");
				else if(_place == GlobalData.selfPlayer.wareHouseMaxCount + 3) _promptText.text = LanguageManager.getWord("ssztl.bag.Zhan");
				else if(_place == GlobalData.selfPlayer.wareHouseMaxCount + 4) _promptText.text = LanguageManager.getWord("ssztl.bag.Cang");
				else if(_place == GlobalData.selfPlayer.wareHouseMaxCount + 5) _promptText.text = LanguageManager.getWord("ssztl.bag.Ku");
			}else
			{
				if(_promptText && _promptText.parent) _promptText.parent.removeChild(_promptText);
			}
		}
		
		public function set itemInfo(item:ItemInfo):void
		{
			if(_itemInfo == item) return;
			_itemInfo = item;
			if(_itemInfo)
			{
				info = _itemInfo.template;
				if(CategoryType.isEquip(_itemInfo.template.categoryId))
				{
					if(_itemInfo.strengthenLevel > 0)
						_countLabel.text = "+" + String(_itemInfo.strengthenLevel);
					else
						_countLabel.text = "";
				}
				else
				{
					_countLabel.text = _itemInfo.count==1?"":String(_itemInfo.count);
				}
				setEnable();
			}else
			{
				info = null;
				_countLabel.text = "";
			}
		}
		
		override public function getSourceData():Object
		{
			return _itemInfo;
		}
		
		override public function getSourceType():int
		{
			return CellType.WAREHOUSECELL;
		}
		
		public function get itemInfo():ItemInfo
		{
			return _itemInfo;
		}
	
		override public function dragDrop(data:IDragData):int
		{
			var action:int = DragActionType.UNDRAG;
			var source:IDragable = data.dragSource;
			if(!source)return action;
			var tempItem:ItemInfo = source.getSourceData() as ItemInfo;
			if(!_isOpen) return action;
			if(source.getSourceType() == CellType.BAGCELL)
			{
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,tempItem.place,CommonBagType.WAREHOUSE,_place,tempItem.count);
				action = DragActionType.DRAGIN;
			}
			else if(source.getSourceType() == CellType.WAREHOUSECELL)
			{
//				ItemMoveSocketHandler.sendItemMove(CommonBagType.WAREHOUSE,tempItem.place,CommonBagType.WAREHOUSE,_place,tempItem.count);
//				action = DragActionType.DRAGIN;
				if(_controller.module.wareHouseInfo.currentDrag)
				{
					action = setWareCellIn(_controller.module.wareHouseInfo.currentDrag);
				}
			}
			return action;
		}
		
		private function setWareCellIn(tempItem:ItemInfo):int
		{
			ItemMoveSocketHandler.sendItemMove(CommonBagType.WAREHOUSE,tempItem.place,CommonBagType.WAREHOUSE,_place,tempItem.count);
			return DragActionType.DRAGIN;
		}
		
		override public function dragStop(data:IDragData):void
		{
			if(data.action == DragActionType.ONSELF)
			{
				var item:ItemInfo = _controller.module.wareHouseInfo.currentDrag;
				if(item && item.place != place)
				{
					setWareCellIn(item);
				}
				else
				{
					locked = false;
				}
				return;
			}
			else if(data.action == DragActionType.UNDRAG)
			{
				locked = false;
				return ;
			}
			if(data.action == DragActionType.NONE)
			{
				locked = false;
				return;
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(itemInfo) TipsUtil.getInstance().show(itemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
			
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
			
			if(_itemInfo && itemInfo.isInLock())
			{
				_lockIcon = new Bitmap(new LockAsset());
				addChild(_lockIcon);
				_lockIcon.x = 3;
				_lockIcon.y = 23;
			}else
			{
				if(_lockIcon)
				{
					removeChild(_lockIcon);
					_lockIcon = null;
				}
			}
		}
		
		override public function dispose():void
		{
			_itemInfo = null;
			_controller = null;
			if(_lockIcon && _lockIcon.bitmapData)
			{
				_lockIcon.bitmapData.dispose();
				_lockIcon = null;
			}
			super.dispose();
		}
	}
}