package sszt.petpvp.components
{
	import fl.controls.ScrollPolicy;
	
	import sszt.petpvp.components.item.PetPVPRankItemView;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	
	public class PetPVPRankView extends MSprite
	{
		private var _tile:MTile;
		
		public function PetPVPRankView()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_tile = new MTile(140,70);
			_tile.setSize(140,210);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
		}
		
		public function updateView(rankInfo:Array):void
		{
			clear();
			var infoItem:PetPVPPetItemInfo;
			var viewItem:PetPVPRankItemView;
			for(var i:int = 0; i < rankInfo.length; i++)
			{
				infoItem = rankInfo[i];
				viewItem = new PetPVPRankItemView(infoItem);
				_tile.appendItem(viewItem);
			}
		}
		
		public function clear():void
		{
			_tile.disposeItems();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
		}
	}
}