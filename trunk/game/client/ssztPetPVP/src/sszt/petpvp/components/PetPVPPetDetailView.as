package sszt.petpvp.components
{
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	public class PetPVPPetDetailView extends MSprite
	{
		private var _nickLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _stairsLabel:MAssetLabel;
		private var _winRateLabel:MAssetLabel;
		private var _fightLabel:MAssetLabel;
		private var _placeLabel:MAssetLabel;
		
		public function PetPVPPetDetailView()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_nickLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			addChild(_nickLabel);
			
			_levelLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_levelLabel.move(0,20);
			addChild(_levelLabel);
			
			_stairsLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_stairsLabel.move(50,20);
			addChild(_stairsLabel);
			
			_winRateLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_winRateLabel.move(0,40);
			addChild(_winRateLabel);
			
			_fightLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_fightLabel.move(0,60);
			addChild(_fightLabel);
			
			_placeLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_placeLabel.move(0,80);
			addChild(_placeLabel);
		}
		
		public function updateView(info:PetPVPPetItemInfo):void
		{
			_nickLabel.setValue(info.nick);
			_levelLabel.setValue(info.level.toString());
			_stairsLabel.setValue(info.stairs.toString());
			_winRateLabel.setValue(int(info.win/info.total*100)+'%');
			_fightLabel.setValue(info.fight.toString());
			_placeLabel.setValue(info.place.toString());
		}
		
		override public function dispose():void
		{
			super.dispose();
			_nickLabel = null;
			_levelLabel = null;
			_stairsLabel = null;
			_winRateLabel = null;
			_fightLabel = null;
			_placeLabel = null;
		}
	}
}