package sszt.consign.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.consign.components.SearchItemCell;
	import sszt.consign.data.ConsignType;
	import sszt.consign.data.Item.MyItemInfo;
	import sszt.constData.CategoryType;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.consign.IconMoneyAsset;
	import ssztui.consign.IconYuanbaoAsset;
	import ssztui.ui.CopperAsset;
	import ssztui.ui.YuanBaoAsset;
	
	public class MyItemView extends Sprite
	{
		private var _itemCell:SearchItemCell;
		private var _nameTextField:TextField;
		private var _allPriceTextField:TextField;
		private var _leftTimeTextField:TextField;
		private var _select:Boolean = false;
//		private var _framework:Shape;
		private var _myItemInfo:MyItemInfo;
		
		private var _cancelBtn:MCacheAssetBtn1; //取回寄售
		private var _reTakeBtn:MCacheAssetBtn1; //取回
		private var _continueBtn:MCacheAssetBtn1;//再售
		
		private var _yuanBaoBitmap:Bitmap;
		private var _tongBiBitmap:Bitmap;
		
		public function get continueBtn():MCacheAssetBtn1
		{
			return _continueBtn;
		}

		public function get reTakeBtn():MCacheAssetBtn1
		{
			return _reTakeBtn;
		}

		public function get cancelBtn():MCacheAssetBtn1
		{
			return _cancelBtn;
		}
		
		public function MyItemView()
		{
			super();

//			/**加入点击触发背景**/
//			graphics.beginFill(0,0);
//			graphics.drawRect(0,0,230,44);
//			graphics.endFill();
		}
		
		private function initialView():void
		{
//			_framework = new Shape();
//			_framework.graphics.lineStyle(1,0xFFFFFF,0);
//			_framework.graphics.beginFill(0,0.2);
//			_framework.graphics.drawRect(0,0,252,48);
//			_framework.visible = false;
//			addChild(_framework);
//			
//			var cellBitmap:Bitmap = new Bitmap(CellCaches.getCellBg());
//			cellBitmap.x = 0;
//			cellBitmap.y = 0;
//			addChild(cellBitmap);
			
			_itemCell = new SearchItemCell();
			_itemCell.move(7,9);
			
			_nameTextField = new TextField();
			_nameTextField.selectable = false;
			_nameTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_nameTextField.maxChars = 10;
			_nameTextField.x = 52;
			_nameTextField.y = 10;
			_nameTextField.width = 90;
			_nameTextField.height = 20;
			addChild(_nameTextField);
			
			_allPriceTextField = new TextField();
			_allPriceTextField.selectable = false;
			_allPriceTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_allPriceTextField.maxChars = 9;
			_allPriceTextField.x = 52;
			_allPriceTextField.y = 30;
			_allPriceTextField.width = 90;
			_allPriceTextField.height = 20;
			addChild(_allPriceTextField);
			
			_leftTimeTextField = new TextField();
			_leftTimeTextField.selectable = false;
			_leftTimeTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_leftTimeTextField.x = 52;
			_leftTimeTextField.y = 30;
			_leftTimeTextField.width = 90;
			_leftTimeTextField.height = 17;
			addChild(_leftTimeTextField);
			
			_cancelBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(172,16);
			addChild(_cancelBtn);
			
			_reTakeBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.consign.getBack"));
			_reTakeBtn.move(172,5);
			addChild(_reTakeBtn);
			
			_continueBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.consign.continueConsign"));
			_continueBtn.move(172,28);
			addChild(_continueBtn);
			
		}
		
		private function updateTextField():void
		{
//			_qualityColor = 0xFFFFFF;
			if(_myItemInfo.itemInfo.template)
			{
				_nameTextField.textColor = CategoryType.getQualityColor(_myItemInfo.itemInfo.template.quality);
//				_allPriceTextField.textColor = CategoryType.getQualityColor(_myItemInfo.itemInfo.template.quality);
				
			}
			if(_myItemInfo.consignType == ConsignType.ITEM)
			{
				_itemCell.itemInfo = _myItemInfo.itemInfo;
				_nameTextField.text = _myItemInfo.itemInfo.template.name;
				addChild(_itemCell);
			}
			else if(_myItemInfo.consignType == ConsignType.COPPER)
			{
				_nameTextField.text = LanguageManager.getWord("ssztl.common.copperValue",_myItemInfo.total);
				_tongBiBitmap = new Bitmap();
				_tongBiBitmap.x = 10;
				_tongBiBitmap.y = 12;
				var tongBiBmpd:BitmapData = new IconMoneyAsset();
				_tongBiBitmap.bitmapData = tongBiBmpd;
				addChild(_tongBiBitmap);
			}
			else
			{
				_nameTextField.text = LanguageManager.getWord("ssztl.common.yuanBaoValue",_myItemInfo.total);
				_yuanBaoBitmap = new Bitmap();
				_yuanBaoBitmap.x = 10;
				_yuanBaoBitmap.y = 12;
				var yuanBaoBmpd:BitmapData = new IconYuanbaoAsset();
				_yuanBaoBitmap.bitmapData = yuanBaoBmpd;
				addChild(_yuanBaoBitmap);
			}
			
			if(_myItemInfo.leftTime > 0)
			{
				_leftTimeTextField.text = LanguageManager.getWord("ssztl.consign.restoreHour",Math.ceil(_myItemInfo.leftTime/3600));
				_leftTimeTextField.visible = true;
				_allPriceTextField.visible = false;
				_cancelBtn.visible = false;
				_continueBtn.visible = true;
				_reTakeBtn.visible = true;
			}
			else
			{
				_allPriceTextField.text = LanguageManager.getWord("ssztl.common.price")+"：" + _myItemInfo.consignPrice + 
					(_myItemInfo.priceType==2?LanguageManager.getWord("ssztl.common.copper2"):LanguageManager.getWord("ssztl.common.yuanBao2"));
				
				_leftTimeTextField.visible = false;
				_cancelBtn.visible = true;
				_continueBtn.visible = false;
				_reTakeBtn.visible = false;
			}
			
		}
		
		public function itemName():String
		{
			return _nameTextField.text;
		}
		
		public function itemAllPrice():int
		{
			return int(_allPriceTextField.text);
		}
		
		public function itemLeftTime():String
		{
			return _leftTimeTextField.text;
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
		
		public function get myItemInfo():MyItemInfo
		{
			return _myItemInfo;
		}
		
		public function set myItemInfo(value:MyItemInfo):void
		{
			_myItemInfo = value;
			initialView();
			updateTextField();
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
			if(_itemCell)
			{
				_itemCell.dispose();
				_itemCell = null;
			}
			if(_reTakeBtn)
			{
				_reTakeBtn.dispose();
				_reTakeBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			if(_continueBtn)
			{
				_continueBtn.dispose();
				_continueBtn = null;
			}
			_nameTextField = null;
			_allPriceTextField = null;
			_leftTimeTextField = null;
//			_framework = null;
			_myItemInfo = null;
			
			_yuanBaoBitmap = null;
			_tongBiBitmap = null;
			
			if(parent) parent.removeChild(this);	

		}
	}
}