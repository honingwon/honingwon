package sszt.common.npcStore.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.common.npcStore.controllers.NPCStoreController;
	import sszt.common.npcStore.events.NPCStoreEvent;
	import sszt.constData.DragActionType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.ItemSellSocketHandler;
	import sszt.core.socketHandlers.store.ItemBuyBackSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	
	public class NPCStoreCell extends BaseCell
	{
		private var _shopItem:ShopItemInfo;
		private var tempItemInfo:ItemInfo;
		private var _controller:NPCStoreController;
		private var _priceValue:MAssetLabel;
		private var _nameValue:MAssetLabel;
		private var _shopType:int;
		private var _selected:Boolean;
		private var _boader:IMovieWrapper;
		private var _copperAsset:Bitmap;
		
		public function NPCStoreCell(control:NPCStoreController,type:int)
		{
			_controller = control;
			_shopType = type;
			super();
//			initView();
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(0, 0, 38, 38);
		}
		/*
		override protected function createPicComplete(data:BitmapData):void
		{
			super.createPicComplete(data);
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected) _boader.visible = true;
			else _boader.visible = false;
		}
		
		private function initView():void
		{
			_priceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_priceValue.move(65,24);
			addChild(_priceValue);
			
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameValue.move(46,7);
			addChild(_nameValue);
			
			_boader = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_15,new Rectangle(0, 0, 138, 46)),
			]);
			addChild(_boader as DisplayObject);
			_boader.visible = false;
			
			_copperAsset = new Bitmap(MoneyIconCaches.bingCopperAsset);
			_copperAsset.x = 46;
			_copperAsset.y = 25;
			addChild(_copperAsset);
			_copperAsset.visible = false;
			
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.x = _over.y = 4;
			_over.visible = false;
			addChild(_over);
		}
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
				
		public function set shopItem(item:ShopItemInfo):void
		{
			if(_shopItem == item) return;
			_shopItem = item;
			if(_shopItem)
			{
				info = _shopItem.template;
			}else
			{
				info = null;
			}
			if(_shopItem)
			{
				this.visible = true;
//				_priceValue.setValue("价格:" + _shopItem.price + _shopItem.getPriceTypeString());
				_priceValue.setValue(''+  _shopItem.price);
				if(_shopItem.template) _nameValue.setValue(_shopItem.template.name);
				_copperAsset.visible = true;
			}else
			{
				this.visible = false;
				_copperAsset.visible = false;
			}
		}
		
		public function get shopItem():ShopItemInfo
		{
			return _shopItem;
		}
		*/		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
				
		private function alertCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				ItemSellSocketHandler.sendSell(tempItemInfo.place,tempItemInfo.count);
			}		
		}
		
		override public function dispose():void
		{
			_controller = null;
			_shopItem = null;
			tempItemInfo = null;
			_priceValue = null;
			_controller = null;
			if(_boader)
			{
				_boader.dispose();
				_boader = null;
			}
			_nameValue = null;
			_copperAsset = null;
			super.dispose();
		}
	}
}