package sszt.consign.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	import sszt.consign.components.SearchItemCell;
	import sszt.consign.data.ConsignType;
	import sszt.consign.data.Item.SearchItemInfo;
	import sszt.consign.data.PriceType;
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.consign.IconMoneyAsset;
	import ssztui.consign.IconYuanbaoAsset;
	import ssztui.ui.CopperAsset;
	import ssztui.ui.YuanBaoAsset;
	
	public class SearchItemView extends Sprite
	{
		private var _itemCell:SearchItemCell;
		private var _nameTextField:TextField;
		private var _levelTextField:TextField;
		private var _careerTextField:TextField;
		private var _allPriceTextField:TextField;
		private var _buyBtn:MCacheAssetBtn1;
		private var _select:Boolean = false;
//		private var _framework:Shape;
		private var _seachInfo:SearchItemInfo;
		private var _qualityColor:int;
		
		private var _yuanBaoBitmap:Bitmap;
		private var _tongBiBitmap:Bitmap;
		private var _priceTypeIcon:Bitmap;
		
		public function SearchItemView()
		{
			super();
			/**加入点击触发背景**/
//			graphics.beginFill(0,0);
//			graphics.drawRect(0,0,391,48);
//			graphics.endFill();
		}
		
		public function get buyBtn():MCacheAssetBtn1
		{
			return _buyBtn;
		}
		
		private function initialView():void
		{
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.CENTER);
			
//			_framework = new Shape();
//			_framework.graphics.lineStyle(1,0xFFFFFF,0);
//			_framework.graphics.beginFill(0,0.3);
//			_framework.graphics.drawRect(0,0,391,48);
//			_framework.visible = false;
//			addChild(_framework);
			_priceTypeIcon = new Bitmap();
			_priceTypeIcon.x = 298;
			_priceTypeIcon.y = 13;
			addChild(_priceTypeIcon);
			
			var cellBitmap:Bitmap = new Bitmap(CellCaches.getCellBg());
			cellBitmap.x = 6;
			cellBitmap.y = 4;
			addChild(cellBitmap);			
			
			_nameTextField = new TextField();
			_nameTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x33ff00);
			_nameTextField.selectable = false;
			_nameTextField.maxChars = 10;
			_nameTextField.x = 50;
			_nameTextField.y = 13;
			_nameTextField.textColor = 0xFFFFFF;
			_nameTextField.width = 108;
			_nameTextField.height = 20;
			addChild(_nameTextField);
			
			_levelTextField = new TextField();
			_levelTextField.selectable = false;
			_levelTextField.maxChars = 2;
			_levelTextField.width = 62;
			_levelTextField.height = 20;
			_levelTextField.defaultTextFormat = format;
			_levelTextField.x = 160;
			_levelTextField.y = 15;
			addChild(_levelTextField);
			
			_careerTextField = new TextField();
			_careerTextField.selectable = false;
			_careerTextField.maxChars = 9;
			_careerTextField.width = 67;
			_careerTextField.height = 20;
			_careerTextField.defaultTextFormat = format;
			_careerTextField.x = 224;
			_careerTextField.y = 15;
			addChild(_careerTextField);
			
			_allPriceTextField = new TextField();
			_allPriceTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff9900);
			_allPriceTextField.selectable = false;
			_allPriceTextField.maxChars = 9;
			_allPriceTextField.width = 100;
			_allPriceTextField.height = 20;
			_allPriceTextField.x = 317;
			_allPriceTextField.y = 15;
			addChild(_allPriceTextField);
			
			_buyBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.buy"));
			_buyBtn.move(410,12);
			addChild(_buyBtn);
			
		}
		
		private function onBuyClick(e:MouseEvent):void
		{
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function updateTextField():void
		{
			_qualityColor = 0xFFFFFF;
			if(_seachInfo.itemInfo.template)
			{
				_nameTextField.text = _seachInfo.itemInfo.template.name;
				
				_nameTextField.textColor = CategoryType.getQualityColor(_seachInfo.itemInfo.template.quality);
//				_levelTextField.textColor = CategoryType.getQualityColor(_seachInfo.itemInfo.template.quality);
//				_careerTextField.textColor = CategoryType.getQualityColor(_seachInfo.itemInfo.template.quality);
//				_allPriceTextField.textColor = CategoryType.getQualityColor(_seachInfo.itemInfo.template.quality);
				
			}
			if(!(_seachInfo.itemInfo.template) || _seachInfo.itemInfo.template.needLevel == 0)
			{
				_levelTextField.text = LanguageManager.getWord("ssztl.common.none");
			}
			else
			{
				_levelTextField.text = LanguageManager.getWord("ssztl.common.levelValue",_seachInfo.itemInfo.template.needLevel);
			}
			var priceType:String = _seachInfo.priceType == PriceType.COPPER?LanguageManager.getWord("ssztl.common.copper2"):LanguageManager.getWord("ssztl.common.yuanBao2");
			if(_seachInfo.consignType == ConsignType.ITEM)
			{
				_itemCell = new SearchItemCell();
				_itemCell.move(6,4);
				addChild(_itemCell);
				
				_itemCell.itemInfo = _seachInfo.itemInfo;
				
				if(_seachInfo.itemInfo.template.needCareer == 0)
				{
					_careerTextField.text = LanguageManager.getWord("ssztl.common.normal");
				}
				else
				{
					_careerTextField.text = CareerType.getNameByCareer(_seachInfo.itemInfo.template.needCareer);
				}
				_priceTypeIcon.bitmapData =  _seachInfo.priceType == PriceType.COPPER?MoneyIconCaches.copperAsset:MoneyIconCaches.yuanBaoAsset;
				_allPriceTextField.text = _seachInfo.consignPrice.toString();// + priceType;
			}
			else
			{
				_careerTextField.text = LanguageManager.getWord("ssztl.common.normal");
				_levelTextField.text = LanguageManager.getWord("ssztl.common.normal");
				if(_seachInfo.consignType == ConsignType.COPPER)
				{
					_nameTextField.text = seachInfo.total + LanguageManager.getWord("ssztl.common.copper2");
					_allPriceTextField.text = _seachInfo.consignPrice.toString();// + LanguageManager.getWord("ssztl.common.yuanBao2");
					_priceTypeIcon.bitmapData =  MoneyIconCaches.yuanBaoAsset;
					_tongBiBitmap = new Bitmap();
					_tongBiBitmap.x = 9;
					_tongBiBitmap.y = 7;
					var tongBiBmpd:BitmapData = new IconMoneyAsset();
					_tongBiBitmap.bitmapData = tongBiBmpd;
					addChild(_tongBiBitmap);
				}
				if(_seachInfo.consignType == ConsignType.YUANBAO)
				{
					_nameTextField.text = seachInfo.total + LanguageManager.getWord("ssztl.common.yuanBao2");
					_allPriceTextField.text = _seachInfo.consignPrice.toString();// + LanguageManager.getWord("ssztl.common.copper2");
					_priceTypeIcon.bitmapData = MoneyIconCaches.copperAsset;
					_yuanBaoBitmap = new Bitmap();
					_yuanBaoBitmap.x = 9;
					_yuanBaoBitmap.y = 7;
					var yuanBaoBmpd:BitmapData = new IconYuanbaoAsset();
					_yuanBaoBitmap.bitmapData = yuanBaoBmpd;
					addChild(_yuanBaoBitmap);
				}
			}
		}
				
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(value:Boolean):void
		{
			_select = value;
//			if(_select)
//			{
//				_framework.visible = true;
//			}
//			else
//			{
//				_framework.visible = false;
//			}
		}
		
		public function get itemName():String
		{
			if(_seachInfo.consignType == ConsignType.ITEM)
			{
				return _seachInfo.itemInfo.template.name;
			}
			else if(_seachInfo.consignType == ConsignType.COPPER)
			{
				return LanguageManager.getWord("ssztl.common.copper2");
			}
			else if(_seachInfo.consignType == ConsignType.YUANBAO)
			{
				return LanguageManager.getWord("ssztl.common.yuanBao2");
			}
			return "";
		}
		
		public function get itemLevel():int
		{
			if(_seachInfo.consignType == ConsignType.ITEM)
			{
				return _seachInfo.itemInfo.template.needLevel;
			}
			else
			{
				return 0;
			}
			
		}
		
		public function get needCareer():int
		{
			if(_seachInfo.consignType == ConsignType.ITEM)
			{
				return _seachInfo.itemInfo.template.needCareer;
			}
			else
			{
				return 0;
			}
		}
		
		public function get itemAllPrice():int
		{
			return _seachInfo.consignPrice;
		}
		
		public function get seachInfo():SearchItemInfo
		{
			return _seachInfo;
		}

		public function set seachInfo(value:SearchItemInfo):void
		{
			_seachInfo = value;
			initialView();
			updateTextField();
		}
		
		public function get nameTextField():TextField
		{
			return _nameTextField;
		}

		public function get allPriceTextField():TextField
		{
			return _allPriceTextField;
		}

		public function dispose():void
		{
			if(_itemCell)
			{
				_itemCell.dispose();
				_itemCell = null;
			}
			_nameTextField = null;
			_levelTextField = null;
			_careerTextField = null;
			_allPriceTextField = null;
//			_framework = null;
			_seachInfo = null;
			if(_buyBtn)
			{
				_buyBtn.dispose();
				_buyBtn = null;
			}
		}
	}
}