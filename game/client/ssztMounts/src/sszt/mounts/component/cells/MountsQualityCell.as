package sszt.mounts.component.cells
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.mounts.data.itemInfo.MountsFeedItemInfo;
	
	public class MountsQualityCell extends BaseItemInfoCell
	{
		private var _mountsItemInfo:MountsFeedItemInfo;
		private var _countLabel:TextField;
		
		public function MountsQualityCell(itemInfo:MountsFeedItemInfo = null)
		{
			super();
			
			_countLabel = new TextField();
			_countLabel.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_countLabel.autoSize = TextFormatAlign.RIGHT;
			_countLabel.x = 10;
			_countLabel.y = 23;
			_countLabel.width = 25;
			_countLabel.height = 25;
			_countLabel.mouseEnabled = _countLabel.mouseWheelEnabled = false;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
			mountsItemInfo = itemInfo;
		}

		public function get mountsItemInfo():MountsFeedItemInfo
		{
			return _mountsItemInfo;
		}

		public function set mountsItemInfo(value:MountsFeedItemInfo):void
		{
			if(_mountsItemInfo == value)
			{
				if(!value){return ;}
			}
			_mountsItemInfo = value;
			if(_mountsItemInfo)
			{
				itemInfo = _mountsItemInfo.bagItemInfo;
				if(CategoryType.isEquip(itemInfo.template.categoryId))
				{
					if(itemInfo.strengthenLevel > 0)
						_countLabel.text = "+" + String(itemInfo.strengthenLevel);
					else
						_countLabel.text = "";
				}
				else
				{
					_countLabel.text = String(itemInfo.count);
				}	
				
			}
			else
			{
				itemInfo = null;
				_countLabel.text = "";
			}
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_mountsItemInfo = null;
		}

	}
}