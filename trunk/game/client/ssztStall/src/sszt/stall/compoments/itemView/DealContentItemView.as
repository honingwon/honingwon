package sszt.stall.compoments.itemView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.stall.StallDealItemInfo;
	import sszt.core.view.tips.ChatPlayerTip;
	
	public class DealContentItemView extends Sprite
	{
		private var _dealItenInfo:StallDealItemInfo;
		private var _nickTextField:MAssetLabel;;
		private var _itemNameTextField:MAssetLabel;
		private var _itemCountTextField:MAssetLabel;
		private var _otherTextField:MAssetLabel;
		private var _width:int;
		private var _nickBackground:Sprite;
		
		public function DealContentItemView(value:StallDealItemInfo,argWidth:int)
		{
			_width = argWidth;
			super();
			_dealItenInfo = value;
			updateView();
			initialEvents();
		}
		
		private function updateView():void
		{
			_nickTextField = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_nickTextField.autoSize = TextFieldAutoSize.LEFT;
			_nickTextField.x = 0;
			_nickTextField.y = 0;
			_nickTextField.text = _dealItenInfo.nick;
			_nickTextField.height = _nickTextField.textHeight;
			_nickTextField.width = _nickTextField.textWidth;
			addChild(_nickTextField);
			
			_nickBackground = new Sprite();
			_nickBackground.graphics.beginFill(0,0);
			_nickBackground.graphics.drawRect(_nickTextField.x,_nickTextField.y,_nickTextField.width,_nickTextField.height);
			_nickBackground.graphics.endFill();
			_nickBackground.buttonMode = true;
			addChild(_nickBackground);
			
			_otherTextField = new MAssetLabel("",MAssetLabel.LABELTYPE10);
			_otherTextField.autoSize = TextFieldAutoSize.LEFT;
			_otherTextField.x = _nickTextField.x + _nickTextField.width + 2;
			_otherTextField.y = 0;
			if(_dealItenInfo.isBuyOrSaleTag == 1)
			{
				_otherTextField.text = "在你摊位购买了：";
			}
			else
			{
				_otherTextField.text = "给你摊位出售了：";
			}
			_otherTextField.width = _otherTextField.textWidth;
			_otherTextField.height = _otherTextField.textHeight;
			addChild(_otherTextField);
			
			_itemNameTextField = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_itemNameTextField.autoSize = TextFieldAutoSize.LEFT;
			_itemNameTextField.x = _otherTextField.x + _otherTextField.width;
			_itemNameTextField.y = 0;
			_itemNameTextField.text = _dealItenInfo.itemName;
			_itemNameTextField.width = _itemNameTextField.textWidth;
			_itemNameTextField.height = _itemNameTextField.textHeight;
			addChild(_itemNameTextField);
			
			_itemCountTextField = new MAssetLabel("",MAssetLabel.LABELTYPE11);
			_itemCountTextField.multiline = true;
			_itemCountTextField.wordWrap = true;
			_itemCountTextField.autoSize = TextFieldAutoSize.LEFT;
			_itemCountTextField.x = _itemNameTextField.x + _itemNameTextField.width;
			_itemCountTextField.y = 0;
			_itemCountTextField.text = _dealItenInfo.itemCount.toString() + " 件";
			_itemCountTextField.width = _width - _itemNameTextField.x - _itemNameTextField.width;
			_itemCountTextField.height = _itemCountTextField.textHeight;
			addChild(_itemCountTextField);
		}
		
		private function initialEvents():void
		{
			_nickBackground.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvens():void
		{
			_nickBackground.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			ChatPlayerTip.getInstance().show(0, _dealItenInfo.userId,_dealItenInfo.nick,new Point(e.stageX,e.stageY));
		}
		
		public function dispose():void
		{
			removeEvens();
			_dealItenInfo = null;
			_nickTextField = null;
			_itemNameTextField = null;
			_itemCountTextField = null;
			_otherTextField = null;
			_nickBackground = null;
		}
	}
}