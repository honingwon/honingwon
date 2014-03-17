package sszt.pet.component.cells
{
	import flash.display.Shape;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.pet.mediator.PetMediator;
	
	public class PetEquipCellEmpty extends Shape implements IAcceptDrag
	{
		private var _mediator:PetMediator;
		public function PetEquipCellEmpty(mediator:PetMediator)
		{
			super();
			graphics.beginFill(0xff0000,0);
			graphics.drawRect(0,0,250,50);
			graphics.endFill();
			_mediator = mediator;
		}
		
		public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var sourceData:ItemInfo = source.getSourceData() as ItemInfo;
			var action:int = DragActionType.UNDRAG;
			if(!sourceData) return action;
			
			if(source.getSourceType() == CellType.BAGCELL)
			{
				if(!CategoryType.isPetEquip(sourceData.template.categoryId))
				{
					QuickTips.show('非宠物装备无法装备。');
					return action;
				}
			}
			
			var currentPet:PetItemInfo = _mediator.module.petsInfo.currentPetItemInfo;
			var fightPet:PetItemInfo = GlobalData.petList.getFightPet();
			
			if(!fightPet || fightPet.id != currentPet.id)
			{
				QuickTips.show('对不起，您只能给出战的宠物穿装备。');
				return action;
			}
			
			if(sourceData.template.needLevel > currentPet.level)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.levelNotEnough"));
				return action;
			}
			
			ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.PET_BAG,29,currentPet.id);
			return action;
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}
	}
}