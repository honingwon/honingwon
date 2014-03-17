package sszt.core.data
{
	import flash.utils.Dictionary;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;

	/**
	 * pkg资源引用记录，在切场景后清除
	 * 切场景后会清除本文件所有数据，慎用。
	 * @author Administrator
	 * 
	 */	
	public class PkgRecord
	{
		private static var _list:Array = [];
		
		public static function getFile(path:String,id:int,layerType:String,sex:int,callback:Function):void
		{
			var t:String = GlobalAPI.pathManager.getMoviePath(path);
			if(_list.indexOf(t) == -1)
				_list.push(t);
			GlobalAPI.loaderAPI.getPngPackageFile(t,id,layerType,sex,callback,SourceClearType.CHANGE_SCENE);
		}
		
		public static function clear():void
		{
			var t:Array = _list;
			for each(var i:String in _list)
			{
//				GlobalAPI.loaderAPI.clearPngPackageFile(i);
			}
			_list.length = 0;
		}
	}
}