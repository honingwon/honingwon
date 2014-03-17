package sszt.scene.components.bank.bankTabPanel
{
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.bank.BankLevelTypeCombox;
	import sszt.scene.data.bank.BankInfo;
	import sszt.scene.data.bank.BankInfoEvent;
	import sszt.scene.data.bank.BankInfoItem;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.bank.BankBuySocketHandler;
	import sszt.scene.socketHandlers.bank.BankGetSocketHandler;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.page.PageView;
	
	import ssztui.ui.SmallBtnDownAsset;

	public class BankLevelTabPanel extends Sprite implements IBankTabPanel
	{
		public const AWARD_LEVEL:Array = [0,40,45,50,55,60,65,70,75,80];
		public const AWARD_PERCENT:Array = [30,30,40,40,50,50,60,60,70,70];
		private var _mediator:SceneMediator;
		private var _titleLabel:MAssetLabel;
		private var _tipsLabel:MAssetLabel;
		private var _totalBuyLabel:MAssetLabel;
		private var _totalGetLabel:MAssetLabel
		private var _awardState:MScrollPanel;
		private var _awardViewMTile:MTile;
		private var _awardItemViewList:Array;
		private var _awardType:int;
		private var _awardInfo:BankInfoItem;
		private var _buyBtn:MAssetButton1;
		private var _getBtn:MAssetButton1;
		private var _btnSelect:MAssetButton1;
		private var _bankLevelTypeCombox:ComboBox;
		private var _totalBuy:int;
		private var _totalGet:int;
		private var _totalLeft:int;
		
		public function BankLevelTabPanel(mediator:SceneMediator)
		{
			_mediator = mediator;	
			_awardInfo = _mediator.sceneModule.bankInfo.InfoDic[1] as BankInfoItem;
			
			_awardItemViewList = [];
			initialView();
			initialEvents();
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.MATERIAL));
		}
		
		private function initialView():void
		{	
			_titleLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_titleLabel.setLabelType([new TextFormat("Microsoft Yahei",18,0xFFcc00)]);
			_titleLabel.move(16,20);
			addChild(_titleLabel);
			_titleLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.levelTip"));
			
			_tipsLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_tipsLabel.move(16,50);
			addChild(_tipsLabel);
			_tipsLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.levelTip2"));
			
			_buyBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.common.BtnBankAsset") as MovieClip);
			_buyBtn.move(430,50);
			addChild(_buyBtn);
			
			_getBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.common.BtnBankAsset2") as MovieClip);
			_getBtn.move(430,50);
			addChild(_getBtn);
			
			_totalBuyLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,"left");
			_totalBuyLabel.textColor = 0xff6633;
			_totalBuyLabel.move(16,89);
			addChild(_totalBuyLabel);
			
			_totalGetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_totalGetLabel.setLabelType([new TextFormat("Microsoft Yahei",18,0x33ff00)]);
//			_totalGetLabel.textColor = 0xff6633;
			_totalGetLabel.move(470,105);
			addChild(_totalGetLabel);
			
//			_bankLevelTypeCombox = new ComboBox();
//			_bankLevelTypeCombox.move(80,100);
//			addChild(_bankLevelTypeCombox);
//			_bankLevelTypeCombox.visible = false;
			
			
			_bankLevelTypeCombox = new ComboBox();
			_bankLevelTypeCombox.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_bankLevelTypeCombox.x = 80;
			_bankLevelTypeCombox.y = 107;
			_bankLevelTypeCombox.width = 78;
			_bankLevelTypeCombox.height = 22;
			addChild(_bankLevelTypeCombox);
			_bankLevelTypeCombox.dataProvider = new DataProvider([{label:BankInfo.MONEY[1].toString(),value:1},
				{label:BankInfo.MONEY[2].toString(),value:2},
				{label:BankInfo.MONEY[3].toString(),value:3},
				{label:BankInfo.MONEY[4].toString(),value:4},
				{label:BankInfo.MONEY[5].toString(),value:5}]);
//				{label:BankInfo.MONEY[6].toString(),value:6}
			_bankLevelTypeCombox.selectedIndex = 0;
			
//			_btnSelect = new MAssetButton1(SmallBtnDownAsset);
//			_btnSelect.move(130,80);
//			addChild(_btnSelect);
			
			_awardViewMTile = new MTile(565,30);
			_awardViewMTile.itemGapH = _awardViewMTile.itemGapW = 0;
			_awardViewMTile.setSize(565,180);
			_awardViewMTile.move(12,150);
			addChild(_awardViewMTile);
			_awardViewMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_awardViewMTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_awardViewMTile.verticalScrollBar.lineScrollSize = 30;		
			
//			_typeLabel.setValue(_awardInfo.money.toString());
			_totalLeft =0;
			_totalGet = 0;
			var index:int = 0;
			var level:int;
			var bankAwardItemView:BankAwardItemView;
			for(;index<AWARD_LEVEL.length;index++)
			{
				bankAwardItemView = new BankAwardItemView(index);
				if(index == 0)
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.levelFirst",AWARD_PERCENT[index]);
				else
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.levelRequire",AWARD_LEVEL[index],AWARD_PERCENT[index]);
				bankAwardItemView.money = int(_awardInfo.money * AWARD_PERCENT[index] / 100);
				if(_awardInfo.addTime <= 0 || GlobalData.selfPlayer.level < AWARD_LEVEL[index])
				{
					bankAwardItemView.state = 0;
					_totalLeft += int(_awardInfo.money * AWARD_PERCENT[index] / 100);
				}
				else if(_awardInfo.state >= AWARD_LEVEL[index])
				{
					bankAwardItemView.state = 1;
				}
				else
				{
					_totalGet += int(_awardInfo.money * AWARD_PERCENT[index] / 100);
					_totalLeft += int(_awardInfo.money * AWARD_PERCENT[index] / 100);
					bankAwardItemView.state = 2;
				}
				_awardViewMTile.appendItem(bankAwardItemView);
				_awardItemViewList.push(bankAwardItemView);
			}
			updateTotal();
			updateBtnView();
		}
		
		private function initialEvents():void
		{			
//			_btnSelect.addEventListener(MouseEvent.CLICK, selectHandler);
			_bankLevelTypeCombox.addEventListener(Event.CHANGE,comboChangeHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyBtnClickHandler);
			_getBtn.addEventListener(MouseEvent.CLICK,getBtnClickHandler);
			_mediator.sceneModule.bankInfo.addEventListener(BankInfoEvent.BANK_INFO_UPDATE,infoUpdateHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE, upgradeHandler);
		}
		
		private function removeEvents():void
		{
//			_btnSelect.removeEventListener(MouseEvent.CLICK, selectHandler);
			_bankLevelTypeCombox.removeEventListener(Event.CHANGE,comboChangeHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyBtnClickHandler);
			_getBtn.removeEventListener(MouseEvent.CLICK,getBtnClickHandler);
			_mediator.sceneModule.bankInfo.removeEventListener(BankInfoEvent.BANK_INFO_UPDATE,infoUpdateHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE, upgradeHandler);
		}
		
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.MATERIAL)
			{
				
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		private function upgradeHandler(e:Event):void
		{
			updateAwardList();
		}
		private function buyBtnClickHandler(e:MouseEvent):void
		{
			BankBuySocketHandler.send(this.type);
		}
		private function getBtnClickHandler(e:MouseEvent):void
		{
			BankGetSocketHandler.send(this.type);
		}
		private function comboChangeHandler(e:Event):void
		{
			this.type = _bankLevelTypeCombox.selectedItem.value;
		}
//		private function selectHandler(e:Event):void
//		{
//			_bankLevelTypeCombox.visible = !_bankLevelTypeCombox.visible;
//		}
		
		private function updateAwardList():void
		{
			_totalGet = 0;
			_totalLeft= 0;
//			_typeLabel.setValue(_awardInfo.money.toString());
			var index:int = 0;
			var level:int;
			var bankAwardItemView:BankAwardItemView;
			for(;index<AWARD_LEVEL.length;index++)
			{
				bankAwardItemView = _awardItemViewList[index];
				if(index == 0)
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.levelFirst",AWARD_PERCENT[index]);
				else
					bankAwardItemView.require = LanguageManager.getWord("ssztl.bank.levelRequire",AWARD_LEVEL[index],AWARD_PERCENT[index]);
				bankAwardItemView.money = int(_awardInfo.money * AWARD_PERCENT[index] / 100);
				if(_awardInfo.addTime <= 0 || GlobalData.selfPlayer.level < AWARD_LEVEL[index])
				{
					bankAwardItemView.state = 0;
					_totalLeft += int(_awardInfo.money * AWARD_PERCENT[index] / 100);
				}
				else if(_awardInfo.state >= AWARD_LEVEL[index])// && index !=0)
				{
					bankAwardItemView.state = 1;
				}
				else
				{
					_totalGet += int(_awardInfo.money * AWARD_PERCENT[index] / 100);
					_totalLeft += int(_awardInfo.money * AWARD_PERCENT[index] / 100);
					bankAwardItemView.state = 2;
				}
			}
			updateBtnView();
			updateTotal();
		}
		
		private function updateTotal():void
		{
			var i:int=0;
			_totalBuy = 0;
			var item:BankInfoItem;
			for(i=1;i<BankInfo.MONEY.length-1;i++)
			{
				item = _mediator.sceneModule.bankInfo.InfoDic[i] as BankInfoItem;
				if(item.addTime >0)
					_totalBuy += item.money;
			}
			_totalBuyLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.levelTipTotal",_totalBuy));
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
					_totalGetLabel.setValue(LanguageManager.getWord("ssztl.bank.levelTotalLeft",_totalLeft));
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
		
		public function set type(value:int):void
		{
			_awardInfo = _mediator.sceneModule.bankInfo.InfoDic[value] as BankInfoItem;
			updateAwardList();
		}
		
		private function infoUpdateHandler(e:BankInfoEvent):void
		{
			this.type = this.type;
		}
		public function show():void
		{
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