package sszt.scene.components.shenMoWar.clubWar.score
{
	import flash.display.Sprite;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CareerType;
	import sszt.scene.data.clubPointWar.scoreInfo.ClubPointWarScoreItemInfo;
	
	public class ClubPointWarScoreItemView extends Sprite
	{
		private var _info:ClubPointWarScoreItemInfo;
		private var _rankLabel:MAssetLabel;
		private var _playerNickLabel:MAssetLabel;
		private var _playerLevelLabel:MAssetLabel;
		private var _clubNameLabel:MAssetLabel;
		private var _careerLabel:MAssetLabel;
		private var _killCountLabel:MAssetLabel;
		private var _scoreLabel:MAssetLabel;
		public function ClubPointWarScoreItemView()
		{
			super();
			initialView();
		}
		
		private function initialView():void
		{
//			graphics.beginFill(0x7AC900,0.2);
//			graphics.drawRect(0,0,620,27);
//			graphics.endFill();
			
			
			_rankLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_rankLabel.move(15,7);
			addChild(_rankLabel);
			
			_playerNickLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_playerNickLabel.move(110,7);
			addChild(_playerNickLabel);
			
			_playerLevelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_playerLevelLabel.move(185,7);
			addChild(_playerLevelLabel);
			
			_clubNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubNameLabel.move(260,7);
			addChild(_clubNameLabel);
			
			_careerLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_careerLabel.move(370,7);
			addChild(_careerLabel);
			
			_killCountLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_killCountLabel.move(455,7);
			addChild(_killCountLabel);
			
			_scoreLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_scoreLabel.move(550,7);
			addChild(_scoreLabel);
		}
		
		private function updateLabel():void
		{
			if(_info)
			{
				_rankLabel.text = _info.rankNum.toString();
				_playerNickLabel.text = "[" + _info.serverId + "]" + _info.playerNick;
				_playerLevelLabel.text = _info.playerLevel.toString();
				_clubNameLabel.text = _info.clubName;
				_careerLabel.text = CareerType.getNameByCareer(_info.career);
				_killCountLabel.text = _info.killCount.toString();
				_scoreLabel.text = _info.playerScore.toString();
			}
			else
			{
				_rankLabel.text = "";
				_playerNickLabel.text = "";
				_playerLevelLabel.text = "";
				_clubNameLabel.text = "";
				_careerLabel.text = "";
				_killCountLabel.text = "";
				_scoreLabel.text = "";
			}
		}
		
		public function get info():ClubPointWarScoreItemInfo
		{
			return _info;
		}

		public function set info(value:ClubPointWarScoreItemInfo):void
		{
			_info = value;
			updateLabel();
		}

		public function dispose():void
		{
			 _info = null;
			 _rankLabel = null;
			 _playerNickLabel = null;
			 _playerLevelLabel = null;
			 _clubNameLabel = null;
			 _careerLabel = null;
			 _killCountLabel = null;
			 _scoreLabel = null;
		}
	}
}