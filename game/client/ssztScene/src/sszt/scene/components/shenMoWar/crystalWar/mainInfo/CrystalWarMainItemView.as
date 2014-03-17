package sszt.scene.components.shenMoWar.crystalWar.mainInfo
{
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.crystalWar.mainInfo.CrystalWarClubItemInfo;
	
	public class CrystalWarMainItemView extends Sprite
	{
		private var _info:CrystalWarClubItemInfo;;
		private var _cystalRankLabel:MAssetLabel;
		private var _campScoreNameLabel:MAssetLabel;
		private var _campNameLabel:MAssetLabel;
		public function CrystalWarMainItemView()
		{
			super();
			initialView();
		}
		
		private function initialView():void
		{
			mouseChildren = mouseEnabled = false;
			_cystalRankLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_cystalRankLabel.mouseEnabled = _cystalRankLabel.mouseWheelEnabled = false;
			_cystalRankLabel.move(23,0);
			addChild(_cystalRankLabel);
			
			_campNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_campNameLabel.mouseEnabled = _campNameLabel.mouseWheelEnabled = false;
			_campNameLabel.move(138,0);
			addChild(_campNameLabel);
			
			_campScoreNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_campScoreNameLabel.mouseEnabled = _campScoreNameLabel.mouseWheelEnabled = false;
			_campScoreNameLabel.move(250,0);
			addChild(_campScoreNameLabel);
			
		}
		
		private function updateLabel():void
		{
			if(_info)
			{
				_cystalRankLabel.text = _info.rankNum.toString();
				_campNameLabel.text = LanguageManager.getWord("ssztl.common.camp2") +_info.campName;
				_campScoreNameLabel.text = _info.campScore.toString();
			}
			else
			{
				_cystalRankLabel.text = "";
				_campScoreNameLabel.text = "";
				_campNameLabel.text = "";
			}
		}
		
		public function get info():CrystalWarClubItemInfo
		{
			return _info;
		}

		public function set info(value:CrystalWarClubItemInfo):void
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
			_cystalRankLabel = null;
			_campScoreNameLabel = null;
			_campNameLabel = null;
		}
	}
}