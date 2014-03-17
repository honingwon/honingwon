package sszt.club.components.clubMain.pop.manage.war.itemView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import sszt.club.components.clubMain.pop.manage.war.WarDeclearPanel;
	import sszt.club.datas.war.ClubWarItemInfo;
	import sszt.club.events.ClubWarInfoUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.mediators.ClubWarMediator;
	import sszt.club.socketHandlers.ClubWarDeclearBtnSocketHandler;
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.SystemDateInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	
	public class DeclearItemView extends Sprite
	{
		private var _clubNameLabel:MAssetLabel;
		private var _masterNameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _clubMemberNumLabel:MAssetLabel;
		private var _clubStateLabel:MAssetLabel;
		
		private var _declearBtn:MCacheAsset3Btn;
		private var _forceBtn:MCacheAsset3Btn;
		
		private var _mediator:ClubWarMediator;
		private var _info:ClubWarItemInfo;
		private var _page:int;
		
		
		public function DeclearItemView(argMediator:ClubWarMediator,argDeclearItemInfo:ClubWarItemInfo,argPage:int)
		{
			super();
			_mediator = argMediator;
			_info = argDeclearItemInfo;
			_page = argPage;
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_clubNameLabel = new MAssetLabel(_info.clubName,MAssetLabel.LABELTYPE1);
			_clubNameLabel.move(30,10);
			addChild(_clubNameLabel);
			
			_masterNameLabel = new MAssetLabel(_info.masterName,MAssetLabel.LABELTYPE1);
			_masterNameLabel.move(145,10);
			addChild(_masterNameLabel);
			
			_levelLabel = new MAssetLabel(_info.level.toString(),MAssetLabel.LABELTYPE1);
			_levelLabel.move(231,10);
			addChild(_levelLabel);
			
			_clubMemberNumLabel = new MAssetLabel(_info.clubCurrentNum.toString() + "/" + _info.clubTotalNum.toString(),MAssetLabel.LABELTYPE1);
			_clubMemberNumLabel.move(280,10);
			addChild(_clubMemberNumLabel);
			
			
			_clubStateLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubStateLabel.move(360,10);
			addChild(_clubStateLabel);

			_declearBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.club.declearWar"));
			_declearBtn.move(405,8);
			addChild(_declearBtn);
			_declearBtn.enabled = false;
			
			_forceBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.club.force"));
			_forceBtn.move(451,8);
			addChild(_forceBtn);
			_forceBtn.enabled = false;
			
			itemInfoUpdateHandler();
		}
		
		private function initialEvents():void
		{
			_declearBtn.addEventListener(MouseEvent.CLICK,_declearBtnHandler);
			_forceBtn.addEventListener(MouseEvent.CLICK,_forceBtnHandler);
//			_info.addEventListener(ClubWarInfoUpdateEvent.WAR_DECLEAR_ITEM_INFO_UPDATE,itemInfoUpdateHandler);
		}
		
		
		private function removeEvents():void
		{
			_declearBtn.removeEventListener(MouseEvent.CLICK,_declearBtnHandler);
			_forceBtn.removeEventListener(MouseEvent.CLICK,_forceBtnHandler);
//			_info.addEventListener(ClubWarInfoUpdateEvent.WAR_DECLEAR_ITEM_INFO_UPDATE,itemInfoUpdateHandler);
		}
		
		
		private function _declearBtnHandler(e:MouseEvent):void
		{
			if(!limitCondition())return;
			MAlert.show(LanguageManager.getWord("ssztl.club.sureDeclearWar",_info.clubName),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					ClubWarDeclearBtnSocketHandler.sendDeclear(_info.clubListId,0,_page,WarDeclearPanel.PAGECOUNT);
				}
			}
		}
		
		private function _forceBtnHandler(e:MouseEvent):void
		{
			if(!limitCondition())return;
			MAlert.show(LanguageManager.getWord("ssztl.club.sureUseDeclearWarLing"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					if(GlobalData.bagInfo.getCategoryCount(CategoryType.WARSYMBOLE) == 0)
					{
						BuyPanel.getInstance().show([CategoryType.WARSYMBOLE_TEMPLATE],new ToStoreData(ShopID.QUICK_BUY));
						return;
					}
					ClubWarDeclearBtnSocketHandler.sendDeclear(_info.clubListId,1,_page,WarDeclearPanel.PAGECOUNT);
				}
			}
		}
		/**
		 * 宣战限制条件
		 */		
		private function limitCondition():Boolean
		{
			if(GlobalData.systemDate.getSystemDate().hours >= 9  && GlobalData.systemDate.getSystemDate().hours < 24)
			{
				return true;
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.declearWarTime"));
				return false;
			}
			if(_info.level < 2)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.undeclearable"));
				return false;
			}
			return true;
		}
		
		
		/**宣战状态更新**/
		private function itemInfoUpdateHandler():void
		{
			var tempState:String = (_info.warState == 0)?LanguageManager.getWord("ssztl.club.undeclearWar"):LanguageManager.getWord("ssztl.club.decleared");
			var tempColor:int = (_info.warState == 0)?0xFFFFFF:0xFF0000;
			_clubStateLabel.text = tempState;
			_clubStateLabel.textColor = tempColor;
			if(_info.warState == 0)
			{
				_declearBtn.enabled = true;
				_forceBtn.enabled = true;
			}
			else
			{
				_declearBtn.enabled = false;
				_forceBtn.enabled = false;
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			 _clubNameLabel = null;
			 _masterNameLabel = null;
			 _levelLabel = null;
			 _clubMemberNumLabel = null;
			 _clubStateLabel = null;
			if(_declearBtn)
			{
				_declearBtn.dispose();
				_declearBtn = null;
			}
			if(_forceBtn)
			{
				_forceBtn.dispose();
				_forceBtn = null;
			}
			 _mediator = null;
			 _info = null;
		}
	}
}