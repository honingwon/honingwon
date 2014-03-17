package sszt.consign.components.popupPanel
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.consign.ConsignModule;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.consign.socket.BillDealSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class YuanBaoPopUpPanel extends MPanel
	{
		private var _mediator:ConsignMediator;
		private var _bg:IMovieWrapper;
		private var _countValue:TextField;
		private var _priceValue:TextField;
		private var _totalValue:MAssetLabel;
		private var _btn:MCacheAsset1Btn;
		
		private var _countLabel:String;
		private var _priceLabel:String;
		private var _titleLabel:String;
		private var _isSelf:Boolean;
		/**0是买，1是卖**/
		private var _type:int;
		private var _price:int;
		private var _listId:int;

		public function YuanBaoPopUpPanel(mediator:ConsignMediator,type:int,isSelf:Boolean,price:int,listId:Number)
		{
			_mediator = mediator;
			_type = type;
			_isSelf = isSelf;
			_price = price;
			_listId = listId;
			if(type == 0)
			{
				_countLabel = LanguageManager.getWord("ssztl.consign.buyCount");
				_priceLabel = LanguageManager.getWord("ssztl.consign.buySinglePrice");
				_titleLabel = LanguageManager.getWord("ssztl.consign.buyYuanBao");
			}else
			{
				_countLabel = LanguageManager.getWord("ssztl.consign.sellCount");
				_priceLabel = LanguageManager.getWord("ssztl.consign.sellSinglePrice");
				_titleLabel = LanguageManager.getWord("ssztl.consign.sellYuanBao");
			}
			super(new MCacheTitle1(_titleLabel),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(291,150);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,291,119)),
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(81,9,152,22)),
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(81,36,152,22)),
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(81,63,152,22)),
				]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(25,12,52,16),new MAssetLabel(_countLabel,MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(25,39,52,16),new MAssetLabel(_priceLabel,MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(25,67,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.consign.allNeed"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(236,12,28,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao2"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(126,94,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.consign.promptMessage"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			
			_totalValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_totalValue.move(83,65);
			addContent(_totalValue);
			
			_countValue = new TextField();
			_countValue.type = TextFieldType.INPUT;
			_countValue.restrict = "0123456789";
			_countValue.maxChars = 5;
			_countValue.width = 152;
			_countValue.height = 22;
			_countValue.x = 83;
			_countValue.y = 9;
			_countValue.textColor = 0xffffff;
			addContent(_countValue);
			
			_priceValue = new TextField();
			if(_isSelf)	_priceValue.type = TextFieldType.INPUT;
			else _priceValue.mouseEnabled = _priceValue.mouseWheelEnabled = false;
			_priceValue.maxChars = 5;
			_priceValue.restrict = "0123456789";
			_priceValue.width = 152;
			_priceValue.height = 22;
			_priceValue.x = 83;
			_priceValue.y = 36;
			_priceValue.textColor = 0xffffff;
			_priceValue.text = String(_price);
			addContent(_priceValue);
			
			_btn = new MCacheAsset1Btn(0,_titleLabel);
			_btn.enabled = false;
			_btn.move(112,122);
			addContent(_btn);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			_countValue.addEventListener(Event.CHANGE,countChangeHandler);
			if(_isSelf)
				_priceValue.addEventListener(Event.CHANGE,priceChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,clickHandler);
			_countValue.removeEventListener(Event.CHANGE,countChangeHandler);
			if(_isSelf)
				_priceValue.removeEventListener(Event.CHANGE,priceChangeHandler);
		}
		
		private function countChangeHandler(evt:Event):void
		{
			var tmpTotalValue:int = int(_countValue.text)*int(_priceValue.text);
			_totalValue.setValue(tmpTotalValue.toString());
			if(_type == 0 && tmpTotalValue > GlobalData.selfPlayer.userMoney.copper)
			{
				QuickTips.show("你的背包余额不足");
				_btn.enabled = false;
				return;
			}
			if(_type == 1 && int(_countValue.text) > GlobalData.selfPlayer.userMoney.yuanBao)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnoughShort"));
				_btn.enabled = false;
				return;sss
			}
			_btn.enabled = true;
		}
		
		private function priceChangeHandler(evt:Event):void
		{
			var tmpTotalValue:int = int(_countValue.text)*int(_priceValue.text);
			_totalValue.setValue(tmpTotalValue.toString());
			if(_type == 0 && tmpTotalValue > GlobalData.selfPlayer.userMoney.copper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftMoneyNotEnough"));
				_btn.enabled = false;
				return;
			}
			_btn.enabled = true;
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			if(_isSelf)
			{
				_mediator.sendBillDeal(int(_countValue.text),int(_priceValue.text),_type);
			}
			else
			{
				_mediator.sendGoldDeal(_listId,int(_countValue.text));
//				_mediator.module.goldConsignInfo.removeItem(tmpListId);
			}
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_countValue = null;
			_priceValue = null;
			_totalValue = null;
			if(_btn)
			{
				_btn.dispose();
				_btn = null;
			}
			super.dispose();
		}
	}
}