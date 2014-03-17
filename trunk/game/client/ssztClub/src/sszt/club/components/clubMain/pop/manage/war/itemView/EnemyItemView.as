package sszt.club.components.clubMain.pop.manage.war.itemView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.club.components.clubMain.pop.manage.war.WarEnemyPanel;
	import sszt.club.datas.war.ClubWarItemInfo;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.mediators.ClubWarMediator;
	import sszt.club.socketHandlers.ClubWarEnemyStopSocketHandler;
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	
	public class EnemyItemView extends Sprite
	{
		private var _clubNameLabel:MAssetLabel;
		private var _masterNameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _clubMemberNumLabel:MAssetLabel;
		
		private var _stopWarBtn:MCacheAsset3Btn;
		
		private var _mediator:ClubWarMediator;
		private var _info:ClubWarItemInfo;
		private var _page:int;
		
		public function EnemyItemView(argMediator:ClubWarMediator,argInfo:ClubWarItemInfo,argPage:int)
		{
			super();
			_mediator = argMediator;
			_info = argInfo;
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
			_masterNameLabel.move(160,10);
			addChild(_masterNameLabel);
			
			_levelLabel = new MAssetLabel(_info.level.toString(),MAssetLabel.LABELTYPE1);
			_levelLabel.move(250,10);
			addChild(_levelLabel);
			
			_clubMemberNumLabel = new MAssetLabel(_info.clubCurrentNum.toString() + "/" + _info.clubTotalNum.toString(),MAssetLabel.LABELTYPE1);
			_clubMemberNumLabel.move(320,10);
			addChild(_clubMemberNumLabel);
			
			_stopWarBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.club.stopWar"));
			_stopWarBtn.move(410,8);
			addChild(_stopWarBtn);
			
		}
		
		private function initialEvents():void
		{
			_stopWarBtn.addEventListener(MouseEvent.CLICK,stopWarBtnHandler);
		}
		
		
		private function removeEvents():void
		{
			_stopWarBtn.removeEventListener(MouseEvent.CLICK,stopWarBtnHandler);
		}
		
		
		private function stopWarBtnHandler(e:MouseEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.club.isUseStopWarLing"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					if(GlobalData.bagInfo.getItemCountById(CategoryType.WARAVOIDSYMBOLE_TEMPLATE) == 0)
					{
						BuyPanel.getInstance().show([CategoryType.WARAVOIDSYMBOLE_TEMPLATE],new ToStoreData(ShopID.QUICK_BUY));
						return;
					}
					ClubWarEnemyStopSocketHandler.sendStop(_info.clubListId,_page,WarEnemyPanel.PAGECOUNT);
				}
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			_clubNameLabel = null;
			_masterNameLabel = null;
			_levelLabel = null;
			_clubMemberNumLabel = null;
			if(_stopWarBtn)
			{
				_stopWarBtn.dispose();
				_stopWarBtn = null;
			}
			_mediator = null;
			_info = null;
		}

		public function get info():ClubWarItemInfo
		{
			return _info;
		}

		public function set info(value:ClubWarItemInfo):void
		{
			_info = value;
		}

	}
}