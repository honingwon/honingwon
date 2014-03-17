package sszt.scene.components.shenMoWar.clubWar.mainInfo
{
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarClubItemInfo;
	
	public class ClubPointWarMainItemView extends Sprite
	{
		private var _info:ClubPointWarClubItemInfo;;
		private var _clubRankLabel:MAssetLabel;
		private var _clubScoreNameLabel:MAssetLabel;
		private var _clubNameLabel:MAssetLabel;
		public function ClubPointWarMainItemView()
		{
			super();
			initialView();
		}
		
		private function initialView():void
		{
			mouseChildren = mouseEnabled = false;
			_clubRankLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubRankLabel.mouseEnabled = _clubRankLabel.mouseWheelEnabled = false;
			_clubRankLabel.move(23,0);
			addChild(_clubRankLabel);
			
			_clubNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubNameLabel.mouseEnabled = _clubNameLabel.mouseWheelEnabled = false;
			_clubNameLabel.move(138,0);
			addChild(_clubNameLabel);
			
			_clubScoreNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_clubScoreNameLabel.mouseEnabled = _clubScoreNameLabel.mouseWheelEnabled = false;
			_clubScoreNameLabel.move(250,0);
			addChild(_clubScoreNameLabel);
			
		}
		
		private function updateLabel():void
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
			updateLabel();
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			_info = null;
			_clubRankLabel = null;
			_clubScoreNameLabel = null;
			_clubNameLabel = null;
		}
	}
}