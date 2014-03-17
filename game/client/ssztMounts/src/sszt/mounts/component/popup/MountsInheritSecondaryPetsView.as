package sszt.mounts.component.popup
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.mounts.component.MountsInheritView;
	import sszt.mounts.component.cells.PetCell;
	import sszt.ui.container.MTile;
	
	public class MountsInheritSecondaryPetsView extends Sprite
	{
		private const CELL_MAX:int = 8;
		private var _petItemInfoList:Array;
		
		private var _tile:MTile;
		
		private var _petCellList:Array;
		private var _currentPetCell:PetCell;
		
		public function MountsInheritSecondaryPetsView()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			_petCellList = [];
			_tile = new MTile(38,38,8);
			_tile.setSize(304,38);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = _tile.itemGapW = 0;
			addChild(_tile);
			var cell:PetCell;
			for(var i:int = 0; i < CELL_MAX; i++)
			{
				cell = new PetCell();
				_tile.appendItem(cell);
				_petCellList.push(cell);
			}
		}
		
		public function get mountsItemInfoList():Array
		{
			return _petItemInfoList;
		}
		
		public function set mountsItemInfoList(petItemInfoList:Array):void
		{
			_currentPetCell = PetCell(_petCellList[0]);
			_currentPetCell.selected = true;
			_petItemInfoList = petItemInfoList;
			for(var i:int = 0; i < _petItemInfoList.length; i++)
			{
				PetCell(_petCellList[i]).buttonMode = true;
				PetCell(_petCellList[i]).mountsItemInfo = MountsItemInfo(_petItemInfoList[i]);
				PetCell(_petCellList[i]).addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				PetCell(_petCellList[i]).addEventListener(MouseEvent.CLICK, onMouseClick)
			}
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			var targetCell:PetCell = event.currentTarget as PetCell;
			MountsInheritView(parent).secondaryPetCell.mountsItemInfo = targetCell.mountsItemInfo;
			MountsInheritView(parent).updateFuseAttr();
			MountsInheritView(parent).secondaryName.setValue(targetCell.mountsItemInfo.nick);
			MountsInheritView(parent).secondaryName.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(targetCell.mountsItemInfo.templateId).quality);
			MountsInheritView(parent).resultPetCell.visible = true;
			this.visible = false;
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			var targetCell:PetCell = event.currentTarget as PetCell;
			_currentPetCell.selected = false;
			_currentPetCell = targetCell;
			_currentPetCell.selected = true;
		}
		
		public function clear():void
		{
			_petItemInfoList = null;
			_currentPetCell.selected = false;
			for(var i:int = 0; i < _petCellList.length; i++)
			{
				PetCell(_petCellList[i]).mountsItemInfo = null;
				PetCell(_petCellList[i]).removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				PetCell(_petCellList[i]).removeEventListener(MouseEvent.CLICK, onMouseClick)
			}
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			_petItemInfoList = null;
		}
	}
}