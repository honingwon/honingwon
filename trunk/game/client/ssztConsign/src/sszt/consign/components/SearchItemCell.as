package sszt.consign.components
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.loader.IDisplayFileInfo;
	
	public class SearchItemCell extends BaseItemInfoCell
	{
		private var _countTextField:TextField;
		
		public function SearchItemCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
			
			_countTextField = new TextField();
			_countTextField.textColor = 0xFFFFFF;
			_countTextField.selectable = false;
			_countTextField.x = 4;
			_countTextField.y = 22;
			_countTextField.width = 33;
			_countTextField.height = 15;
			_countTextField.mouseEnabled = _countTextField.mouseWheelEnabled = false;
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countTextField.defaultTextFormat = t;
			_countTextField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			
		}
		
		override protected function lockUpdateHandler(evt:ItemInfoUpdateEvent):void
		{
			
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			_iteminfo = value;
			if(_iteminfo)
			{
//				_countTextField.text = _iteminfo.count.toString();
				info = _iteminfo.template;
				if(CategoryType.isEquip(_iteminfo.template.categoryId))
				{
					if(_iteminfo.strengthenLevel > 0)
						_countTextField.text = "+" + String(_iteminfo.strengthenLevel);
				}
				else
				{
					_countTextField.text = String(_iteminfo.count>1?_iteminfo.count:"");
				}
			}
			else
			{
				_countTextField.text = "";
				info = null;
			}
		}
		
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countTextField);
		}
		
		override protected function setItemLock():void
		{
		}
		
		override public function dispose():void
		{
			_countTextField = null;
			super.dispose();
		}
	}
}