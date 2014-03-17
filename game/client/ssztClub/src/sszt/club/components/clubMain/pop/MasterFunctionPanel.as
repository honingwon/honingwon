package sszt.club.components.clubMain.pop
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.ClubCallSocketHandler;
	import sszt.core.socketHandlers.task.StartClubTransportSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import ssztui.ui.BorderAsset6;
	
	public class MasterFunctionPanel extends MSprite
	{
		private var _mediator:ClubMediator;
		private var _bg:BorderAsset6;
		private var _levelUpBtn:MCacheAsset1Btn;
		private var _addMemberBtn:MCacheAsset1Btn;
		private var _declearWarBtn:MCacheAsset1Btn;
		private var _clubCallBtn:MCacheAsset1Btn;
		private var _clubTransBtn:MCacheAsset1Btn;
		private var _clubMailBtn:MCacheAsset1Btn;
		private var _timeoutIndex:int = -1;
		private var _pos:Point;
		
		public function MasterFunctionPanel(mediator:ClubMediator,pos:Point)
		{
			_mediator = mediator;
			_pos = pos;
			super();
			_timeoutIndex = setTimeout(init,50);
		}
		
		private function init():void
		{
			_bg = new BorderAsset6();
			_bg.width = 199;
			_bg.height = 124;
			addChild(_bg);
			
			_levelUpBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.club.upgradeClub"));
			_levelUpBtn.move(20,13);
			addChild(_levelUpBtn);
			_addMemberBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.club.addMember"));
			_addMemberBtn.move(108,13);
			addChild(_addMemberBtn);
			_declearWarBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.club.clubDeclearWar"));
			_declearWarBtn.move(20,49);
			addChild(_declearWarBtn);
			_clubCallBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.club.clubGather"));
			_clubCallBtn.move(108,49);
			addChild(_clubCallBtn);
			_clubTransBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.club.clubTransport"));
			_clubTransBtn.move(20,85);
			addChild(_clubTransBtn);
			_clubMailBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.club.mailToMulti"));
			_clubMailBtn.move(108,85);
			addChild(_clubMailBtn);
			
			this.x = _pos.x;
			this.y = _pos.y - 124;
			
			initEvent();
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
			}
		}
		
		private function initEvent():void
		{
			_levelUpBtn.addEventListener(MouseEvent.CLICK,levelClickHandler);
			_addMemberBtn.addEventListener(MouseEvent.CLICK,addClickHandler);
			_declearWarBtn.addEventListener(MouseEvent.CLICK,declearClickHandler);
			_clubCallBtn.addEventListener(MouseEvent.CLICK,callClickHandler);
			_clubTransBtn.addEventListener(MouseEvent.CLICK,transportClickHandler);
			_clubMailBtn.addEventListener(MouseEvent.CLICK,mailClickHandler);
			GlobalAPI.layerManager.getTipLayer().stage.addEventListener(MouseEvent.CLICK,disposeHandler);
		}
		
		private function removeEvent():void
		{
			_levelUpBtn.removeEventListener(MouseEvent.CLICK,levelClickHandler);
			_addMemberBtn.removeEventListener(MouseEvent.CLICK,addClickHandler);
			_declearWarBtn.removeEventListener(MouseEvent.CLICK,declearClickHandler);
			_clubCallBtn.removeEventListener(MouseEvent.CLICK,callClickHandler);
			_clubTransBtn.removeEventListener(MouseEvent.CLICK,transportClickHandler);
			_clubMailBtn.removeEventListener(MouseEvent.CLICK,mailClickHandler);
			GlobalAPI.layerManager.getTipLayer().stage.removeEventListener(MouseEvent.CLICK,disposeHandler);
		}
		
		private function levelClickHandler(evt:MouseEvent):void
		{
			_mediator.showNewLevelUpPanel();
		}
		
		private function addClickHandler(evt:MouseEvent):void
		{
			_mediator.showInvitePanel();
		}
		
		private function declearClickHandler(evt:MouseEvent):void
		{
			_mediator.clubModule.clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUB_WAR_PANEL,0);
		}
		
		private function callClickHandler(evt:MouseEvent):void
		{
			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			if(_mediator.clubInfo.clubDetailInfo.clubRich < 100)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough2"));
				return;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				return;
			}
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				return;
			}
			MAlert.show(LanguageManager.getWord("ssztl.club.callClubMember"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					ClubCallSocketHandler.send();
				}
			}
		}
		
		private function transportClickHandler(evt:MouseEvent):void
		{
			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				if(GlobalData.clubTransportTime > 0)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.clubTransportOpenToday"));
				}
				else
				{
					MAlert.show(LanguageManager.getWord("ssztl.club.sureOpenClubTransport"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.leaderCanOpenClubTransport"));
			}
		}
		
		private function closeHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				StartClubTransportSocketHandler.send();
			}
		}
		
		private function mailClickHandler(evt:MouseEvent):void
		{
			_mediator.showTeamMailPanel();
		}
		
		private function disposeHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			_bg = null;
			_levelUpBtn.dispose();
			_levelUpBtn = null;
			_addMemberBtn.dispose();
			_addMemberBtn = null;
			_declearWarBtn.dispose();
			_declearWarBtn = null;
			_clubCallBtn.dispose();
			_clubCallBtn = null;
			_clubTransBtn.dispose();
			_clubTransBtn = null;
			_clubMailBtn.dispose();
			_clubMailBtn = null;
			_pos = null;
			dispatchEvent(new Event(Event.CLOSE));
			super.dispose();
		}
	}
}