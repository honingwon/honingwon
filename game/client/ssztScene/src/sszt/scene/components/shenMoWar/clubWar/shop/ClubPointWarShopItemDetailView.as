package sszt.scene.components.shenMoWar.clubWar.shop
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import mhsm.ui.AddBtnAsset;
	import mhsm.ui.ReduceBtnAsset;
	
	public class ClubPointWarShopItemDetailView extends Sprite
	{
		private var _info:ShopItemInfo;
		private var _cell:ClubPointWarShopItemCell;
		private var _nameField:MAssetLabel;
		private var _costField:MAssetLabel;
		private var _addBtn:MBitmapButton;
		private var _reduceBtn:MBitmapButton;
		private var _countField:TextField;
		
		public function ClubPointWarShopItemDetailView()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			var label:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.num"),MAssetLabel.LABELTYPE4);
			label.move(9,71);
			addChild(label);
			
			_nameField = new MAssetLabel("",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
			_nameField.move(47,38);
			_nameField.setSize(80,20);
			addChild(_nameField);
			_costField = new MAssetLabel("",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
			_costField.move(15,125);
			_costField.setSize(80,20);
			addChild(_costField);
			
			_addBtn = new MBitmapButton(new AddBtnAsset());
			_addBtn.move(125,68);
			addChild(_addBtn);
			_reduceBtn = new MBitmapButton(new ReduceBtnAsset());
			_reduceBtn.move(48,68);
			addChild(_reduceBtn);
			
			_countField = new TextField();
			_countField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_countField.width = 50;
			_countField.height = 20;
			_countField.x = 73;
			_countField.y = 70;
			_countField.type = TextFieldType.INPUT;
			_countField.restrict = "0123456789";
			_countField.maxChars = 2;
			addChild(_countField);
			
			_cell = new ClubPointWarShopItemCell();
			_cell.move(0,20);
			addChild(_cell);
		}
		
		public function set info(value:ShopItemInfo):void
		{
			if(_info == value)return;
			_info = value;
			if(_info)
			{
				_nameField.setValue(_info.template.name);
				_countField.text = "1";
				_countField.mouseEnabled = true;
				_costField.setValue(_info.getPriceTypeString() + "：" + _info.price);
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
			_costField.setValue(_info.getPriceTypeString() + "：" + (_info.price * getCount()));
		}
		
		private function reduceClickHandler(evt:MouseEvent):void
		{
			if(_info == null)return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var count:int = int(_countField.text);
			if(count < 2)_countField.text = "1";
			else _countField.text = String(count - 1);
			_costField.setValue(_info.getPriceTypeString() + "：" + (_info.price * getCount()));
		}
		
		private function countChangeHandler(e:Event):void
		{
			var count:int = int(_countField.text);
			if(count < 1)count = 1;
			else if(count > 99)count = 99;
			_countField.text = String(count);
			_costField.setValue(_info.getPriceTypeString() + "：" + (_info.price * getCount()));
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
			_nameField = null;
			_costField = null;
			_countField = null;
			if(parent)parent.removeChild(this);
		}
	}
}