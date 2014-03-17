package sszt.role.components
{
	import flash.display.Shape;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.ui.container.MAlert;
	
	public class RoleCellEmpty extends Shape implements IAcceptDrag
	{
		public function RoleCellEmpty()
		{
			super();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,270,269);
			graphics.endFill();
		}
		
		public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var sourceData:ItemInfo = source.getSourceData() as ItemInfo;
			var action:int = DragActionType.UNDRAG;
			if(!source) return action;
			if(source.getSourceType() == CellType.BAGCELL)
			{
				if(CategoryType.isPetEquip(sourceData.template.categoryId))
				{
					QuickTips.show('无法装备宠物装备。');
					return action;
				}
				if(GlobalData.selfScenePlayerInfo.getIsFight())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.cannotChangeEquip"));
					return action;
				}
				if(sourceData.template.needCareer != 0&&sourceData.template.needCareer != GlobalData.selfPlayer.career)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.careerNotFit"));
					return action;
				}
				if(sourceData.template.needSex != 0&& sourceData.template.needSex != GlobalData.selfPlayer.getSex())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.sexNotFit"));
					return action;
				}
				if(sourceData.template.needLevel >GlobalData.selfPlayer.level)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.levelNotEnough"));
					return action;
				}
				if(sourceData.template.durable != -1 && sourceData.durable == 0)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.durabilityZero"));
					return action;
				}
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,sourceData.place,CommonBagType.BAG,29,1);
				action = DragActionType.DRAGIN;
			}
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