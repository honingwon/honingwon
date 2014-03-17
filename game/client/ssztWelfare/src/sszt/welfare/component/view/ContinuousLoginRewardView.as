package sszt.welfare.component.view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.loginReward.LoginRewardInfo;
	import sszt.core.data.loginReward.LoginRewardTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.itemPick.ItemPickManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.welfare.component.cell.ContinuousLoginRewardCell;
	import sszt.welfare.socket.LoginRewardReceiveSocketHandler;
	
	public class ContinuousLoginRewardView extends MSprite
	{
		private const LABEL_GET:String = LanguageManager.getWord('ssztl.common.getLabel');
		private const LABEL_CHARGE:String = '充值';
		
		private var _bg:IMovieWrapper;
		
		private var _continuousLoginDays:int;
		private var _isChargeUser:Boolean;
		private var _got:Boolean;
		private var _gotChargeUser:Boolean;
		
		private var _todayReward:ItemInfo;
		private var _nextDayReward:ItemInfo;
		private var _todayRewardChargeUser:ItemInfo;
		private var _nextDayRewardChargeUser:ItemInfo;
		
		private var _txtContinuousLoginNDays:MAssetLabel;
		private var _txtcontinuousLoginNDaysReward:MAssetLabel;
		private var _txtcontinuousLoginNDaysRewardChargeUser:MAssetLabel;
		
		private var _cell:ContinuousLoginRewardCell;
		private var _cellChargeUser:ContinuousLoginRewardCell;
		
		private var _btnGet:MCacheAssetBtn1;
		private var _btnChargeUserGet:MCacheAssetBtn1;
		
		public function ContinuousLoginRewardView()
		{
			super();
			
			_continuousLoginDays = GlobalData.loginRewardData.login_day;
			
			_isChargeUser =  GlobalData.selfPlayer.money > 0;
			
			_got = GlobalData.loginRewardData.got;
			_gotChargeUser = GlobalData.loginRewardData.gotChargeUser;
			
			var todayRewardTemplate:LoginRewardInfo = LoginRewardTemplateList.getTemplate(_continuousLoginDays);
			var tmp:int = _continuousLoginDays+1;
			if(tmp > 30) tmp = 30;
			var nextDayRewardTemplate:LoginRewardInfo = LoginRewardTemplateList.getTemplate(tmp);
			_todayReward = new ItemInfo();
			_todayReward.templateId = todayRewardTemplate.ptItemId;
			_todayReward.count = todayRewardTemplate.ptItemNum;
			_nextDayReward = new ItemInfo();
			_nextDayReward.templateId = nextDayRewardTemplate.ptItemId;
			_nextDayReward.count = nextDayRewardTemplate.ptItemNum;
			_todayRewardChargeUser = new ItemInfo();
			_todayRewardChargeUser.templateId = todayRewardTemplate.vipItemId;
			_todayRewardChargeUser.count = todayRewardTemplate.vipItemNum;
			_nextDayRewardChargeUser = new ItemInfo();
			_nextDayRewardChargeUser.templateId = nextDayRewardTemplate.vipItemId;
			_nextDayRewardChargeUser.count = nextDayRewardTemplate.vipItemNum;
			
			initEvent();
			
			setData();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,80,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,142,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtContinuousLoginNDays = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtContinuousLoginNDays.move(11,35);
			addChild(_txtContinuousLoginNDays);
	
			_txtcontinuousLoginNDaysReward = new MAssetLabel('',MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_txtcontinuousLoginNDaysReward.move(11,60);
			addChild(_txtcontinuousLoginNDaysReward);
			
			_txtcontinuousLoginNDaysRewardChargeUser = new MAssetLabel('',MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_txtcontinuousLoginNDaysRewardChargeUser.move(11,123);
			addChild(_txtcontinuousLoginNDaysRewardChargeUser);
			
			_cell = new ContinuousLoginRewardCell();
			_cell.move(16,80);
			addChild(_cell);
			
			_cellChargeUser = new ContinuousLoginRewardCell();
			_cellChargeUser.move(16,142);
			addChild(_cellChargeUser);
			
			_btnGet = new MCacheAssetBtn1(1,1,LanguageManager.getWord('ssztl.common.getLabel'));
			_btnGet.move(196,90);   
			 addChild(_btnGet);
			 
			 _btnChargeUserGet = new MCacheAssetBtn1(1,1,'');
			 _btnChargeUserGet.move(196,151);   
			 addChild(_btnChargeUserGet);
		}
		
		private function initEvent():void
		{
			_btnGet.addEventListener(MouseEvent.CLICK, btnGetClickHandler);
			_btnChargeUserGet.addEventListener(MouseEvent.CLICK, btnGetVipClickHandler);
//			GlobalData.selfPlayer.addEventListener(VipCommonEvent.VIPSTATECHANGE,vipStateChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnGet.removeEventListener(MouseEvent.CLICK, btnGetClickHandler);
			_btnChargeUserGet.removeEventListener(MouseEvent.CLICK, btnGetVipClickHandler);
//			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.VIPSTATECHANGE,vipStateChangeHandler);
		}
		
//		private function vipStateChangeHandler(e:VipCommonEvent):void
//		{
//			_isChargeUser =  GlobalData.selfPlayer.getVipType() > VipType.NORMAL;
//			_btnChargeUserGet.label = _isChargeUser ? LABEL_GET : LABEL_CHARGE;
//			
//			if(_gotChargeUser)
//			{
//				_btnChargeUserGet.enabled =  !_isChargeUser;
//			}
//		}
		
		private function btnGetClickHandler(e:MouseEvent):void
		{
			if(!_got)
			{
				LoginRewardReceiveSocketHandler.send(0);
			}
		}
		
		private function btnGetVipClickHandler(e:MouseEvent):void
		{
			if(!_isChargeUser)
			{
				//SetModuleUtils.addStore(new ToStoreData(1));
				SetModuleUtils.addStore(new ToStoreData(2));
			}
			else if(!_gotChargeUser && _isChargeUser)
			{
				LoginRewardReceiveSocketHandler.send(1);
			}
		}
		
		private function setData():void
		{
			_btnChargeUserGet.label = _isChargeUser ? LABEL_GET : LABEL_CHARGE;
			
			_txtContinuousLoginNDays.setHtmlValue(LanguageManager.getWord('ssztl.welfare.continuousLoginNDays', "<font color='#ff6600'><b>"+_continuousLoginDays+"</b></font>"));
			
			if(_got)
			{
				var tmp:int = _continuousLoginDays+1;
				if(tmp > 30) tmp = 30;
				_txtcontinuousLoginNDaysReward.setValue(LanguageManager.getWord('ssztl.welfare.continuousLoginNDaysReward', tmp));
				_cell.itemInfo = _nextDayReward;
				_btnGet.enabled = false;
			}
			else
			{
				_txtcontinuousLoginNDaysReward.setValue(LanguageManager.getWord('ssztl.welfare.continuousLoginNDaysReward', _continuousLoginDays));
				_cell.itemInfo = _todayReward;
			}
			
			if(_gotChargeUser)
			{
				tmp = _continuousLoginDays+1;
				if(tmp > 30) tmp = 30;
				_txtcontinuousLoginNDaysRewardChargeUser.setValue(LanguageManager.getWord('ssztl.welfare.continuousLoginNDaysReward2', tmp));
				_cellChargeUser.itemInfo = _nextDayRewardChargeUser;
				_btnChargeUserGet.enabled =  !_isChargeUser;
			}
			else
			{
				_txtcontinuousLoginNDaysRewardChargeUser.setValue(LanguageManager.getWord('ssztl.welfare.continuousLoginNDaysReward2', _continuousLoginDays));
				_cellChargeUser.itemInfo = _todayRewardChargeUser;
			}
		}
		
		public  function getRewardSuccessHandler():void
		{
			ItemPickManager.getInstance().pickItem(_cell.itemInfo.templateId,_cell.localToGlobal(new Point(0,0)));
			_got = true;
			var tmp:int = _continuousLoginDays+1;
			if(tmp > 30) tmp = 30;
			_txtcontinuousLoginNDaysReward.setValue(LanguageManager.getWord('ssztl.welfare.continuousLoginNDaysReward', tmp));
			_cell.itemInfo = _nextDayReward;
			_btnGet.enabled = false;
		}
		
		public  function getRewardSuccessChargeUserHandler():void
		{
			ItemPickManager.getInstance().pickItem(_cellChargeUser.itemInfo.templateId,_cellChargeUser.localToGlobal(new Point(0,0)));
			_gotChargeUser = true;
			var tmp:int = _continuousLoginDays+1;
			if(tmp > 30) tmp = 30;
			_txtcontinuousLoginNDaysRewardChargeUser.setValue(LanguageManager.getWord('ssztl.welfare.continuousLoginNDaysReward2', tmp));
			_cellChargeUser.itemInfo = _nextDayRewardChargeUser;
			_btnChargeUserGet.enabled =  !_isChargeUser;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			
			_todayReward = null;
			_nextDayReward = null;
			_todayRewardChargeUser = null;
			_nextDayRewardChargeUser = null;
			
			_txtContinuousLoginNDays = null;
			_txtcontinuousLoginNDaysReward = null;
			_txtcontinuousLoginNDaysRewardChargeUser = null;
			
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_cellChargeUser)
			{
				_cellChargeUser.dispose();
				_cellChargeUser = null;
			}
			if(_btnGet)
			{
				_btnGet.dispose();
				_btnGet = null;
			}
			if(_btnChargeUserGet)
			{
				_btnChargeUserGet.dispose();
				_btnChargeUserGet = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
		}
	}
}