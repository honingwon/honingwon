package sszt.role.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.role.components.cell.Cell;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.role.exchangeIconAsset1;
	import ssztui.role.exchangeIconAsset2;
	import ssztui.role.exchangeIconAsset3;
	import ssztui.role.exchangeIconAsset4;

	public class ExchangeItemView extends Sprite
	{
		/**
		 * 0：神木，1：蚕丝 2：功勋，3：公会商城 
		 */		
		private var _index:int = 0;
		
		private var _icon:Bitmap;
		private var _btn:MCacheAssetBtn1;
		private var _title:MAssetLabel;
		private var _amount:MAssetLabel;
		private var _tile:MTile;
		private var _cellList:Array;
		/**
		 * 兑换物品所需的物品的模板编号 
		 */		                           //神木碎片,蚕丝碎片,
		private var _needItemArray:Array = [203019,203016];
		/**
		 * t_shop_template模板表shopid值 
		 */		
		private var _shopIdArray:Array = [ShopID.SM,ShopID.CS,ShopID.GX,ShopID.CLUB];
		
		private var _PAGE_SIZE:int = 7;
		private var _page:int = 0;
		
		public function ExchangeItemView(index:int)
		{
			_index = index;
			initView();
			initEvents();
			initData();
		}
		private function initView():void
		{	
			_icon = new Bitmap();
			_icon.x = _icon.y = 13;
			addChild(_icon);
			
			_amount = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.RIGHT);
			_amount.move(72,61);
			addChild(_amount);
			
			_title = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_title.setLabelType([new TextFormat("SimSun",12,0xdfc689,null,null,null,null,null,null,null,null,null,6)]);
			_title.textColor = 0xdfc689;
			_title.move(92,12);
			addChild(_title);
			
			_tile = new MTile(26,26,10);
			_tile.itemGapW = 3;
			_tile.itemGapH = 0;
			_tile.setSize(290,26);
			_tile.move(92,53);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_btn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.role.exchangeBtnLabel"));
			_btn.move(353,36);
			addChild(_btn);
			
			_cellList = [];
			for(var i:int=0; i<8; i++)
			{
				var cell:Cell = new Cell();
				_tile.appendItem(cell);
				_cellList.push(cell);
			}
		}
		
		public function initData():void
		{
			//Insert Data
			clearData();
			_title.setHtmlValue(LanguageManager.getWord("ssztl.role.exchangeCaption" + (_index+1)));
			switch(_index)
			{
				case 0:
					_icon.bitmapData = new exchangeIconAsset1() as BitmapData;
					if(GlobalData.bagInfo.getItemCountByItemplateId(_needItemArray[_index]) != 0)
					{
						_amount.setValue(GlobalData.bagInfo.getItemCountByItemplateId(_needItemArray[_index]).toString());
					}
					setCellData();
					break;
				case 1:
					_icon.bitmapData = new exchangeIconAsset2() as BitmapData;
					if(GlobalData.bagInfo.getItemCountByItemplateId(_needItemArray[_index]) != 0)
					{
						_amount.setValue(GlobalData.bagInfo.getItemCountByItemplateId(_needItemArray[_index]).toString());
					}
					setCellData();
					break;
				case 2:
					_icon.bitmapData = new exchangeIconAsset3() as BitmapData;
					if(GlobalData.pvpInfo.exploit != 0)
					{
						_amount.setHtmlValue(GlobalData.pvpInfo.exploit.toString());
					}
					setCellData();
					break;
				case 3:
					_icon.bitmapData = new exchangeIconAsset4() as BitmapData;
					if(GlobalData.selfPlayer.selfExploit != 0)
					{
						_amount.setHtmlValue(GlobalData.selfPlayer.selfExploit.toString());
					}
					setCellDataIndex3();
					break;
			}
			
		}
		
		private function setCellData():void
		{
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopIdArray[_index]);
			var list:Array = shop.getItems(_PAGE_SIZE,_page,0);
			for(var i:int = 0;i<list.length;i++)
			{
				var tempItem:ItemInfo = new ItemInfo();
				tempItem.templateId = list[i].template.templateId;
				_cellList[i].itemInfo = tempItem;
			}
		}
		
		private function setCellDataIndex3():void
		{
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopIdArray[_index]);
			var list:Array = shop.getItems(_PAGE_SIZE,0,0);
			for(var i:int = 0;i<list.length;i++)
			{
				var tempItem:ItemInfo = new ItemInfo();
				tempItem.templateId = list[i].template.templateId;
				_cellList[i].itemInfo = tempItem;
			}
		}
		
		private function initEvents():void
		{
			_btn.addEventListener(MouseEvent.CLICK,onClickHanlder);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_EXPLOIT,updateExRoleExploit);
		}
		
		private function onClickHanlder(e:MouseEvent):void
		{
			switch(_index)
			{
				case 0:
//					QuickTips.show("功能未开放");
					SetModuleUtils.addExStore(new ToStoreData(_shopIdArray[_index],_index)); 
					break;
				case 1:
//					QuickTips.show("功能未开放");
					SetModuleUtils.addExStore(new ToStoreData(_shopIdArray[_index],_index)); 
					break;
				case 2:
//					SetModuleUtils.addNPCStore(new ToNpcStoreData(_shopIdArray[_index],1));
					SetModuleUtils.addExStore(new ToStoreData(_shopIdArray[_index],_index)); 
					break;
				case 3:
					if(GlobalData.selfPlayer.clubId != 0)
					{
						SetModuleUtils.addClub(6,1);
					}
					else
					{
						SetModuleUtils.addClub(3); 
						QuickTips.show(LanguageManager.getWord("ssztl.club.joinClub"));
					}
					break;
			}
		}
		
		private function updateExRoleExploit(evt:CommonModuleEvent):void
		{
			initData();
		}
		
		private function clearData():void
		{			
			for(var i:int = 0;i<_cellList.length;i++)
			{
				_cellList[i].itemInfo = null;
			}
			_amount.setValue("");
			_title.setValue("");
		}
		
		private function removeEvents():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,onClickHanlder);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_EXPLOIT,updateExRoleExploit);
		}
		
		public function dispose():void
		{
			removeEvents();
		}
	}
}