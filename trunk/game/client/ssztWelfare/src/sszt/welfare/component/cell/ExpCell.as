package sszt.welfare.component.cell
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.loginReward.LoginRewardExp;
	import sszt.core.data.loginReward.LoginRewardTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.welfare.socket.LoginRewardExchangeSocketHandler;
	
	import ssztui.ui.BorderAsset6;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	/**
	 * 兑换经验类别 
	 * @author chendong
	 * 
	 */	
	public class ExpCell extends BaseCell
	{
		/**
		 * 获得经验方式,1：免费单倍 ，2：铜币双倍，3：元宝三倍
		 */
		private var _getExpType:int;
		/**
		 * 发送获得经验方式,1：免费单倍 ，2：铜币双倍，3：元宝三倍
		 */		
		private var _sendExpType:int;
		
		/**
		 *累计XX次
		 */
		private var _cumulativeLable:MAssetLabel;
		/**
		 *找回XX次
		 */
		private var _FindLable:MAssetLabel;
		/**
		 *获得经验值
		 */
		private var _getExpValueLable:MAssetLabel;
		
		private var _count:int = 1;
		private var _countValue:TextField;
		private var _up:MBitmapButton;
		private var _down:MBitmapButton;
		
		
		/**
		 * 1:单人,2:多人副本 ,3:离线 获得经验  
		 */
		private var _getExpWay:int = 3;
		
		/**
		 * 经验文本提示，1：(免费)单倍，2：(铜币)双倍，3：(元宝)三倍
		 */
		private var _expDecLable:MAssetLabel;
		
		/**
		 * 文本提示:小时 
		 */
		private var _hourLable:MAssetLabel;
		
		/**
		 * 领取奖励按钮 
		 */
		private var _getExpBtn:MCacheAssetBtn1;
		
		/**
		 * 1:单人,2:多人副本 ,3:离线 获得经验  
		 */
		private var _type:int = 3;
		
		private var _maxCount:int=0;
		
		private var _getExpValue:int = 0;
		
		public function ExpCell(type:int)
		{
			super();
			_getExpType =  type;
			
			initView()
		}
		
		private function initView():void
		{
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(89,1,44,20),new BorderAsset6()));
			
			_expDecLable = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_expDecLable.move(0,3);
			addChild(_expDecLable);
			
			_hourLable = new MAssetLabel(LanguageManager.getWord("ssztl.common.hourLabel"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hourLable.move(135,3);
			addChild(_hourLable);
			
			_up = new MBitmapButton(new SmallBtnAmountUpAsset());
			_up.move(112,2);
			addChild(_up);
			
			_down = new MBitmapButton(new SmallBtnAmountDownAsset());
			_down.move(112,11);
			addChild(_down);
			
			_getExpBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.club.getWelFare"));
			_getExpBtn.move(184,0);
			addChild(_getExpBtn);
			
			_countValue = new TextField();
			_countValue.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_countValue.type = TextFieldType.INPUT;
			_countValue.width = 21;
			_countValue.height = 16;
			_countValue.x = 93;
			_countValue.y = 3;
			_countValue.autoSize = TextFormatAlign.CENTER;
			_countValue.maxChars = 3;
			_countValue.restrict ="0123456789";
			_countValue.text = "1";
			addChild(_countValue);
			
			initData(null);
			initEventFun();
		}
		
		private function initData(evt:SceneModuleEvent):void
		{
			switch(_getExpType)
			{
				case 1:
					_expDecLable.setHtmlValue(LanguageManager.getWord("ssztl.loginReward.get1"));
					break; 
				case 2:
					_expDecLable.setHtmlValue(LanguageManager.getWord("ssztl.loginReward.get2"));
					break;
				case 3:
					_expDecLable.setHtmlValue(LanguageManager.getWord("ssztl.loginReward.get3"));
					break;
			}
			_count = _maxCount = int(GlobalData.loginRewardData.offLineTimes / 3600);
			_countValue.text = int(GlobalData.loginRewardData.offLineTimes / 3600).toString();
			
			if(_count <= 0)
			{
				_getExpBtn.enabled = false;
			}
		}
		
		protected function initEventFun():void
		{
			_up.addEventListener(MouseEvent.CLICK,upClickHandler);
			_down.addEventListener(MouseEvent.CLICK,downClickHandler);
			_countValue.addEventListener(Event.CHANGE,changeHandler);
			_getExpBtn.addEventListener(MouseEvent.CLICK,getExpClick);
			ModuleEventDispatcher.addModuleEventListener(WelfareEvent.EXCHANGE_EXP,setBtEnabled);
			ModuleEventDispatcher.addModuleEventListener(WelfareEvent.UPDATE_LOGIN_REWARD,initData);
		}
		
		protected function removeEventFun():void
		{
			_up.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_down.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_countValue.removeEventListener(Event.CHANGE,changeHandler);
			_getExpBtn.removeEventListener(MouseEvent.CLICK,getExpClick);
			ModuleEventDispatcher.removeModuleEventListener(WelfareEvent.EXCHANGE_EXP,setBtEnabled);
			ModuleEventDispatcher.removeModuleEventListener(WelfareEvent.UPDATE_LOGIN_REWARD,initData);
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(_count>= _maxCount) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_count = _count +1;
			_countValue.text = String(_count);
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			if(_count <= 1)
			{
				_count = 1;
			}else
			{
				_count = _count - 1;
				SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			}
			_countValue.text = String(_count);
		}
		
		private function changeHandler(evt:Event):void
		{
			if(int(_countValue.text) >= _maxCount)
			{
				_countValue.text = _maxCount.toString();
			}
			_count = int(_countValue.text);
		}
		
		private function getExpClick(evt:MouseEvent):void
		{
			if(_count <= 0)
			{
				return ;
			}
			getExpValue(_getExpType,_getExpWay);
		}
		
		
		public function setBtEnabled(evt:WelfareEvent):void
		{
			_count = _maxCount = int(int(evt.data.num) / 3600);
			_countValue.text = String(_count);
			if(_count <= 0)
			{
				_getExpBtn.enabled = false;
				GlobalData.loginRewardData.gotOffLineTimes = true;
			}
			
			if(int(evt.data.type1) == _getExpType)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.loginReward.getExp")+LanguageManager.getWord("ssztl.welfare.offlineExp")+_getExpValue);
			}
		}
		
		private function getExpValue(getExpType:int,getExpWay:int):void
		{
			var loginExp:LoginRewardExp = LoginRewardTemplateList.getExpTemplate(getExpWay);
			switch(getExpType)
			{
				case 1:
					_getExpValue = loginExp.basicsExp* _count;
					MAlert.show(LanguageManager.getWord("ssztl.loginReward.freeChangeExp",(loginExp.basicsExp* _count)),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,getExp);
					break;
				case 2:
					_getExpValue = loginExp.copperExp * _count;
					MAlert.show(LanguageManager.getWord("ssztl.loginReward.changeExpCopper",(loginExp.copper * _count),(loginExp.copperExp * _count)),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,getExp);
					break;
				case 3:
					_getExpValue = loginExp.yuanBaoExp * _count;
					MAlert.show(LanguageManager.getWord("ssztl.loginReward.changeExpYuanbao",(loginExp.yuanBao * _count),(loginExp.yuanBaoExp* _count)),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,getExp);
					break;
			}
		}
		
		private function getExp(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				switch(_getExpType)
				{
					case 1:
						_sendExpType = _getExpType;
						LoginRewardExchangeSocketHandler.send(_type,_getExpType,_count);
						break;
					case 2:
						_sendExpType = _getExpType;
						if(LoginRewardTemplateList.getExpTemplate(_type).copper < GlobalData.selfPlayer.userMoney.copper || LoginRewardTemplateList.getExpTemplate(_type).copper < GlobalData.selfPlayer.userMoney.bindCopper)
						{
							LoginRewardExchangeSocketHandler.send(_type,_getExpType,_count);
						}
						else
						{
							if(GlobalData.selfPlayer.userMoney.copper <= 0)
							{
								QuickTips.show(LanguageManager.getWord("ssztl.loginReward.copperNo"));
//								MAlert.show(LanguageManager.getWord("ssztl.loginReward.copperNo"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,nocopperCharge);
							}
							else
							{
								var average:int = LoginRewardTemplateList.getExpTemplate(_type).copperExp / LoginRewardTemplateList.getExpTemplate(_type).copper;
								var expValue:int = average * GlobalData.selfPlayer.userMoney.copper;
								QuickTips.show(LanguageManager.getWord("ssztl.loginReward.copperNoEn",GlobalData.selfPlayer.userMoney.copper,expValue));
//								MAlert.show(LanguageManager.getWord("ssztl.loginReward.copperNoEn",GlobalData.selfPlayer.userMoney.copper,expValue),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,copperCharge);
							}
							BuyPanel.getInstance().show([CategoryType.gaojiyinpiao],new ToStoreData(ShopID.QUICK_BUY));
						}
						break;
					case 3:
						_sendExpType = _getExpType; 
						if(LoginRewardTemplateList.getExpTemplate(_type).yuanBao < GlobalData.selfPlayer.userMoney.yuanBao)
						{
							LoginRewardExchangeSocketHandler.send(_type,_getExpType,_count);
						}
						else
						{
							//MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,goingCharge);
							QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
						}
						break;
				}
			}
		}
		
		private function nocopperCharge(evt:CloseEvent):void
		{
		}
		
		private function copperCharge(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				var percentage:int = GlobalData.selfPlayer.userMoney.copper / LoginRewardTemplateList.getExpTemplate(_type).copper;
				var count:int = _count * percentage;
				LoginRewardExchangeSocketHandler.send(_type,_getExpType,count);
			}
		}
		
		private function goingCharge(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				JSUtils.gotoFill();
			}
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			removeEventFun();
		}
		
	}
}