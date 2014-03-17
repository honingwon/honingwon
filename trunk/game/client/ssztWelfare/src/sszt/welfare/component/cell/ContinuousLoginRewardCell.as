package sszt.welfare.component.cell
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.character.ILayerInfo;
	
	public class ContinuousLoginRewardCell extends BaseItemInfoCell
	{
		private var _count:TextField;
		private var _name:TextField;
		
		public function ContinuousLoginRewardCell()
		{
			super();
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(value)
			{
				if(!_count)
				{
					_count = new TextField();
					_count.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
					_count.filters = [new GlowFilter(0x1D250E,1,2,2,6)];
					_count.mouseEnabled = _count.mouseWheelEnabled = false;
					_count.maxChars = 2;
					_count.x = 4;
					_count.y = 22;
					_count.width = 33;
					_count.height = 14;
					addChild(_count);
				}
				
				_count.text = String(itemInfo.count>1?itemInfo.count:"");
				
				if(!_name)
				{
					_name = new TextField();
					_name.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(ItemTemplateList.getTemplate(itemInfo.templateId).quality),null,null,null,null,null,TextFormatAlign.LEFT);
					//				_name.filters = [new GlowFilter(0x1D250E,1,2,2,6)];
					_name.mouseEnabled = _count.mouseWheelEnabled = false;
					_name.x = 44;
					_name.y = 12;
					_name.width = 100;
					_name.height = 18;
					addChild(_name);
				}
				_name.text = itemInfo.template.name + '×' + itemInfo.count;
			}
			else
			{
				if(_count)
				{
					removeChild(_count);
					_count = null;
				}
				if(_name)
				{
					removeChild(_name);
					_name = null;
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