package sszt.scene.components.climbTowerPanel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class DropCell extends BaseItemInfoCell
	{
		private var _count:TextField;
		public function DropCell()
		{
			super();
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,0,38,38),new Bitmap(CellCaches.getCellBg())));
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(value)
			{
				_count = new TextField();
				_count.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
				_count.filters = [new GlowFilter(0x1D250E,1,2,2,10)];
				_count.mouseEnabled = _count.mouseWheelEnabled = false;
				_count.maxChars = 2;
				_count.x = 17;
				_count.y = 23;
				_count.width = 20;
				_count.height = 20;
				addChild(_count);
				_count.text = String(itemInfo.count);
			}
			else
			{
				if(_count)
				{
					removeChild(_count);
					_count = null;
				}
			}
		}
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			if(_count)
			{
				addChild(_count);
			}
		}
	}
}