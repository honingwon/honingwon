package sszt.marriage.componet.item
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.marriage.WeddingSelectedAsset;

	public class WeddingClassItem extends MSprite
	{
		private var _itemId:int;
		private var _price:int;
		private var _exp:int;
		
		private var _bg:IMovieWrapper;
		private var _selected:Boolean;
		private var _overBox:Bitmap;
		private var _selectedBox:Bitmap;
		
		private var _txtToken:RichTextField;
		private var _txtPrice:MAssetLabel;
		private var _txtTime:MAssetLabel;
		private var _txtWelfare:MAssetLabel;
		
		public function WeddingClassItem(itemId:int,price:int,exp:int)
		{
			_itemId = itemId;
			_price = price;
			_exp = exp;
			initView();
			initEvents();
		}
		private function initView():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,370,100);
			graphics.endFill();
			
			buttonMode = true;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(113,12,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.tagToken"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(113,32,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.tagCost"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(113,52,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.tagTime"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(113,72,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.marriage.tagWelfare"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(173,32,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
			]);
			addChild(_bg as DisplayObject);
			
			var str:String = '{I0-0-'+_itemId+'-0}'
			_txtToken = RichTextUtil.getOpenBoxRichText(str,100);
			_txtToken.x = 173;
			_txtToken.y = 12;
			addChild(_txtToken);
			
			_txtPrice = new MAssetLabel(_price.toString(),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_txtPrice.move(192,32);
			addChild(_txtPrice);
			
			_txtTime = new MAssetLabel("30" + LanguageManager.getWord("ssztl.common.minitueLabel"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTime.move(173,52);
			addChild(_txtTime);
			
			_txtWelfare = new MAssetLabel(LanguageManager.getWord("ssztl.marriage.tagWelfareCon",_exp.toString()),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtWelfare.move(173,72);
			addChild(_txtWelfare);
			
			_overBox = new Bitmap(new WeddingSelectedAsset());
			_overBox.alpha = 0.5;
			addChild(_overBox);
			_overBox.visible = false;
		}
		private function initEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function removeEvents():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(evt:MouseEvent):void
		{
			_overBox.visible = true;
		}
		private function outHandler(evt:MouseEvent):void
		{
			_overBox.visible = false;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(!_selectedBox)
			{
				_selectedBox = new Bitmap(new WeddingSelectedAsset());
				addChild(_selectedBox);
			}
			_selectedBox.visible = value;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_txtToken = null;
			_txtPrice = null;
			_txtTime = null;
			_txtWelfare = null;
		}
	}
}