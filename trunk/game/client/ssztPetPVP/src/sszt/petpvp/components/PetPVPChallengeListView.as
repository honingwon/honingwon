package sszt.petpvp.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.MouseEvent;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.petpvp.components.item.PetPVPChallengePetItemView;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.petpvp.events.PetPVPUIEvent;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	
	public class PetPVPChallengeListView extends MSprite
	{
		private var _bg:IMovieWrapper;
		
		private var _tile:MTile;
		
		private var _viewList:Array;
		private var _currChallengePetItemView:PetPVPChallengePetItemView;
		
		public function PetPVPChallengeListView()
		{
			_viewList = [];
			super();
			addEvent();
		}
		
		private function addEvent():void
		{
			var viewItem:PetPVPChallengePetItemView;
			for each(viewItem in _viewList)
			{
				viewItem.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			var viewItem:PetPVPChallengePetItemView;
			for each(viewItem in _viewList)
			{
				viewItem.removeEventListener(MouseEvent.CLICK,itemViewClickHandler);
			}
		}
		
		protected function itemViewClickHandler(event:MouseEvent):void
		{
			var targetl:PetPVPChallengePetItemView = event.currentTarget as PetPVPChallengePetItemView;
			switchToChallengePet(targetl);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_tile = new MTile(80,125,6);
			_tile.setSize(486,125);
			_tile.itemGapH = _tile.itemGapW = 1;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
		}
		
		public function updateView(info:Array):void
		{
			clear();
			var infoItem:PetPVPPetItemInfo;
			var viewItem:PetPVPChallengePetItemView;
			for(var i:int = 0; i < info.length; i++)
			{
				infoItem = info[i];
				viewItem = new PetPVPChallengePetItemView(infoItem);
				_tile.appendItem(viewItem);
				_viewList.push(viewItem);
			}
			addEvent();
		}
		
		private function clear():void
		{
			removeEvent();
			_tile.disposeItems();
			_viewList = [];
		}
		
		private function switchToChallengePet(view:PetPVPChallengePetItemView):void
		{
//			if(_currChallengePetItemView == view) return;
//			if(_currChallengePetItemView)
//				_currChallengePetItemView.selected = false;
			_currChallengePetItemView = view;
//			_currChallengePetItemView.selected = true;
			dispatchEvent(new PetPVPUIEvent(PetPVPUIEvent.CHALLENGE_PET_ITEM_VIEW_CHANGE,view.info.id));
		}
		
		public function switchToFirstPet():void
		{
			switchToChallengePet(_viewList[0]);
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			_viewList = null;
			_currChallengePetItemView= null;
		}
	}
}