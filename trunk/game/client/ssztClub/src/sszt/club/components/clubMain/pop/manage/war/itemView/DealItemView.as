package sszt.club.components.clubMain.pop.manage.war.itemView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	
	import sszt.club.components.clubMain.pop.manage.war.WarDealPanel;
	import sszt.club.datas.war.ClubWarItemInfo;
	import sszt.club.events.ClubWarInfoUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.mediators.ClubWarMediator;
	import sszt.club.socketHandlers.ClubWarDealSocketHandler;
	import sszt.core.manager.LanguageManager;
	
	public class DealItemView extends Sprite
	{
		private var _clubNameLabel:MAssetLabel;
		private var _masterNameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _clubMemberNumLabel:MAssetLabel;
		
		private var _acceptBtn:MCacheAsset3Btn;
		private var _refuseBtn:MCacheAsset3Btn;
		
		private var _mediator:ClubWarMediator;
		private var _info:ClubWarItemInfo;
		private var _page:int;
		
		public function DealItemView(argMediator:ClubWarMediator,argInfo:ClubWarItemInfo,argPage:int)
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
			
			
			_acceptBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.accept"));
			_acceptBtn.move(390,8);
			addChild(_acceptBtn);
			
			_refuseBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.refuse"));
			_refuseBtn.move(440,8);
			addChild(_refuseBtn);
			
		}
		
		private function initialEvents():void
		{
			_acceptBtn.addEventListener(MouseEvent.CLICK,_acceptBtnHandler);
			_refuseBtn.addEventListener(MouseEvent.CLICK,_refuseBtnHandler);
		}
		
		
		private function removeEvents():void
		{
			_acceptBtn.removeEventListener(MouseEvent.CLICK,_acceptBtnHandler);
			_refuseBtn.removeEventListener(MouseEvent.CLICK,_refuseBtnHandler);
		}
		
		
		private function _acceptBtnHandler(e:MouseEvent):void
		{
			ClubWarDealSocketHandler.sendDeal(_info.clubListId,0,_page,WarDealPanel.PAGECOUNT);
		}
		
		private function _refuseBtnHandler(e:MouseEvent):void
		{
			ClubWarDealSocketHandler.sendDeal(_info.clubListId,1,_page,WarDealPanel.PAGECOUNT);
		}
		
		
		public function dispose():void
		{
			removeEvents();
			_clubNameLabel = null;
			_masterNameLabel = null;
			_levelLabel = null;
			_clubMemberNumLabel = null;
			if(_acceptBtn)
			{
				_acceptBtn.dispose();
				_acceptBtn = null;
			}
			if(_refuseBtn)
			{
				_refuseBtn.dispose();
				_refuseBtn = null;
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