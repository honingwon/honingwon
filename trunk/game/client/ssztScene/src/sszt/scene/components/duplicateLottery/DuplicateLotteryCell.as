package sszt.scene.components.duplicateLottery
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.character.ILayerInfo;
	
	public class DuplicateLotteryCell extends BaseItemInfoCell
	{
		private var _count:TextField;
		
		public function DuplicateLotteryCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(value)
			{
				_count = new TextField();
				_count.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
				_count.filters = [new GlowFilter(0x1D250E,1,4,4,4.5)];
				_count.mouseEnabled = _count.mouseWheelEnabled = false;
				_count.maxChars = 2;
				_count.x = 17;
				_count.y = 20;
				_count.width = 20;
				_count.height = 20;
				addChild(_count);
//				_count.text = String(itemInfo.count);
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