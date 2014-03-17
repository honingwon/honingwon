package sszt.scene.components.shenMoWar.ranking
{
	import flash.display.Sprite;
	
	import sszt.ui.button.MAssetButton;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class ShenMoRankingItemView extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _info:ShenMoWarMembersItemInfo;
		private var _rankingLabel:MAssetLabel;
		private var _nameLabel:MAssetLabel;
		private var _killCountLabel:MAssetLabel;
		
		public function ShenMoRankingItemView(argMediator:SceneMediator,argInfo:ShenMoWarMembersItemInfo = null)
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
			
			_killCountLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_killCountLabel.mouseEnabled = _killCountLabel.mouseWheelEnabled = false;
			_killCountLabel.move(180,0);
			addChild(_killCountLabel);
			updateData();
		}
		
		public function updateData():void
		{
			if(_info)
			{
				_rankingLabel.text = _info.rankingNum.toString();
				_nameLabel.text = "[" + _info.serverId + "]" + _info.playerNick;
				_killCountLabel.text = _info.attackPepNum.toString();
			}
			else
			{
				_rankingLabel.text = "";
				_nameLabel.text = "";
				_killCountLabel.text = "";
			}
		}

		public function get info():ShenMoWarMembersItemInfo
		{
			return _info;
		}

		public function set info(value:ShenMoWarMembersItemInfo):void
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
			 _killCountLabel = null;
		}

	}
}