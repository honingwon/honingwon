package sszt.common.npcStore.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.common.npcStore.components.cell.NPCStoreCell;
	import sszt.common.npcStore.controllers.NPCStoreController;
	import sszt.constData.ShopID;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;

	public class ListItem extends Sprite
	{
		private var _shopItem:ShopItemInfo;
		private var _controller:NPCStoreController;
		private var _shopType:int;
		
		private var _priceValue:MAssetLabel;
		private var _nameValue:MAssetLabel;
		private var _selected:Boolean;
		private var _boader:IMovieWrapper;
		private var _copperAsset:Bitmap;
//		/**
//		 * 功勋图片 
//		 */		
//		private var _exploitAsset:Bitmap;
		private var _cell:NPCStoreCell;
		
		public function ListItem(control:NPCStoreController,type:int)
		{
			_controller = control;
			_shopType = type;
			super();
			initView();
		}
		private function initView():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,162,56);
			graphics.endFill();
			
			_cell = new NPCStoreCell(_controller,_shopType);
			_cell.x = 8;
			_cell.y = 9;				
			addChild(_cell);
			
			_priceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_priceValue.move(71,30);
			addChild(_priceValue);
			
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameValue.move(54,10);
			addChild(_nameValue);
			
			_boader = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_15,new Rectangle(0, 0, 162, 56)),
			]);
			addChild(_boader as DisplayObject);
			_boader.visible = false;
			
//			if(_shopType == ShopID.GX)
//			{
//				_exploitAsset = new Bitmap(MoneyIconCaches.bingCopperAsset);
//				_exploitAsset.x = 53;
//				_exploitAsset.y = 31;
//				addChild(_exploitAsset);
//				_exploitAsset.visible = false;
//			}
//			else
//			{
//				if(_shopItem.payType == 0)
//				{
//					_copperAsset = new Bitmap(MoneyIconCaches.copperAsset);
//					_copperAsset.x = 53;
//					_copperAsset.y = 31;
//					addChild(_copperAsset);
//					_copperAsset.visible = false;
//				}
//				else if(_shopItem.payType == 2)
//				{
//					_copperAsset = new Bitmap(MoneyIconCaches.bingYuanBaoAsset);
//					_copperAsset.x = 53;
//					_copperAsset.y = 31;
//					addChild(_copperAsset);
//					_copperAsset.visible = false;
//				}
//				else
//				{
//					_copperAsset = new Bitmap(MoneyIconCaches.bingCopperAsset);
//					_copperAsset.x = 53;
//					_copperAsset.y = 31;
//					addChild(_copperAsset);
//					_copperAsset.visible = false;
//				}
//			}
			
		}
		public function set shopItem(item:ShopItemInfo):void
		{
			if(_shopItem == item) return;
			_shopItem = item;
			if(_shopItem)
			{
				_cell.info = _shopItem.template;
			}else
			{
				_cell.info = null;
			}
			if(_shopItem)
			{
				this.visible = true;
				//_priceValue.setValue("价格:" + _shopItem.price + _shopItem.getPriceTypeString());
				_priceValue.setValue(''+  _shopItem.price);
				if(_shopItem.template) _nameValue.setValue(_shopItem.template.name);
				if(_shopType == ShopID.GX)
				{
					_copperAsset = new Bitmap(MoneyIconCaches.bingCopperAsset);
				}
				else
				{
					if(_shopItem.payType == 2)
					{
						_copperAsset = new Bitmap(MoneyIconCaches.bingYuanBaoAsset);
					}
					else
					{
						_copperAsset = new Bitmap(MoneyIconCaches.copperAsset);
					}
				}
				_copperAsset.x = 53;
				_copperAsset.y = 28;
				addChild(_copperAsset);
				buttonMode = true;
			}
			else
			{
				this.visible = false;
//				if(_shopType == ShopID.GX)
//				{
//					_exploitAsset.visible = false;
//				}
//				else
//				{
//					_copperAsset.visible = false;
//				}
				buttonMode = false;
			}
		}
		public function get shopItem():ShopItemInfo
		{
			return _shopItem;
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
		public function dispose():void
		{
			_controller = null;
			_shopItem = null;
			_priceValue = null;
			_controller = null;
			if(_boader)
			{
				_boader.dispose();
				_boader = null;
			}
			_nameValue = null;
//			if(_shopType == ShopID.GX)
//			{
//				_exploitAsset = null;
//			}
//			else
//			{
				_copperAsset = null;
//			}
			
		}
	}
}