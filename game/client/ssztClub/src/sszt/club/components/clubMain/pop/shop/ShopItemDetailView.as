package sszt.club.components.clubMain.pop.shop
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	
	
	public class ShopItemDetailView extends Sprite
	{
		private var _info:ShopItemInfo;
		private var _cell:ShopItemCell;
		private var _nameField:MAssetLabel;
		private var _costField:MAssetLabel;
		private var _totalField:MAssetLabel;
//		private var _limitField:MAssetLabel;
		private var _addBtn:MCacheAssetBtn2;
		private var _reduceBtn:MCacheAssetBtn2;
		private var _countField:TextField;
		
		public function ShopItemDetailView()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(50,53,55,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.singlePrice"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));	
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(10,138,55,17),new MAssetLabel(LanguageManager.getWord("ssztl.store.limitCount"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			var label:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.count") + "：",MAssetLabel.LABEL_TYPE_TAG);
			label.move(10,125);
			addChild(label);			
			
			//var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.club.contributionPointNeeded") + "：",MAssetLabel.LABEL_TYPE_TAG);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.shenNong.totalCalculateWord") + "：",MAssetLabel.LABEL_TYPE_TAG);
			label2.move(10,148);
			addChild(label2);
			
			_nameField = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_nameField.move(50,33); //50,53
			_nameField.setSize(80,20);
			addChild(_nameField);
			
			_costField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_costField.move(87,53);
			_costField.setSize(80,17);
			addChild(_costField);
			
			_totalField = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_totalField.move(47,148);
			_totalField.setSize(80,17);
			addChild(_totalField);
			
//			_limitField = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
//			_limitField.move(47,138);
//			_limitField.setSize(80,17);
//			_limitField.setValue("5");
//			addChild(_limitField);
			
			_addBtn = new MCacheAssetBtn2(0);
			_addBtn.move(107, 123);
			addChild(_addBtn);
			_reduceBtn = new MCacheAssetBtn2(1);
			_reduceBtn.move(55, 123);
			addChild(_reduceBtn);
			
			_countField = new TextField();
			_countField.defaultTextFormat = new TextFormat("Tahoma",12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_countField.width = 36;
			_countField.height = 18;
			_countField.x = 71;
			_countField.y = 123;
			_countField.type = TextFieldType.INPUT;
			_countField.restrict = "0123456789";
			_countField.maxChars = 2;
			addChild(_countField);
			
			_cell = new ShopItemCell();
			_cell.move(8, 31);
			addChild(_cell);
		}
		
		public function set info(value:ShopItemInfo):void
		{
			if(_info == value)return;
			_info = value;
			if(_info)
			{
				_nameField.setValue(_info.template.name);
				_nameField.textColor = CategoryType.getQualityColor(_info.template.quality);
				_countField.text = "1";
				_countField.mouseEnabled = true;
				_costField.setValue(_info.price  + _info.getPriceTypeString());
				_totalField.setValue(_info.price + _info.getPriceTypeString());
				_cell.shopItemInfo = _info;
			}
			else
			{
				_nameField.setValue("");
				_countField.text = "";
				_countField.mouseEnabled = false;
				_costField.setValue("");
				_cell.shopItemInfo = null;
			}
		}
		public function get info():ShopItemInfo
		{
			return _info;
		}
		
		private function initEvent():void
		{
			_addBtn.addEventListener(MouseEvent.CLICK,addClickHandler);
			_reduceBtn.addEventListener(MouseEvent.CLICK,reduceClickHandler);
			_countField.addEventListener(Event.CHANGE,countChangeHandler);
		}
		
		private function removeEvent():void
		{
			_addBtn.removeEventListener(MouseEvent.CLICK,addClickHandler);
			_reduceBtn.removeEventListener(MouseEvent.CLICK,reduceClickHandler);
			_countField.removeEventListener(Event.CHANGE,countChangeHandler);
		}
		
		private function addClickHandler(evt:MouseEvent):void
		{
			if(_info == null)return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var count:int = int(_countField.text);
			if(count >= 99)_countField.text = "99";
			else _countField.text = String(count + 1);
			_totalField.setValue((_info.price * getCount()) + _info.getPriceTypeString());
		}
		
		private function reduceClickHandler(evt:MouseEvent):void
		{
			if(_info == null)return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var count:int = int(_countField.text);
			if(count < 2)_countField.text = "1";
			else _countField.text = String(count - 1);
			_totalField.setValue((_info.price * getCount()) + _info.getPriceTypeString());
		}
		
		private function countChangeHandler(e:Event):void
		{
			var count:int = int(_countField.text);
			if(count < 1)count = 1;
			else if(count > 99)count = 99;
			_countField.text = String(count);
			_totalField.setValue((_info.price * getCount()) + _info.getPriceTypeString());
		}
		
		public function getCount():int
		{
			return int(_countField.text);
		}
		
		public function getNeedMoney():int
		{
			return _info.price * getCount();
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x  = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
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
			_info = null;
		}
	}
}