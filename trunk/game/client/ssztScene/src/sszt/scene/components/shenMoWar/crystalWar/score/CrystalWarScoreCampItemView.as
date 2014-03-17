package sszt.scene.components.shenMoWar.crystalWar.score
{
	import flash.display.Sprite;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CareerType;
	import sszt.scene.data.crystalWar.scoreInfo.CrystalWarScoreItemInfo;
	
	public class CrystalWarScoreCampItemView extends Sprite
	{
		private var _info:CrystalWarScoreItemInfo;
		private var _rankLabel:MAssetLabel;
		private var _playerNickLabel:MAssetLabel;
		private var _playerLevelLabel:MAssetLabel;
		private var _clubNameLabel:MAssetLabel;
		private var _careerLabel:MAssetLabel;
		private var _killCountLabel:MAssetLabel;
		private var _scoreLabel:MAssetLabel;
		private var _contributeLabel:MAssetLabel;
		
		public function CrystalWarScoreCampItemView()
		{
			super();
			initialView();
		}
		
		private function initialView():void
		{
			_rankLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_rankLabel.move(20,7);
			addChild(_rankLabel);
			
			_playerNickLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_playerNickLabel.move(105,7);
			addChild(_playerNickLabel);
			
			_playerLevelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_playerLevelLabel.move(183,7);
			addChild(_playerLevelLabel);
			
			_clubNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubNameLabel.move(270,7);
			addChild(_clubNameLabel);
			
			_careerLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_careerLabel.move(360,7);
			addChild(_careerLabel);
			
			_killCountLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_killCountLabel.move(435,7);
			addChild(_killCountLabel);
			
			_scoreLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_scoreLabel.move(505,7);
			addChild(_scoreLabel);
			
			_contributeLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_contributeLabel.move(560,7);
			addChild(_contributeLabel);
		}
		
		private function updateLabel():void
		{
			if(_info)
			{
				_rankLabel.text = _info.rankNum.toString();
				_playerNickLabel.text = "[" + _info.serverId + "]" + _info.playerNick;
				_playerLevelLabel.text = _info.playerLevel.toString();
				_clubNameLabel.text = _info.campName;
				_careerLabel.text = CareerType.getNameByCareer(_info.career);
				_killCountLabel.text = _info.killCount.toString();
				_scoreLabel.text = _info.playerScore.toString();
//				_contributeLabel.text = _info.campContribute.toString();
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
				_contributeLabel.text = "";
			}
		}
		
		public function get info():CrystalWarScoreItemInfo
		{
			return _info;
		}
		
		public function set info(value:CrystalWarScoreItemInfo):void
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
			_contributeLabel = null;
			if(parent)parent.removeChild(this);
		}

	}
}