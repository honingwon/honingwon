package sszt.pet.component.cells
{
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.BaseSkillCell;
	import sszt.interfaces.character.ILayerInfo;
	
	public class PetSkillBookCell extends BaseItemInfoCell
	{
		private var _skillBookInfo:ItemInfo;
		
		public function PetSkillBookCell()
		{
			super();
		}
		
		public function set skillBookInfo(_itemInfo:ItemInfo):void
		{
			if(_skillBookInfo == _itemInfo)
			{
				return;
			}
			_skillBookInfo = _itemInfo;
			if(_skillBookInfo)
			{
				super.itemInfo = _itemInfo;
			}
			else
			{
				super.itemInfo = null;
			}
		}
		
		public function get skillBookInfo():ItemInfo
		{
			return _skillBookInfo;
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3, 3, 44, 44);
		}
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;;
		}
		
		
		override public function dispose():void
		{
			_skillBookInfo = null;
			super.dispose();
		}
	}
}