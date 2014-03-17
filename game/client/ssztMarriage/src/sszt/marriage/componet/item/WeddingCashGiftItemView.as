package sszt.marriage.componet.item
{
	import flash.display.Bitmap;
	
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.marriage.WeddingCashGiftItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	public class WeddingCashGiftItemView extends MSprite
	{
		private var _data:WeddingCashGiftItemInfo;
		private var _currency:Bitmap;
		private var _nickLabel:MAssetLabel;
		private var _moneyLabel:MAssetLabel;
		
		public function WeddingCashGiftItemView(data:WeddingCashGiftItemInfo)
		{
			_data = data;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,340,30);
			graphics.endFill();
			
			_nickLabel = new MAssetLabel(_data.nick, MAssetLabel.LABEL_TYPE20, 'left');
			_nickLabel.move(10,7);
			addChild(_nickLabel);
			
			_currency = new Bitmap();
			_currency.x = 138;
			_currency.y = 6;
			addChild(_currency);
			
			var money:int;
			if(_data.copper > 0)
			{
				money = _data.copper;
				_currency.bitmapData = MoneyIconCaches.copperAsset;
			}
			else if(_data.yuanbao > 0)
			{
				money = _data.yuanbao;
				_currency.bitmapData = MoneyIconCaches.yuanBaoAsset;
			}
			_moneyLabel = new MAssetLabel(money.toString(), MAssetLabel.LABEL_TYPE20, 'left');
			_moneyLabel.move(158,7);
			addChild(_moneyLabel);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_currency = null;
			_data = null;
			_nickLabel = null;
			_moneyLabel = null;
		}
		
		
	}
}