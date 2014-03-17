package sszt.stall.compoments
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import sszt.core.data.player.PlayerMoneyResInfo;
	
	
	public class MoneyResField extends Sprite
	{
		private var _moneyResInfo:PlayerMoneyResInfo;
		
		public var _yuanbaoText:TextField;
		public var _copperText:TextField;
		public var _bindCopperText:TextField;
		
		public function MoneyResField()
		{
			super();
			initialView();
		}
		
		
		public function initialView():void
		{
			_yuanbaoText = new TextField();
			addChild(_yuanbaoText);
			
			_copperText = new TextField();
			addChild(_copperText);
			
			_bindCopperText = new TextField();
			addChild(_bindCopperText);
		}
		
		public function get moneyResInfo():PlayerMoneyResInfo
		{
			return _moneyResInfo;
		}
		
		public function set moneyResInfo(value:PlayerMoneyResInfo):void
		{
			_moneyResInfo = value;
			_yuanbaoText.text = _moneyResInfo.yuanBao.toString();;
			_copperText.text = _moneyResInfo.copper.toString();
			_bindCopperText.text = _moneyResInfo.bindCopper.toString();
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}

	}
}