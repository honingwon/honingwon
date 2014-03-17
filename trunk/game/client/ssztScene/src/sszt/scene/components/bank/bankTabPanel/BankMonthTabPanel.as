package sszt.scene.components.bank.bankTabPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.furnace.parametersList.StoneMatchTemplateList;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.data.bank.BankInfoEvent;
	import sszt.scene.data.bank.BankInfoItem;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.bank.BankBuySocketHandler;
	import sszt.scene.socketHandlers.bank.BankGetSocketHandler;
	import sszt.scene.socketHandlers.bank.BankInfoListSocketHandler;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;

	public class BankMonthTabPanel extends Sprite  implements IBankTabPanel
	{
		public const AWARD_DAY:Array = [0,1];
		public const AWARD_COUNTS:Array = [1500,105];
		private var _mediator:SceneMediator;
		private var _titleLabel:MAssetLabel;
		private var _totalGetLabel:MAssetLabel;
		private var _tipsLabel:MAssetLabel;
		private var _awardState:MScrollPanel;
		private var _awardViewMTile:MTile;
		private var _awardItemViewList:Array;
		private var _awardType:int;
		private var _awardInfo:BankInfoItem;
		private var _buyBtn:MAssetButton1;
		private var _getBtn:MAssetButton1;
		private var _totalGet:int;
		private var _totalLeft:int;
		
		public function BankMonthTabPanel(mediator:SceneMediator)
		{
			_mediator = mediator;
			_awardInfo = _mediator.sceneModule.bankInfo.InfoDic[0] as BankInfoItem;
			_awardItemViewList = [];
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_titleLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_titleLabel.setLabelType([new TextFormat("Microsoft Yahei",18,0xFFcc00)]);
			_titleLabel.move(16,20);
			addChild(_titleLabel);
			_titleLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.monthTip"));
						
			_tipsLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_tipsLabel.move(16,50);
			addChild(_tipsLabel);
			_tipsLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.monthTip2"));
			
			_buyBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.common.BtnBankAsset") as MovieClip);
			_buyBtn.move(430,50);
			addChild(_buyBtn);
			
			_getBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.common.BtnBankAsset2") as MovieClip);
			_getBtn.move(430,50);
			addChild(_getBtn);
			
			_totalGetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_totalGetLabel.setLabelType([new TextFormat("Microsoft Yahei",18,0x33ff00)]);
//			_totalGetLabel.textColor = 0xff6633;
			_totalGetLabel.move(470,105);
			addChild(_totalGetLabel);
			
			_awardViewMTile = new MTile(565,30);
			_awardViewMTile.itemGapH = _awardViewMTile.itemGapW = 0;
			_awardViewMTile.setSize(565,180);
			_awardViewMTile.move(12,150);
			addChild(_awardViewMTile);
			_awardViewMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_awardViewMTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_awardViewMTile.verticalScrollBar.lineScrollSize = 30;	
			
			_totalGet = 0;
			_totalLeft=0;
			var index:int = 0;
			var level:int;
			var bankAwardItemView:BankAwardItemView;
			var day:int = (GlobalData.systemDate.getSystemDate().valueOf() /1000 - _awardInfo.addTime)/3600/24 + 1;
			for(;index<31;index++)
			{
				bankAwardItemView = new BankAwardItemView(index);
				if(index == 0)
				{	
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.monthFirst",AWARD_COUNTS[0]);
					bankAwardItemView.money = AWARD_COUNTS[index];
				}
				else
				{	
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.monthRequire",index,AWARD_COUNTS[1]);
					bankAwardItemView.money = AWARD_COUNTS[1];
				}
				if(_awardInfo.addTime <= 0 || day < index)
				{
					bankAwardItemView.state = 0;
					_totalLeft += index == 0 ?AWARD_COUNTS[0] : AWARD_COUNTS[1];
				}
				else if(_awardInfo.state >= index)// && index != 0)
				{
					bankAwardItemView.state = 1;
				}
				else
				{
					_getBtn.enabled = true;
					_totalGet += index == 0 ?AWARD_COUNTS[0] : AWARD_COUNTS[1];
					_totalLeft += index == 0 ?AWARD_COUNTS[0] : AWARD_COUNTS[1];
					bankAwardItemView.state = 2;
				}
				_awardViewMTile.appendItem(bankAwardItemView);
				_awardItemViewList.push(bankAwardItemView);
			}
			updateBtnView();
		}
		
		private function initialEvents():void
		{
			_mediator.sceneModule.bankInfo.addEventListener(BankInfoEvent.BANK_INFO_UPDATE,infoUpdateHandler);
			BankInfoListSocketHandler.send();
			_buyBtn.addEventListener(MouseEvent.CLICK,buyBtnClickHandler);
			_getBtn.addEventListener(MouseEvent.CLICK,getBtnClickHandler);
		}
		
		private function removeEvents():void
		{
			_mediator.sceneModule.bankInfo.removeEventListener(BankInfoEvent.BANK_INFO_UPDATE,infoUpdateHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyBtnClickHandler);
			_getBtn.removeEventListener(MouseEvent.CLICK,getBtnClickHandler);
		}
			
		
		private function updateAwardList():void
		{
			_totalGet = 0;
			_totalLeft=0;
			var index:int = 0;
			var level:int;
			var bankAwardItemView:BankAwardItemView;
			var day:int = int(GlobalData.systemDate.getSystemDate().valueOf()/1000/3600/24) - int(_awardInfo.addTime/3600/24) + 1;
//			trace("day:" + day +  "SystemDate:"+ GlobalData.systemDate.getSystemDate().valueOf() + "addTime:" + _awardInfo.addTime);
			for(;index<31;index++)
			{
				bankAwardItemView = _awardItemViewList[index];
				if(index == 0)
				{	
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.monthFirst",AWARD_COUNTS[0]);
					bankAwardItemView.money = AWARD_COUNTS[0];
				}
				else
				{	
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.monthRequire",index,AWARD_COUNTS[1]);
					bankAwardItemView.money = AWARD_COUNTS[1];
				}
				if(_awardInfo.addTime <= 0 || day < index)
				{
					bankAwardItemView.state = 0;
					_totalLeft += index == 0 ?AWARD_COUNTS[0] : AWARD_COUNTS[1];
				}
				else if(_awardInfo.state >= index)// && index != 0)
				{
					bankAwardItemView.state = 1;
				}
				else
				{
					_totalGet += index == 0 ?AWARD_COUNTS[0] : AWARD_COUNTS[1];
					_totalLeft += index == 0 ?AWARD_COUNTS[0] : AWARD_COUNTS[1];
					bankAwardItemView.state = 2;
				}
			}
			updateBtnView();
		}
		private function infoUpdateHandler(e:BankInfoEvent):void
		{
			_awardInfo = _mediator.sceneModule.bankInfo.InfoDic[type] as BankInfoItem;
			updateAwardList()
		}
		private function buyBtnClickHandler(e:MouseEvent):void
		{
			BankBuySocketHandler.send(this.type);
		}
		private function getBtnClickHandler(e:MouseEvent):void
		{
			BankGetSocketHandler.send(this.type);
		}
		private function updateBtnView():void
		{
			if(_awardInfo.addTime <= 0)
			{	
				_totalGetLabel.visible = false;
				_getBtn.visible = false;
				_buyBtn.visible = true;
			}
			else
			{	
				_totalGetLabel.visible = true;
				if(_totalGet == 0)
				{
					_getBtn.enabled = false;
					if(_totalLeft == 0)
					{
						_totalGetLabel.setValue(LanguageManager.getWord("ssztl.bank.levelTotalNoLeft"));
					}
					else
					{
						_totalGetLabel.setValue(LanguageManager.getWord("ssztl.bank.levelTotalLeft",_totalLeft));
					}
				}
				else
				{
					_getBtn.enabled = true;
					_totalGetLabel.setValue(LanguageManager.getWord("ssztl.bank.levelTotalGet1",_totalGet));
				}
				_getBtn.visible = true;
				_buyBtn.visible = false;
			}
		}
		
		public function get type():int
		{
			return _awardInfo.type;
		}
		public function show():void
		{
//			initialData(null);
//			this._pageView.setPageFieldValue();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator = null;
			if(_awardViewMTile)
			{
				_awardViewMTile.disposeItems();
				_awardViewMTile.dispose();
				_awardViewMTile = null;
			}
			_tipsLabel = null;
		}
	}
}