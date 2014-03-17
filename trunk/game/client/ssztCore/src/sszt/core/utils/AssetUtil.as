package sszt.core.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class AssetUtil
	{
		
		private static var _bitmaps:Dictionary = new Dictionary();
		
		public static function getAsset(className:String,classType:Class = null,...classParam):Object
		{
			var t:Object = GlobalAPI.loaderAPI.getObjectByClassPath(className);
			if(t)return t;
			if(classType == null)return null;
			if(classParam.length > 0)
				return new classType(classParam);
			if(classType == BitmapData)
			{
				if(classParam.length >= 2)return new classType(classParam[0],classParam[1]);
				else return new classType(1,1);
			}
			return new classType();
		}
		
		public static function setup() : void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.TITLE_ASSET_COMPLETE, updateBitmaps, false, 100);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.NPCTITLE_ASSET_COMPLETE, updateBitmaps, false, 100);
		}
		
		public static function setBitmap(classPath:String, bitmap:Bitmap) : void
		{
//			var i:int = 0;
			if (doSet(classPath, bitmap))
			{
				return;
			}
			var list:Array = _bitmaps[classPath];
			if (!list)
			{
				list = [];
				_bitmaps[classPath] = list;
			}
			list.push(bitmap);
//			i = list.indexOf(i);
//			if (i == -1)
//			{
//				list.push(bitmap);
//			}
		} 
		
		public static function removeBitmap(classPath:String, bitmap:Bitmap) : void
		{
			var index:int = 0;
			var list:Array = _bitmaps[classPath];
			if (list)
			{
				index = list.indexOf(bitmap);
				if (index > -1)
				{
					list.splice(index, 1);
					if (list.length <= 0)
					{
						delete _bitmaps[classPath];
					}
				}
			}
		} 
		
		private static function doSet(classPath:String, bitmap:Bitmap) : Boolean
		{
			var bitmapdata:BitmapData = getAsset(classPath) as BitmapData;
			if (bitmapdata)
			{
				bitmap.bitmapData = bitmapdata;
				return true;
			}
			return false;
		}
		
		
		private static function updateBitmaps(event:Event) : void
		{
			var key:String = null;
			var bitmap:BitmapData = null;
			var list:Array = [];
			var i:int = 0;
			for (key in _bitmaps)
			{
				bitmap = getAsset(key) as BitmapData;
				if (bitmap)
				{
					list = _bitmaps[key];
					if (list)
					{
						i = 0;
						while (i < list.length)
						{
							
							list[i].bitmapData = bitmap;
							i = i + 1;
						}
						delete _bitmaps[key];
					}
				}
			}
		}
		
	}
}