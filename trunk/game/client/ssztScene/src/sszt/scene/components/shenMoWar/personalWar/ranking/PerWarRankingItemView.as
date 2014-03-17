package sszt.scene.components.shenMoWar.personalWar.ranking
{
	import flash.display.Sprite;
	
	import sszt.ui.button.MAssetButton;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.scene.data.personalWar.menber.PerWarMembersItemInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class PerWarRankingItemView extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _info:PerWarMembersItemInfo;
		private var _rankingLabel:MAssetLabel;
		private var _nameLabel:MAssetLabel;
		private var _scoreLabel:MAssetLabel;
		
		public function PerWarRankingItemView(argMediator:SceneMediator,argInfo:PerWarMembersItemInfo = null)
		{
			super();
			_mediator = argMediator;
			_info = argInfo;
			initialView();
		}
		
		private function initialView():void
		{
			mouseChildren = mouseEnabled = false;
			_rankingLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_rankingLabel.mouseEnabled = _rankingLabel.mouseWheelEnabled = false;
			_rankingLabel.move(13,0);
			addChild(_rankingLabel);
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_nameLabel.mouseEnabled = _nameLabel.mouseWheelEnabled = false;
			_nameLabel.move(90,0);
			addChild(_nameLabel);
			
			_scoreLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_scoreLabel.mouseEnabled = _scoreLabel.mouseWheelEnabled = false;
			_scoreLabel.move(180,0);
			addChild(_scoreLabel);
			updateData();
		}
		
		public function updateData():void
		{
			if(_info)
			{
				_rankingLabel.text = _info.rankingNum.toString();
				_nameLabel.text = "[" + _info.serverId + "]" + _info.playerNick;
				_scoreLabel.text = _info.score.toString();
			}
			else
			{
				_rankingLabel.text = "";
				_nameLabel.text = "";
				_scoreLabel.text = "";
			}
		}
		
		public function get info():PerWarMembersItemInfo
		{
			return _info;
		}
		
		public function set info(value:PerWarMembersItemInfo):void
		{
			_info = value;
			updateData();
		}
		
		public function dispose():void
		{
			_mediator = null;
			_info = null;
			_rankingLabel = null;
			_nameLabel = null;
			_scoreLabel = null;
		}

	}
}