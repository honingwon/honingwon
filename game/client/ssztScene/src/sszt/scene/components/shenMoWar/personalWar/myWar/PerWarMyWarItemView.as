package sszt.scene.components.shenMoWar.personalWar.myWar
{
	import flash.display.Sprite;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CareerType;
	import sszt.scene.data.personalWar.myInfo.PerWarMyWarItemInfo;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class PerWarMyWarItemView extends Sprite
	{
		private var _mediator:SceneWarMediator;
		private var _info:PerWarMyWarItemInfo;
		private var _playerNickLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _clubLabel:MAssetLabel;
		private var _careerNameLabel:MAssetLabel;
		private var _killCountLabel:MAssetLabel;
		
		public function PerWarMyWarItemView(argMediator:SceneWarMediator,argInfo:PerWarMyWarItemInfo)
		{
			super();
			_mediator = argMediator;
			_info = argInfo;
			initialView();
		}
		
		private function initialView():void
		{
			_playerNickLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_playerNickLabel.move(40,0);
			addChild(_playerNickLabel);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_levelLabel.move(110,0);
			addChild(_levelLabel);
			
			_clubLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubLabel.move(180,0);
			addChild(_clubLabel);
			
			_careerNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_careerNameLabel.move(248,0);
			addChild(_careerNameLabel);
			
			_killCountLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_killCountLabel.move(290,0);
			addChild(_killCountLabel);
			
			updateData();
		}
		
		private function updateData():void
		{
			_playerNickLabel.text = "[" + _info.serverId + "]" + _info.playerNick;
			_levelLabel.text = _info.level.toString();
			_clubLabel.text = _info.clubName;
			_careerNameLabel.text = CareerType.getNameByCareer(_info.careerId);
			_killCountLabel.text = _info.killCount.toString();
		}
		
		private function intialEvents():void
		{
			
		}
		
		private function removeEvents():void
		{
			
		}
		
		public function dispose():void
		{
			_mediator = null;
			_info = null;
			_playerNickLabel = null
			_levelLabel = null;
			_clubLabel = null;
			_careerNameLabel = null;
			_killCountLabel = null;
		}
	}
}