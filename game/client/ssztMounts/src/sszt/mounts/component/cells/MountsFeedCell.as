package sszt.mounts.component.cells
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.loader.IDisplayFileInfo;
	
	public class MountsFeedCell extends BaseCell
	{
		private var _item:ItemInfo;
		private var _countLabel:TextField;
		
		public function MountsFeedCell()
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
		}
		
		public function get itemInfo():ItemInfo
		{
			return _item;
		}
		
		public function set itemInfo(item:ItemInfo):void
		{
			if(_item == item) return;
			_item = item;
			if(_item)
			{
				info = item.template;
				if(CategoryType.isEquip(_item.template.categoryId))
				{
					if(_item.strengthenLevel > 0)
						_countLabel.text = "+" + String(_item.strengthenLevel);
					else
						_countLabel.text = "";
				}
				else
				{
					_countLabel.text = String(_item.count);
				}	
			}else 
			{
				info = null;
				_countLabel.text = "";
			}
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
		}
				
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,32,32);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(_item,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
		
//		override public function dragDrop(data:IDragData):int
//		{
//			return 0;
//		}
		override public function dispose():void
		{
			_item = null;
			super.dispose();
		}
	}
}