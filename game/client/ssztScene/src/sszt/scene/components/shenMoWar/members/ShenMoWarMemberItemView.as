package sszt.scene.components.shenMoWar.members
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset2Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	
	import sszt.constData.CampType;
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class ShenMoWarMemberItemView extends Sprite
	{
		private var _mediator:SceneWarMediator;
		private var _info:ShenMoWarMembersItemInfo;
		private var _rankingLabel:MAssetLabel;
		private var _playerNickLabel:MAssetLabel;
		private var _campLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _clubNameLabel:MAssetLabel;
		private var _careerNameLabel:MAssetLabel;
		private var _attackPepNumPepLabel:MAssetLabel;
		private var _getRewardsBtn:MCacheAsset3Btn;
		
		public function ShenMoWarMemberItemView(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			intialEvents();
		}
		
		private function initialView():void
		{
			_rankingLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_rankingLabel.move(15,0);
			addChild(_rankingLabel);
			
			_playerNickLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_playerNickLabel.move(90,0);
			addChild(_playerNickLabel);
			
			_campLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_campLabel.move(180,0);
			addChild(_campLabel);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_levelLabel.move(227,0);
			addChild(_levelLabel);
			
			_clubNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubNameLabel.move(310,0);
			addChild(_clubNameLabel);
			
			_careerNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_careerNameLabel.move(393,0);
			addChild(_careerNameLabel);
			
			_attackPepNumPepLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_attackPepNumPepLabel.move(450,0);
			addChild(_attackPepNumPepLabel);
			
			_getRewardsBtn = new MCacheAsset3Btn(1,LanguageManager.getWord("ssztl.common.getAward"));
			_getRewardsBtn.move(520,0);
			addChild(_getRewardsBtn);
			_getRewardsBtn.enabled = false;

		}
		
		private function udpateLabel():void
		{
			_rankingLabel.text = _info.rankingNum.toString();
			_playerNickLabel.text = "[" + _info.serverId + "]" + _info.playerNick;
			_campLabel.text = CampType.getCampName(_info.camp);
			_levelLabel.text = _info.level.toString();
			_clubNameLabel.text = _info.clubName;
			_careerNameLabel.text = CareerType.getNameByCareer(_info.careerId);
			_attackPepNumPepLabel.text  =_info.attackPepNum.toString();
			if(_info.awardState != 0 && (_info.userId == GlobalData.selfPlayer.userId))
			{
				_getRewardsBtn.enabled = true;
				_mediator.shenMoWarInfo.shenMoWarMembersInfo.addEventListener(SceneShenMoWarUpdateEvent.SHENMO_SEND_GET_AWARD,awardStateChangeHandler);
			}
			else
			{
				_getRewardsBtn.enabled = false;
			}
		}
		
		private function awardStateChangeHandler(evt:SceneShenMoWarUpdateEvent):void
		{
			_getRewardsBtn.enabled = false;
		}
		
		private function intialEvents():void
		{
			_getRewardsBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvents():void
		{
			_getRewardsBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			_mediator.sendAward();
			_getRewardsBtn.enabled = false;
		}
		
		public function get info():ShenMoWarMembersItemInfo
		{
			return _info;
		}
		
		public function set info(value:ShenMoWarMembersItemInfo):void
		{
			_info = value;
			udpateLabel();
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_mediator && _mediator.shenMoWarInfo && _mediator.shenMoWarInfo.shenMoWarMembersInfo)
			{
				_mediator.shenMoWarInfo.shenMoWarMembersInfo.removeEventListener(SceneShenMoWarUpdateEvent.SHENMO_SEND_GET_AWARD,awardStateChangeHandler);
			}
			 _mediator = null;
			 _info = null;
			 _rankingLabel = null;
			 _playerNickLabel = null;
			 _campLabel = null;
			 _levelLabel = null;
			 _clubNameLabel = null;
			 _careerNameLabel = null;
			 _attackPepNumPepLabel = null;
			 if(_getRewardsBtn)
			 {
				 _getRewardsBtn.dispose();
				 _getRewardsBtn = null;
			 }
		}
	}
}