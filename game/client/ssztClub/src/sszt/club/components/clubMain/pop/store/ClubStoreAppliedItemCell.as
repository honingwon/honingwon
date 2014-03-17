package sszt.club.components.clubMain.pop.store
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.character.ILayerInfo;
	
	public class ClubStoreAppliedItemCell extends BaseItemInfoCell
	{
		private var _count:TextField;
		public function ClubStoreAppliedItemCell()
		{
			super();
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
				_count.x = 4;
				_count.y = 22;
				_count.width = 33;
				addChild(_count);
				_count.text = String(itemInfo.count>1?itemInfo.count:"");
			}
			else
			{
				removeChild(_count);
				_count = null;
			}
		}
	}
}