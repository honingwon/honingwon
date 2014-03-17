package sszt.scene.components.copyGroup.sec
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import sszt.ui.mcache.cells.CellCaches;
	
	import sszt.core.data.item.ItemTemplateInfo;
	
	public class AwardItemView extends Sprite
	{
		private var _bg:Bitmap;
		private var _itemInfo:ItemTemplateInfo;
		private var _cell:AwardCell;
		
		public function AwardItemView(item:ItemTemplateInfo)
		{
			_itemInfo = item;
			super();
			init();
		}
		
		private function init():void
		{
			_bg = new Bitmap(CellCaches.getCellBg());
			addChild(_bg);
			
			_cell = new AwardCell();
			_cell.info = _itemInfo;
			_cell.move(0,0);
			addChild(_cell);
		}
		
		public function dispose():void
		{
			_bg = null;
			_itemInfo = null;
			_cell.dispose();
			_cell = null;
			if(parent) parent.removeChild(this);
		}
	}
}