package sszt.scene.components.pvpFirst.item
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.ui.CellBigBgAsset;
	
	public class GoodsCell extends BaseCell
	{
		private var _item:ItemInfo;
		private var _countLabel:TextField;
		
		public function GoodsCell()
		{
			super();
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,0,50,50),new Bitmap(new CellBigBgAsset())));
			
			_countLabel = new TextField();
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countLabel.defaultTextFormat = t;
			_countLabel.setTextFormat(t);
			_countLabel.x = 0;
			_countLabel.y = 34;
			_countLabel.width = 47;
			_countLabel.height = 14;
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
					_countLabel.text = String(_item.count>1?_item.count:"");
				}	
			}else 
			{
				info = null;
				_countLabel.text = "";
			}
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,44,44);
		}
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON; 
		}
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
		public function get boundSprite():Sprite
		{
			return _boundSprite;
		}
		override public function dispose():void
		{
			_item = null;
			_countLabel = null;
			super.dispose();
		}
	}
}