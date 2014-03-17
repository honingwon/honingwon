package sszt.scene.components.newcomerGift
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.deployHandlers.GoNextTwoDeployHandler;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.NewcomerGiftMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;
	
	public class NewcomerGiftPanel extends MPanel
	{
		private var _mediator:NewcomerGiftMediator;
		private var _giftItemTemplateId:int;
		private var _giftItemTemplateInfo:ItemTemplateInfo;
		private var _items:Array;
		private var _itemsCount:Array;
		private var _itemAmount:int;
		
		private var _bg:IMovieWrapper;
		private var _titleIMG:Bitmap;
		
		private var _tile:MTile;
		private var _giftItemCell:BaseItemInfoCell;
		private var _txtGiftItemNeedLevel:MAssetLabel;
		private var _txtGiftTipLevel:MAssetLabel;
		private var _btnGetGiftItems:MCacheAssetBtn1;
		private var _btnSeeYou:MCacheAssetBtn1;
		
		public static const DEFAULT_WIDTH:int = 265;
		public static const DEFAULT_HEIGHT:int = 270;
		
		public function NewcomerGiftPanel(mediator:NewcomerGiftMediator,giftItemTemplateId:int)
		{
			var imageBtmp:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.NewcomerGiftTitleAsset"))
				imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.NewcomerGiftTitleAsset") as Class)());
			super(new MCacheTitle1("",imageBtmp),true,-1,true,true);
			
			_mediator = mediator;
			_giftItemTemplateId = giftItemTemplateId;
			initEvent();			
			setData();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(DEFAULT_WIDTH,DEFAULT_HEIGHT);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10,4,DEFAULT_WIDTH-20,210)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(10, 213, DEFAULT_WIDTH-20, 25), new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(10, 50, DEFAULT_WIDTH-20, 25), new MCacheCompartLine2()),
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(72,49,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(34,121,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(74,121,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(114,121,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(154,121,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(194,121,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(34,162,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(74,162,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(114,162,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(154,162,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(194,162,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addContent(_bg as DisplayObject);
			
			_titleIMG = new Bitmap(AssetUtil.getAsset("ssztui.common.GiftTitleImgAsset") as BitmapData);
			_titleIMG.x = 15;
			_titleIMG.y = -12;
			addContent(_titleIMG);
			
			_giftItemCell = new BaseItemInfoCell();
			_giftItemCell.move(72,49);
//			addContent(_giftItemCell);
			
			_txtGiftItemNeedLevel = new MAssetLabel('', MAssetLabel.LABEL_TYPE20);
			_txtGiftItemNeedLevel.setLabelType([new TextFormat("Microsoft Yahei",18,0xffff00)]);
			_txtGiftItemNeedLevel.move(132,18);
			addContent(_txtGiftItemNeedLevel);
			
			_txtGiftTipLevel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,'left');
			_txtGiftTipLevel.wordWrap = true;
			_txtGiftTipLevel.move(29,62);
			_txtGiftTipLevel.setSize(202,45);
			addContent(_txtGiftTipLevel);
			_txtGiftTipLevel.setHtmlValue(LanguageManager.getWord('ssztl.scene.growGiftDescript'));
			
			_tile = new MTile(40,41,5);
			_tile.setSize(198,80);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.move(34,121);
			addContent(_tile);
			
			_btnGetGiftItems = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.common.getGiftItems'));
			_btnSeeYou = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.common.seeYou'));
			_btnGetGiftItems.move(75,225);
			_btnSeeYou.move(75,225);
			addContent(_btnGetGiftItems);
			addContent(_btnSeeYou);
		}
		
		private function initEvent():void
		{
			_btnGetGiftItems.addEventListener(MouseEvent.CLICK, getGiftItems);
			_btnSeeYou.addEventListener(MouseEvent.CLICK, seeYou);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_NEWCOMER_GIFT_ICON, newcomerGiftUpdateHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.REMOVE_NEWCOMER_GIFT_ICON,seeYou);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
		}
		
		private function removeEvent():void
		{
			_btnGetGiftItems.removeEventListener(MouseEvent.CLICK, getGiftItems);
			_btnSeeYou.removeEventListener(MouseEvent.CLICK, seeYou);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_NEWCOMER_GIFT_ICON, newcomerGiftUpdateHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.REMOVE_NEWCOMER_GIFT_ICON,seeYou);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
		}
		
		private function upgradeHandler(e:CommonModuleEvent):void
		{
			updateBtnsView();
		}
		
		private function newcomerGiftUpdateHandler(e:SceneModuleEvent):void
		{
			_giftItemTemplateId= e.data as int;
			setData();
		}
		
		private function setData():void
		{
			getGiftItemInfo();
			
			clearView();
			
			_giftItemCell.info = _giftItemTemplateInfo;
			
			_txtGiftItemNeedLevel.setValue(LanguageManager.getWord('ssztl.common.giftNeedLevel', _giftItemTemplateInfo.needLevel));
			
			var cell:NewcomerGiftItemCell;
			var itemInfo:ItemInfo;
			for(var i:int = 0; i < _items.length; i++)
			{
				cell = new NewcomerGiftItemCell();
				itemInfo =new ItemInfo();
				itemInfo.isBind =  true;
				itemInfo.templateId = _items[i];
				itemInfo.count = _itemsCount[i];
				cell.itemInfo = itemInfo;
				_tile.appendItem(cell);
			}
			
			updateBtnsView();
		}
		
		private function clearView():void
		{
			_giftItemCell.info = null;
			_txtGiftItemNeedLevel.setValue('');
			_tile.disposeItems();
		}
		
		private function seeYou(e:Event):void
		{
			dispose();
		}
		
		private function getGiftItems(event:MouseEvent):void
		{
//			if(GlobalData.bagInfo.getHasPos(_itemAmount))
//			{
				var itemInfo:ItemInfo;
				var itemList:Array = GlobalData.bagInfo.getItemById(_giftItemTemplateId);
				if(itemList.length == 1)
				{
					itemInfo = itemList[0];
					ItemUseSocketHandler.sendItemUse(itemInfo.place);
				}
//			}
//			else
//			{
//				QuickTips.show(LanguageManager.getWord('ssztl.common.bagFull'));
//			}
		}
		
		private function getGiftItemInfo():void
		{
			_items = [];
			_itemsCount = [];
			_itemAmount = 0;
			_giftItemTemplateInfo = ItemTemplateList.getTemplate(_giftItemTemplateId);
			var itemInfoStrList:Array = _giftItemTemplateInfo.script.split('|');
			var itemInfo:Array;
			for(var i:int = 0; i < itemInfoStrList.length; i++)
			{
				itemInfo = String(itemInfoStrList[i]).split(',');
				_items.push(itemInfo[2]);
				_itemsCount.push(itemInfo[3]);
				if(itemInfo[2] != 1 && itemInfo[2] != 2 && itemInfo[2] != 3 && itemInfo[2] != 4)
				{
					_itemAmount++;
				}
			}
		}
		
		private function updateBtnsView():void
		{
			var playLevel:int = GlobalData.selfPlayer.level;
			if(playLevel >= _giftItemTemplateInfo.needLevel)
			{
				_btnSeeYou.visible = false;
				_btnGetGiftItems.visible = true;
			}
			else
			{
				_btnSeeYou.visible = true;
				_btnGetGiftItems.visible = false;
			}
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( (CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2);
		}
		
		private function useGiftItem():void
		{
			if(GlobalData.selfPlayer.level >= 10)
			{
				getGiftItems(null);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			useGiftItem();
			dispatchEvent(new Event(Event.CLOSE));
			
			_mediator = null;
			_giftItemTemplateInfo = null;
			_items = null;
			_itemsCount = null;
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_titleIMG && _titleIMG.bitmapData)
			{
				_titleIMG.bitmapData.dispose();
				_titleIMG.bitmapData = null;
				_titleIMG = null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			if(_giftItemCell)
			{
				_giftItemCell.dispose();
				_giftItemCell = null;
			}
			if(_btnGetGiftItems)
			{
				_btnGetGiftItems.dispose();
				_btnGetGiftItems = null;
			}
			if(_btnSeeYou)
			{
				_btnSeeYou.dispose();
				_btnSeeYou = null;
			}
			_txtGiftItemNeedLevel = null;
			_txtGiftTipLevel = null;
		}
	}
}