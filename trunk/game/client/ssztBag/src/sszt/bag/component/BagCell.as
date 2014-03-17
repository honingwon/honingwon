package sszt.bag.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.bag.event.BagCellEvent;
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.DragActionType;
	import sszt.core.caches.CellAssetCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemLockUpdateSocketHandler;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.common.ItemRepairSocketHandler;
	import sszt.core.socketHandlers.tradeDirect.TradeItemRemoveSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCompareItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import ssztui.bag.LockAsset;
	
	public class BagCell extends BaseCompareItemInfoCell implements IDoubleClick,IAcceptDrag
	{
		private var _place:int;
		private var _clickHandler:Function;
		private var _doubleClickHandler:Function;
		private var _hasOpen:Boolean;
		private var _closeBitmap:Bitmap;
		private var _countLabel:TextField;
		private var _lockIcon:Bitmap;
		private var _index:int = 0;
		private var _timerEffect:TimerEffect;
		private var _giftEffect:MovieClip;
		private var _promptText:TextField;
		private var _over:Bitmap;
		
		public function BagCell(clickHandler:Function = null,doubleClickHandler:Function = null)
		{
			super();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,41,41);
			graphics.endFill();
			_clickHandler = clickHandler;
			_doubleClickHandler = doubleClickHandler;
//			_closeBitmap = new Bitmap(_closeAsset);
			_hasOpen = true;
			_countLabel = new TextField();
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countLabel.defaultTextFormat = t;
			_countLabel.setTextFormat(t);
			_countLabel.x = 4;
			_countLabel.y = 22;
			_countLabel.width = 33;
			_countLabel.height = 14;
			_countLabel.mouseEnabled = _countLabel.mouseWheelEnabled = false;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
			_promptText = new TextField();
			_promptText.textColor = 0xffffff;
			_promptText.x = 2;
			_promptText.y = 9;
			_promptText.width = 35;
			_promptText.height = 35;
			_promptText.mouseEnabled = _promptText.mouseWheelEnabled = false;
			_promptText.filters = [new GlowFilter(0x000000,1,2,2,10)];
			t = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_promptText.defaultTextFormat = t;
			_promptText.setTextFormat(t);
			
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.visible = false;
			addChild(_over);
		}
		
		public function click():void
		{
			if(_clickHandler != null)
				_clickHandler(this);
		}
		
		public function doubleClick():void
		{
			if(_doubleClickHandler != null)
				_doubleClickHandler(this);
		}
		
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
		public function set place(value:int):void
		{
			_place = value;
			if(_place < 246 && _place >= GlobalData.selfPlayer.bagMaxCount + 30 && _place < GlobalData.selfPlayer.bagMaxCount + 36)
			{
				addChild(_promptText);
				if(_place == GlobalData.selfPlayer.bagMaxCount + 30) _promptText.text = LanguageManager.getWord("ssztl.bag.Dian");
				else if(_place == GlobalData.selfPlayer.bagMaxCount + 31) _promptText.text = LanguageManager.getWord("ssztl.bag.Ji");
				else if(_place == GlobalData.selfPlayer.bagMaxCount + 32) _promptText.text = LanguageManager.getWord("ssztl.bag.Kuo");
				else if(_place == GlobalData.selfPlayer.bagMaxCount + 33) _promptText.text = LanguageManager.getWord("ssztl.bag.Zhan");
				else if(_place == GlobalData.selfPlayer.bagMaxCount + 34) _promptText.text = LanguageManager.getWord("ssztl.bag.Bei");
				else if(_place == GlobalData.selfPlayer.bagMaxCount + 35) _promptText.text = LanguageManager.getWord("ssztl.bag.Bao");
			}else
			{
				if(_promptText && _promptText.parent) _promptText.parent.removeChild(_promptText);
			}
		}
		
		public function get place():int
		{
			return _place;
		}
			
		override public function getSourceType():int
		{
			return CellType.BAGCELL;
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			if(_iteminfo && _iteminfo != value)
			{
				ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_ITEM_CD,updateItemCdHandler);
			}
			super.itemInfo = value;
			if(_iteminfo)
			{
				if(CategoryType.isEquip(_iteminfo.template.categoryId))
				{
					if(_iteminfo.strengthenLevel > 0)
						_countLabel.text = "+" + String(_iteminfo.strengthenLevel);
					else
						_countLabel.text = "";
				}
				else
				{
					_countLabel.text = String(_iteminfo.count>1?_iteminfo.count:"");
				}
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_ITEM_CD,updateItemCdHandler);
				
				if(CategoryType.isHpDrup(itemInfo.template.categoryId) || CategoryType.isMpDrup(itemInfo.template.categoryId))
				{
					if(_timerEffect == null)
					{
						_timerEffect = new TimerEffect(itemInfo.template.cd,new Rectangle(_figureBound.x,_figureBound.y,_figureBound.width,_figureBound.height));
						addChild(_timerEffect);
					}
					if(CategoryType.isHpDrup(itemInfo.template.categoryId) && (getTimer() - GlobalData.lastUseTime_hp < itemInfo.template.cd))
					{
						_timerEffect.setTime(itemInfo.template.cd + GlobalData.lastUseTime_hp - getTimer());
						_timerEffect.begin();
					}
					else if(CategoryType.isMpDrup(itemInfo.template.categoryId) && (getTimer() - GlobalData.lastUseTime_mp < itemInfo.template.cd))
					{
						_timerEffect.setTime(itemInfo.template.cd + GlobalData.lastUseTime_mp - getTimer());
						_timerEffect.begin();
					}
				}
			}
			else
			{
				_countLabel.text = "";
				
				if(_timerEffect && _timerEffect.parent)
				{
					_timerEffect.parent.removeChild(_timerEffect);
					_timerEffect = null;
				}
			}
			if(!_iteminfo || _iteminfo.template.iconPath != "160101")
			{
				clearCellEffect();
			}
		}
		
		private function updateItemCdHandler(e:CommonModuleEvent):void
		{
			if(itemInfo)
			{
				if(CategoryType.isHpDrup(itemInfo.template.categoryId) && e.data == 1)
				{
					if((getTimer() - GlobalData.lastUseTime_hp < itemInfo.template.cd))
					{
						_timerEffect.setTime(itemInfo.template.cd + GlobalData.lastUseTime_hp - getTimer());
						_timerEffect.begin();
					}
				}
				else if(CategoryType.isMpDrup(itemInfo.template.categoryId) && e.data == 2)
				{
					if((getTimer() - GlobalData.lastUseTime_mp < itemInfo.template.cd))
					{
						_timerEffect.setTime(itemInfo.template.cd + GlobalData.lastUseTime_mp - getTimer());
						_timerEffect.begin();
					}
				}
			}
		}
		
		public function setStall():void
		{
			
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
			setChildIndex(_over,numChildren-1);
			
			if(_timerEffect)setChildIndex(_timerEffect,numChildren - 1);
			if(_iteminfo && _iteminfo.isInLock())
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
			if(_iteminfo && _iteminfo.template.iconPath == "160101")
			{
				createCellEffect();
			}
			else
			{
				clearCellEffect();
			}
		}
		
		private function createCellEffect():void
		{
			if(!_giftEffect)
			{
				_giftEffect = AssetUtil.getAsset("ssztui.common.CellEffect1Asset",MovieClip) as MovieClip;
				_giftEffect.mouseChildren = _giftEffect.mouseEnabled = false;
				_giftEffect.x = 2;
				_giftEffect.y = 2;
				addChild(_giftEffect);
			}
		}
		private function clearCellEffect():void
		{
			if(_giftEffect)
			{
				_giftEffect.stop();
				if(_giftEffect.parent)
					_giftEffect.parent.removeChild(_giftEffect);
				_giftEffect = null;
			}
		}
		
		public function set hasOpen(value:Boolean):void
		{
			if(_hasOpen == value)return;
			_hasOpen = value;
			if(!_hasOpen)
			{
				if(!_closeBitmap)
				{
					_closeBitmap = new Bitmap(CellAssetCaches.cellCloseAsset);
			    	_closeBitmap.x = 0;
					_closeBitmap.y = 0;
				}
				addChild(_closeBitmap);	
			}
			else
			{
				if(_closeBitmap && _closeBitmap.parent)
					_closeBitmap.parent.removeChild(_closeBitmap);
			}
		}
		
		public function get hasOpen():Boolean
		{
			return _hasOpen;
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.UNDRAG;
			if(!source)return action;
			var bagItemInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(!_hasOpen) return action;
			if(source == this){}
			else if(source.getSourceType() == CellType.BAGCELL)
			{
				action = setBagCellIn(GlobalData.bagInfo.currentDrag);
			}
			else if(source.getSourceType() == CellType.STALLBEGSALECELL)
			{
				var argItemInfo:ItemInfo = GlobalData.clientBagInfo.getItemInfoFromSallSaleVector(bagItemInfo.place);
				if(argItemInfo)
				{
					argItemInfo.lock = false;
					GlobalData.clientBagInfo.removeFromStallBegSaleVector(bagItemInfo.place);
					action = DragActionType.DRAGIN;
				}
				else
				{
					action = DragActionType.NONE;
				}
			}
			else if(source.getSourceType() == CellType.STALLBEGBUYCELL)
			{
				action = DragActionType.DRAGIN;
				var tmp:ItemTemplateInfo = source.getSourceData() as ItemTemplateInfo;
				GlobalData.stallInfo.removeFromBegBuyVector(tmp.templateId);
			}
			else if(source.getSourceType() == CellType.STALLSHOPPINGSALECELL)
			{
				var tmpItemInfo:ItemInfo = GlobalData.clientBagInfo.getStallShopBuySaleInfoFromStallShoppingSaleVector(bagItemInfo.place).itemInfo;
				if(tmpItemInfo)
				{
					tmpItemInfo.lock = false;
					GlobalData.clientBagInfo.removeFromStallBegSaleVector(tmpItemInfo.place);
					action = DragActionType.DRAGIN;
				}
				else
				{
					action = DragActionType.NONE;
				}
			}
			else if(source.getSourceType() == CellType.CONSIGNCELL)
			{
				action = DragActionType.DRAGIN;
				bagItemInfo.lock = false;
			}
			else if(source.getSourceType() == CellType.RECYCLE)
			{
				if(itemInfo != null && itemInfo.canOperate())
				{
					action =DragActionType.DRAGIN;
					if(!itemInfo.template.canDestory)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDrop"));
						return action;
					}
					MAlert.show(LanguageManager.getWord("ssztl.common.isSureDrop"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,alertCloseHandler);
				}
			}
			else if(source.getSourceType() == CellType.SPLIT)
			{
				if(itemInfo != null && itemInfo.canOperate())
				{
					if(itemInfo.count == 1)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.bag.cannotSplit"));
						return action;
					}
					if(!GlobalData.bagInfo.getHasPos(1))
					{
						QuickTips.show(LanguageManager.getWord("ssztl.bag.cannotSplit2"));
						return action;
					}
					dispatchEvent(new BagCellEvent(BagCellEvent.ITEM_SPLIT));
				}
			}
			else if(source.getSourceType() == CellType.REPAIR)
			{
				if(itemInfo && itemInfo.canOperate())
				{
					if(itemInfo.template.canRepair)
					{
						ItemRepairSocketHandler.sendRepair(place);
					}else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.bag.cannotFix"));
					}
				}
			}
			else if(source.getSourceType() == CellType.LOCKCELL)
			{
				if(!itemInfo.template.canLock)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.bag.cannotLock"));
					return action;
				}
				if(itemInfo.isInLock())
				{
					MAlert.show(LanguageManager.getWord("ssztl.bag.sureToUnlock"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,unlockAlertHandler);
					function unlockAlertHandler(evt:CloseEvent):void
					{
						if(evt.detail == MAlert.OK)
						{
							ItemLockUpdateSocketHandler.sendLock(place,false);
						}
					}
				}else
				{
					MAlert.show(LanguageManager.getWord("ssztl.bag.sureToLock"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,lockAlertHandler);
					function lockAlertHandler(evt:CloseEvent):void
					{
						if(evt.detail == MAlert.OK)
						{
							ItemLockUpdateSocketHandler.sendLock(place,true);
						}
					}
				}
			}
			else if(source.getSourceType() == CellType.ROLECELL)
			{
//				if(!locked)
//				{
				dispatchEvent(new BagCellEvent(BagCellEvent.CELL_MOVE,{fromType:CommonBagType.BAG,place:bagItemInfo.place,toType:CommonBagType.BAG,toPlace:place,count:1}));
				action = DragActionType.DRAGIN;
//				}
			}
			else if(source.getSourceType() == CellType.PET_EQUIP)
			{
				var pet:PetItemInfo = GlobalData.petList.getFightPet();
				if(!pet)
					QuickTips.show('对不起，您只能卸下出战宠物身上的装备。');
				else
				{
					ItemMoveSocketHandler.sendItemMove(CommonBagType.PET_BAG,bagItemInfo.place,CommonBagType.BAG,place,pet.id);
				}
				action = DragActionType.DRAGIN;
			}
//			else if(source.getSourceType() == CellType.FURNACECELL)
//			{
//				action = DragActionType.DRAGIN;
//				GlobalData.clientBagInfo.removeFromFurnace(source["place"]);
//			}
			else if(source.getSourceType() == CellType.WAREHOUSECELL)
			{
				dispatchEvent(new BagCellEvent(BagCellEvent.CELL_MOVE,{fromType:CommonBagType.WAREHOUSE,place:bagItemInfo.place,toType:CommonBagType.BAG,toPlace:place,count:bagItemInfo.count}));
				action = DragActionType.DRAGIN;
			}
			else if(source.getSourceType() == CellType.TRADEDIRECTCELL)
			{
				TradeItemRemoveSocketHandler.sendRemove(bagItemInfo.place);
				action = DragActionType.DRAGIN;
			}
			return action;
		}
		
		private function setBagCellIn(bagItemInfo:ItemInfo):int
		{
			var action:int = DragActionType.UNDRAG;
			if(!locked)
			{
				if(itemInfo && !itemInfo.canOperate()){}
				else if(_index != 0){}
				else
				{
					action  = DragActionType.DRAGIN;
					bagItemInfo.lock = true;
					if(itemInfo)
					{
						itemInfo.lock = true;
					}
					dispatchEvent(new BagCellEvent(BagCellEvent.CELL_MOVE,{fromType:CommonBagType.BAG,place:bagItemInfo.place,toType:CommonBagType.BAG,toPlace:place,count:bagItemInfo.count}));
				}
			}
			return action;
		}
		
		override public function dragStop(data:IDragData):void
		{
			if(data.action == DragActionType.ONSELF)
			{
				if(GlobalData.bagInfo.currentDrag && GlobalData.bagInfo.currentDrag.place != place)
				{
					setBagCellIn(GlobalData.bagInfo.currentDrag);
				}
				else
				{
					locked = false;
				}
				return;
			}
			else if(data.action == DragActionType.UNDRAG)
			{
                //多次点击背包格子时，对itemInfo做一个判断，如果锁住，则把格子锁住，否则解锁				
				if(_iteminfo && _iteminfo.lock) locked = true;
				else locked = false
				return ;
			}
			if(data.action == DragActionType.NONE)
			{
				if(itemInfo != null)
				{
					if(!itemInfo.template.canDestory)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDrop"));
						return ;
					}
					MAlert.show(LanguageManager.getWord("ssztl.common.isSureDrop"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,dropAlertHandler);
				}
				locked = false;
				return;
			}
		}
		
		private function dropAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,itemInfo.place,CommonBagType.BAG,-1,itemInfo.count);			
			}
		}
		
		public function setIndex(index:int):void
		{
			_index = index;
		}
		
		private function recycleMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				dispatchEvent(new BagCellEvent(BagCellEvent.ITEM_RECYCLE,{place:itemInfo.place,count:itemInfo.count}));
			}
			else
			{
				dispatchEvent(new BagCellEvent(BagCellEvent.ITEM_RECYCLE,null));
			}
		}
		
		private function alertCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				dispatchEvent(new BagCellEvent(BagCellEvent.CELL_MOVE,{fromType:CommonBagType.BAG,place:itemInfo.place,toType:CommonBagType.BAG,toPlace:-1,count:itemInfo.count}));
//				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,itemInfo.place,CommonBagType.BAG,-1,itemInfo.count);			
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(itemInfo)
			{
				if(CategoryType.isWeapon(itemInfo.template.categoryId))
					TipsUtil.getInstance().show(itemInfo,GlobalData.bagInfo.getItem(5),new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
				else
					TipsUtil.getInstance().show(itemInfo,GlobalData.bagInfo.getEquipByCategory(itemInfo.template.categoryId),new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			}
		}
		
		override public function dispose():void
		{
			if(_iteminfo)
			{
				ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_ITEM_CD,updateItemCdHandler);
			}
			if(_timerEffect)
			{
				_timerEffect.dispose();
				_timerEffect = null;
			}
			clearCellEffect();
			_clickHandler = null;
			_doubleClickHandler = null;
			_closeBitmap = null;
			_countLabel = null;
			if(_lockIcon && _lockIcon.parent) _lockIcon.parent.removeChild(_lockIcon);
			_lockIcon = null;
			super.dispose();
		}
	}
}