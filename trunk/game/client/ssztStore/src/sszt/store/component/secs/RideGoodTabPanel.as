package sszt.store.component.secs
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import mhqy.ui.DragonBorder;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ICharacterWrapper;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.store.component.StoreCell;
	import sszt.store.component.StorePanel;
	import sszt.store.mediator.StoreMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.ui.CellBigBgAsset;
	
	public class RideGoodTabPanel extends Sprite implements IGoodTabPanel
	{
		private var _mediator:StoreMediator;
		private var _bg:IMovieWrapper;
		private var _returnBtn:MCacheAssetBtn1;
		private var _composeBuyBtn:MCacheAssetBtn1;
		private var _tile:MTile;
		private var _showBg:Bitmap;
//		private var _cells:Vector.<StoreCell>;
		private var _cells:Array;
		public static const PAGE_SIZE:int = 6;
		private var _shopType:int;
		private var _figurePlayer:FigurePlayerInfo;
		private var _character:ICharacterWrapper;
		private var _records:Dictionary;
		private var _currentCell:StoreCell;
		
		private var _tipBtns:Array;
		private var _labels:Array;
		
		public function RideGoodTabPanel(type:int,mediator:StoreMediator) 
		{
			_shopType = type;
			_mediator = mediator;
			_records = new Dictionary();
			_figurePlayer = new FigurePlayerInfo();
			_figurePlayer.sex = GlobalData.selfPlayer.sex;
			_figurePlayer.career = GlobalData.selfPlayer.career;
			_figurePlayer.updateStyle(0,0,0,0,0,0,false);	
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_showBg = new Bitmap();
			_showBg.x = 416;
			addChild(_showBg);
			
			_character = GlobalAPI.characterManager.createShowCharacterWrapper(_figurePlayer);
			_character.show(DirectType.LEFT,this);
			_character.move(522,225);
			
			_returnBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.store.reBack"));
			_returnBtn.move(451,267);
			addChild(_returnBtn);
			
			_composeBuyBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.store.composeBuy"));
			_composeBuyBtn.move(522,267);
			addChild(_composeBuyBtn);
			
			_labels = [LanguageManager.getWord("ssztl.store.reBackShape"),LanguageManager.getWord("ssztl.store.composeBuyItem")];
			_tipBtns = [_returnBtn,_composeBuyBtn];
			
			_tile = new MTile(207,87,2);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.setSize(416,350);
			_tile.move(0,0);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
//			_cells = new Vector.<StoreCell>();
			_cells = new Array();
			for(var i:int = 0;i<PAGE_SIZE;i++)
			{
				var cell:StoreCell = new StoreCell(_shopType);
				_cells.push(cell);
				_tile.appendItem(cell);
			}
			
//			_cheapInfoLabel.htmlText =LanguageManager.getWord("ssztl.store.limitedTimeItemExplain");
		}
		
		public function assetsCompleteHandler():void
		{
			_showBg.bitmapData = AssetUtil.getAsset("ssztui.store.ClothesBgAsset",BitmapData) as BitmapData;
		}
		
		private function initEvent():void
		{
			for(var i:int =0;i<_cells.length;i++)
			{
//				_cells[i].addEventListener(MouseEvent.CLICK,clickHandler);
				_cells[i].addEventListener(MouseEvent.CLICK,selectClickHandler);
			}
			_returnBtn.addEventListener(MouseEvent.CLICK,returnHandler);
			_composeBuyBtn.addEventListener(MouseEvent.CLICK,composeBuyHandler);
			for(i = 0;i<_tipBtns.length;i++)
			{
				_tipBtns[i].addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
				_tipBtns[i].addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var i:int =0;i<_cells.length;i++)
			{
//				_cells[i].removeEventListener(MouseEvent.CLICK,clickHandler);
				_cells[i].removeEventListener(MouseEvent.CLICK,selectClickHandler);
			}
			_returnBtn.removeEventListener(MouseEvent.CLICK,returnHandler);
			_composeBuyBtn.removeEventListener(MouseEvent.CLICK,composeBuyHandler);
			for(i = 0;i<_tipBtns.length;i++)
			{
				_tipBtns[i].removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
				_tipBtns[i].removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
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
		
		private function returnHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_figurePlayer.updateStyle(0,0,0,0,0,0,false);
			_records = new Dictionary();
			if(_currentCell) _currentCell.selected = false;
			_currentCell = null;
		}
		
		private function composeBuyHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var i:ShopItemInfo;
			var count:int = 0;
			var total:int = 0;
			var typeString:String = "";
			for each(i in _records)
			{
				total = total + i.price;
				typeString = i.getPriceTypeString();
				count++;
			}
			if(total > GlobalData.selfPlayer.userMoney.yuanBao)
			{
//				QuickTips.show("元宝不足，无法购买！");
//				return ;
				if(GlobalData.canCharge)
				{
					//MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
					function chargeAlertHandler(evt:CloseEvent):void
					{
						if(evt.detail == MAlert.OK)
						{
							JSUtils.gotoFill();
						}
					}
				}else
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoBuyFail"));
				}	
				return;
			}
			if(count>0)
			{
//				var message:String = "购买搭配商品一共花费"+ total + typeString + ",你确定要购买吗？";
				var message:String = LanguageManager.getWord("ssztl.store.isSureBuySuit",total + typeString);
				
				MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,buyMAlertHandler);
			}			
			else
				QuickTips.show(LanguageManager.getWord("ssztl.store.chooseComposeItem"));
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			var i:ShopItemInfo;
			if(evt.detail == MAlert.OK)
			{
				for each(i in _records)
				{
					var item:ShopItemInfo = i as ShopItemInfo;
//					ItemBuySocketHandler.sendBuy(_shopType,item.templateId,1,item.payType);
					ItemBuySocketHandler.sendBuy(item.id,1);
				}
			}
		}
		
		private function selectClickHandler(evt:MouseEvent):void
		{
			var cell:StoreCell = evt.currentTarget as StoreCell;
			
			if(_currentCell) _currentCell.selected = false;
			_currentCell = cell;
			_currentCell.selected = true;
			
			if(cell.shopItem)
			{
				if(cell.shopItem.template.needCareer != 0 && cell.shopItem.needCareer != GlobalData.selfPlayer.career)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.store.careerNotShit"));
					return ;
				}
				var sexValue:int = GlobalData.selfPlayer.sex ? 1:2;
				if(cell.shopItem.template.needSex !=0 && cell.shopItem.needSex != sexValue)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.store.sexNotShit"));
					return ;
				}
				if(CategoryType.FASION == cell.shopItem.template.categoryId)
				{
					_figurePlayer.updateStyle(cell.shopItem.templateId,_figurePlayer.style[1],_figurePlayer.style[2],_figurePlayer.style[3],0,60,false,false,_figurePlayer.style[2] != 0);
					_records[cell.shopItem.categoryId] = cell.shopItem;
					if(_records[CategoryType.CLOTH_SHANGWU]) delete _records[CategoryType.CLOTH_SHANGWU];
					if(_records[CategoryType.CLOTH_XIAOYAO]) delete _records[CategoryType.CLOTH_XIAOYAO];
					if(_records[CategoryType.CLOTH_LIUXING]) delete _records[CategoryType.CLOTH_LIUXING];
				}
				if(CategoryType.isCloth(cell.shopItem.template.categoryId))
				{
					_figurePlayer.updateStyle(cell.shopItem.templateId,_figurePlayer.style[1],_figurePlayer.style[2],_figurePlayer.style[3],0,60,false,false,_figurePlayer.style[2] != 0);
					_records[cell.shopItem.template.categoryId] = cell.shopItem;
					if(_records[CategoryType.FASION]) delete _records[CategoryType.FASION];
				}
				if(CategoryType.isWeapon(cell.shopItem.template.categoryId))
				{
					_figurePlayer.updateStyle(_figurePlayer.style[0],cell.shopItem.templateId,_figurePlayer.style[2],_figurePlayer.style[3],0,60,false,false,_figurePlayer.style[2] != 0);
					_records[cell.shopItem.template.categoryId] = cell.shopItem;
				}
				if(cell.shopItem.template.categoryId == CategoryType.MUNTS)
				{
					_figurePlayer.updateStyle(_figurePlayer.style[0],_figurePlayer.style[1],cell.shopItem.templateId,_figurePlayer.style[3],0,60,false,false,cell.shopItem.templateId != 0);
					_records[cell.shopItem.template.categoryId] = cell.shopItem;
				}
				if(cell.shopItem.template.categoryId == CategoryType.WING)
				{
					_figurePlayer.updateStyle(_figurePlayer.style[0],_figurePlayer.style[1],_figurePlayer.style[2],cell.shopItem.templateId,0,60,false,false,_figurePlayer.style[2] != 0);
					_records[cell.shopItem.template.categoryId] = cell.shopItem;
				}
			}
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			//衣服，武器，骑宠，翅膀
			var cell:StoreCell = evt.currentTarget as StoreCell;
//			if(cell.shopItem)
//			{
//				if(cell.shopItem.template.needCareer != 0 && cell.shopItem.needCareer != GlobalData.selfPlayer.career)
//				{
//					QuickTips.show("职业不符，不能试穿");
//					return ;
//				}
//				if(cell.shopItem.template.categoryId == CategoryType.CLOTH)
//				{
//					_figurePlayer.updateStyle(cell.shopItem.templateId,_figurePlayer.style[1],_figurePlayer.style[2],_figurePlayer.style[3],_figurePlayer.style[2] != 0);
//					_records[cell.shopItem.template.categoryId] = cell.shopItem;
//				}
//				if(CategoryType.isWeapon(cell.shopItem.template.categoryId))
//				{
//					_figurePlayer.updateStyle(_figurePlayer.style[0],cell.shopItem.templateId,_figurePlayer.style[2],_figurePlayer.style[3],_figurePlayer.style[2] != 0);
//					_records[cell.shopItem.template.categoryId] = cell.shopItem;
//				}
//				if(cell.shopItem.template.categoryId == CategoryType.MUNTS)
//				{
//					_figurePlayer.updateStyle(_figurePlayer.style[0],_figurePlayer.style[1],cell.shopItem.templateId,_figurePlayer.style[3],cell.shopItem.templateId != 0);
//					_records[cell.shopItem.template.categoryId] = cell.shopItem;
//				}
//				if(cell.shopItem.template.categoryId == CategoryType.WING)
//				{
//					_figurePlayer.updateStyle(_figurePlayer.style[0],_figurePlayer.style[1],_figurePlayer.style[2],cell.shopItem.templateId,_figurePlayer.style[2] != 0);
//					_records[cell.shopItem.template.categoryId] = cell.shopItem;
//				}
//			}
			if(_currentCell) _currentCell.selected = false;
			_currentCell = cell;
			_currentCell.selected = true;
		}
		
		private function clearCell():void
		{
			for(var i:int= 0;i<_cells.length;i++)
			{
				_cells[i].shopItem = null;
			}
		}
		
		public function showGoods(page:int,type:int):void
		{
			clearCell();
			var shop:ShopTemplateInfo =ShopTemplateList.getShop(_shopType);
//			var list:Vector.<ShopItemInfo> = shop.getItems(PAGE_SIZE,page,type);
			var list:Array = shop.getItems(PAGE_SIZE,page,type);
			for(var i:int =0;i<list.length;i++)
			{
				_cells[i].shopItem = list[i];
			}
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_showBg && _showBg.bitmapData)
			{
				_showBg.bitmapData.dispose();
				_showBg = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_returnBtn)
			{
				_returnBtn.dispose();
				_returnBtn = null;
			}
			if(_composeBuyBtn)
			{
				_composeBuyBtn.dispose();
				_composeBuyBtn = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_cells)
			{
				for(var i:int =0;i<_cells.length;i++)
				{
					_cells[i].dispose();
				}
				_cells = null;
			}
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			_currentCell = null;
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}