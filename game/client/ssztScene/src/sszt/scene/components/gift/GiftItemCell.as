package sszt.scene.components.gift
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
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
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class GiftItemCell extends BaseItemInfoCell
	{
		
		private var _count:TextField;
		private var _over:Bitmap;
		private var _ef:MovieClip;
		
		public function GiftItemCell()
		{
			super();
			
			_ef = MovieCaches.getCellBlinkAsset();
			_ef.x = -19;
			_ef.y = -18;
			addChild(_ef);
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
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.visible = false;
			addChild(_over);
			
			
		}
		
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
//			setChildIndex(_over,numChildren-1);
			if(_count)
			{
				addChild(_count);
			}
			setChildIndex(_ef,numChildren-1);
			
		}
	}
}