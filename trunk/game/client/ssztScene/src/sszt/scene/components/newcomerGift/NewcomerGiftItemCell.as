package sszt.scene.components.newcomerGift
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.character.ILayerInfo;
	
	public class NewcomerGiftItemCell extends BaseItemInfoCell
	{
		private var _count:TextField;
		private var _over:Bitmap;
		
		public function NewcomerGiftItemCell()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.visible = false;
			addChild(_over);
			
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			this.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
		}
		
		private function itemOverHandler(evt:MouseEvent):void
		{
			over = true;
		}
		
		private function itemOutHandler(evt:MouseEvent):void
		{
			over = false;
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(value)
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
				_count.text = String(itemInfo.count>1?itemInfo.count:"");
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
		
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			setChildIndex(_over,numChildren-1);
			if(_count)
			{
				addChild(_count);
			}
		}
	}
}