package sszt.scene.components.functionGuide
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import sszt.ui.container.MSprite;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.functionGuide.FunctionGuideItemInfo;
	
	public class FunctionCell extends MSprite
	{
		private var _bitmap:Bitmap;
		private var _info:FunctionGuideItemInfo;
		private var _picPath:String
		public function FunctionCell()
		{
			super();
			buttonMode = true;
		}
		
		public function set info(item:FunctionGuideItemInfo):void
		{
			if(_info && _info == item)
			{
				return;
			}
			if(item == null)
			{
				_picPath = GlobalAPI.pathManager.getFunctionGuidePath("default");
				GlobalAPI.loaderAPI.getPicFile(_picPath,createPicComplete,SourceClearType.NEVER);
			}
			else
			{
				_picPath = GlobalAPI.pathManager.getFunctionGuidePath(item.iconPath);
				GlobalAPI.loaderAPI.getPicFile(_picPath,createPicComplete,SourceClearType.NEVER);
			}
			_info = item;
		}
		
		public function get info():FunctionGuideItemInfo
		{
			return _info;
		}
		
		private function createPicComplete(data:BitmapData):void
		{
			if(_bitmap == null)
			{
				_bitmap = new Bitmap();
			}
			_bitmap.bitmapData = data;
			_bitmap.x = 2;
			_bitmap.y = 2;
			addChild(_bitmap);
		}
		
		override public function dispose():void
		{
			_info = null;
			super.dispose();
		}
	}
}