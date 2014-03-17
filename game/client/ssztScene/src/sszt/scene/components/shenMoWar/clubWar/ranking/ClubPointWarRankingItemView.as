package sszt.scene.components.shenMoWar.clubWar.ranking
{
	import flash.display.Sprite;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarClubItemInfo;
	import sszt.scene.mediators.SceneMediator;
	
	public class ClubPointWarRankingItemView extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _info:ClubPointWarClubItemInfo;
		private var _clubRankLabel:MAssetLabel;
		private var _clubScoreNameLabel:MAssetLabel;
		private var _clubNameLabel:MAssetLabel;
		
		public function ClubPointWarRankingItemView(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
		}
		
		private function initialView():void
		{
			mouseChildren = mouseEnabled = false;
			
			_clubRankLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubRankLabel.mouseEnabled = _clubRankLabel.mouseWheelEnabled = false;
			_clubRankLabel.move(15,0);
			addChild(_clubRankLabel);
			
			_clubNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubNameLabel.mouseEnabled = _clubNameLabel.mouseWheelEnabled = false;
			_clubNameLabel.move(90,0);
			addChild(_clubNameLabel);
			
			_clubScoreNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubScoreNameLabel.mouseEnabled = _clubScoreNameLabel.mouseWheelEnabled = false;
			_clubScoreNameLabel.move(175,0);
			addChild(_clubScoreNameLabel);
			

			
		}
		
		public function updateData():void
		{
			if(_info)
			{
				_clubRankLabel.text = _info.rankNum.toString();
				_clubNameLabel.text = _info.clubName;
				_clubScoreNameLabel.text = _info.clubScore.toString();
			}
			else
			{
				_clubRankLabel.text = "";
				_clubScoreNameLabel.text = "";
				_clubNameLabel.text = "";
			}
		}
		
		public function get info():ClubPointWarClubItemInfo
		{
			return _info;
		}
		
		public function set info(value:ClubPointWarClubItemInfo):void
		{
			_info = value;
			updateData();
		}
		
		public function dispose():void
		{
			_mediator = null;
			_info = null;
			_clubScoreNameLabel = null;
			_clubNameLabel = null;
			_clubRankLabel = null;
			if(parent)parent.removeChild(this);
		}
	}
}