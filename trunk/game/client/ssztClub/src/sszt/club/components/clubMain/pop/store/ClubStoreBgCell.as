package sszt.club.components.clubMain.pop.store
{
	import flash.geom.Rectangle;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.club.socketHandlers.ClubStorePutSocketHandler;
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	
	public class ClubStoreBgCell extends BaseCell implements IAcceptDrag
	{
		public function ClubStoreBgCell()
		{
			super();
			mouseEnabled = mouseChildren = false;
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(0,0,390,194);
		}
		
		override public function getSourceType():int
		{
			return CellType.CLUBSTORECELL;
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.UNDRAG;
			if(!source)return action;
			var bagItemInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(source == this){}
			else if(source.getSourceType() == CellType.BAGCELL)
			{
				if(bagItemInfo.isBind)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.club.itemBinded"));
				}
				else
				{
					MAlert.show(LanguageManager.getWord("ssztl.club.surePutItemToStore"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					action =DragActionType.DRAGIN;
				}				
			}
			return action;
			
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					ClubStorePutSocketHandler.send(bagItemInfo.place);
				}
			}
		}
	}
}