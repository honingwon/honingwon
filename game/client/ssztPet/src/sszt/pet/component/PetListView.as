package sszt.pet.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetListUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.pet.data.PetStateType;
	import sszt.pet.mediator.PetMediator;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	public class PetListView extends Sprite
	{
		private var _mediator:PetMediator;
		private var _currentPetItemInfo:PetItemInfo;
		private var _petInfoList:Array;
		private var _countLabel:MAssetLabel;
		private var _tile:MTile;
		
		public var currentPetItemView:PetListItemView;
		private var _petViewList:Array;
		
		
		
		public function PetListView(mediator:PetMediator, currentPetItemInfo:PetItemInfo)
		{
			_mediator = mediator;
			_currentPetItemInfo = currentPetItemInfo;
			_petInfoList = GlobalData.petList.getList();
			
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_countLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_countLabel.move(70,358);
			addChild(_countLabel);
			_countLabel.setHtmlValue(LanguageManager.getWord("ssztl.pet.petAmount")+ _petInfoList.length + "/3");
			
			_petViewList = [];			
			_tile = new MTile(141,70);
			_tile.setSize(141,350);
			_tile.itemGapH = _tile.itemGapW = 0;
			addChild(_tile);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			var petListItemView:PetListItemView;
			for each(var petItemInfo:PetItemInfo in _petInfoList)
			{
				petListItemView = new PetListItemView(petItemInfo);
				_tile.appendItem(petListItemView);
				_petViewList.push(petListItemView);
				if(petItemInfo == _currentPetItemInfo)
				{
					currentPetItemView = petListItemView;
				}
			}
			if(currentPetItemView)
			{
				currentPetItemView.selected = true;
			}
		}
		
		private function initEvent():void
		{
			GlobalData.petList.addEventListener(PetListUpdateEvent.ADD_PET, addPetHandler);
			GlobalData.petList.addEventListener(PetListUpdateEvent.REMOVE_PET, removePetHandler);
			
			for(var i:int = 0; i < _petViewList.length; i++)
			{
				PetListItemView(_petViewList[i]).addEventListener(MouseEvent.CLICK, petListItemClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			GlobalData.petList.removeEventListener(PetListUpdateEvent.ADD_PET, addPetHandler);
			GlobalData.petList.removeEventListener(PetListUpdateEvent.REMOVE_PET, removePetHandler);
			
			for(var i:int = 0; i < _petViewList.length; i++)
			{
				PetListItemView(_petViewList[i]).removeEventListener(MouseEvent.CLICK, petListItemClickHandler);
			}
		}
		
		private function petListItemClickHandler(event:MouseEvent):void
		{
			var clickedPetItemView:PetListItemView = event.currentTarget as PetListItemView;
			if(clickedPetItemView != currentPetItemView)
			{
				switchPetTo(clickedPetItemView);
			}
		}
		
		private function addPetHandler(event:PetListUpdateEvent):void
		{
			var petItemInfo:PetItemInfo = event.data as PetItemInfo;
			var petListItemView:PetListItemView = new PetListItemView(petItemInfo);
			_tile.appendItem(petListItemView);
			_petViewList.push(petListItemView);
			switchPetTo(petListItemView);
			
			petListItemView.addEventListener(MouseEvent.CLICK, petListItemClickHandler);
			
			_countLabel.setHtmlValue(LanguageManager.getWord("ssztl.pet.petAmount")+ GlobalData.petList.petCount + "/3");
		}
		
		private function removePetHandler(event:PetListUpdateEvent):void
		{
			var petItemInfo:PetItemInfo = event.data as PetItemInfo;
			var petListItemView:PetListItemView;
			for(var i:int = 0; i<_petViewList.length; i++)
			{
				petListItemView = _petViewList[i] as PetListItemView;
				if(petListItemView.petItemInfo == petItemInfo)
				{
					_petViewList.splice(i,1);
					if(petListItemView == currentPetItemView)
					{
						switchPetTo(_petViewList[0] as PetListItemView);
					}
					_tile.removeItem(petListItemView);
					petListItemView.dispose();
					petListItemView = null;
					break;
				}
			}
			_countLabel.setHtmlValue(LanguageManager.getWord("ssztl.pet.petAmount")+ GlobalData.petList.petCount + "/3");
		}
		
		private function switchPetTo(petTo:PetListItemView):void
		{
			if(currentPetItemView)
			{
				currentPetItemView.selected = false;
			}
			petTo.selected = true;
			currentPetItemView = petTo;
			_mediator.module.petsInfo.switchPetTo(petTo.petItemInfo);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			
			_mediator = null;
			_currentPetItemInfo = null;
			_petInfoList = null;
			
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			_countLabel = null;
			currentPetItemView = null;
			_petViewList = null; 
		}
	}
}