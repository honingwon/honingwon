package sszt.moviewrapper
{
	import flash.display.BitmapData;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.*;
	
	public class BDMovieWrapperFactory implements IBDMovieWrapperFactory 
	{
		
		private var _bitmapdata:BitmapData;
		private var _info:MovieWrapperInfo;
		
		public function BDMovieWrapperFactory(bd:BitmapData, info:MovieWrapperInfo)
		{
			_bitmapdata = bd;
			_info = info;
		}
		public function getMovie():IMovieWrapper
		{
			if (_bitmapdata == null){
				return (null);
			};
			var t:BaseMovieWrapper = new BaseMovieWrapper(_bitmapdata, _info);
			t.gotoAndStop(1);
			return (t);
		}
		public function dispose():void
		{
			_info = null;
			if (_bitmapdata){
				_bitmapdata.dispose();
				_bitmapdata = null;
			};
		}
		public function getBitmapData():BitmapData
		{
			return (_bitmapdata);
		}
		
	}
}