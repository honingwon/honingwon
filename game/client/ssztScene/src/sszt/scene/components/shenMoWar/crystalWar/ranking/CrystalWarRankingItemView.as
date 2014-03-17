package sszt.scene.components.shenMoWar.crystalWar.ranking
{
	import flash.display.Sprite;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.crystalWar.mainInfo.CrystalWarClubItemInfo;
	import sszt.scene.mediators.SceneMediator;
	
	public class CrystalWarRankingItemView extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _info:CrystalWarClubItemInfo;
		private var _cystalRankLabel:MAssetLabel;
		private var _campScoreLabel:MAssetLabel;
		private var _campNameLabel:MAssetLabel;
		
		public function CrystalWarRankingItemView(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
		}
		
		private function initialView():void
		{
			mouseChildren = mouseEnabled = false;
			
			_cystalRankLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_cystalRankLabel.mouseEnabled = _cystalRankLabel.mouseWheelEnabled = false;
			_cystalRankLabel.move(15,0);
			addChild(_cystalRankLabel);
			
			_campNameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_campNameLabel.mouseEnabled = _campNameLabel.mouseWheelEnabled = false;
			_campNameLabel.move(90,0);
			addChild(_campNameLabel);
			
			_campScoreLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_campScoreLabel.mouseEnabled = _campScoreLabel.mouseWheelEnabled = false;
			_campScoreLabel.move(175,0);
			addChild(_campScoreLabel);
			

			
		}
		
		public function updateData():void
		{
			if(_info)
			{
				_cystalRankLabel.text = _info.rankNum.toString();
				_campNameLabel.text = LanguageManager.getWord("ssztl.common.camp2") + _info.campName;
				_campScoreLabel.text = _info.campScore.toString();
			}
			else
			{
				_cystalRankLabel.text = "";
				_campScoreLabel.text = "";
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
			updateData();
		}
		
		public function dispose():void
		{
			_mediator = null;
			_info = null;
			_campScoreLabel = null;
			_campNameLabel = null;
			_cystalRankLabel = null;
			if(parent)parent.removeChild(this);
		}
	}
}