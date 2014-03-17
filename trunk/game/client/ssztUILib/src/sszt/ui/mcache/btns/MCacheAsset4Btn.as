package sszt.ui.mcache.btns
{
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import mhsm.ui.BtnAsset4;
	/**
	 * 此类已过期 
	 * @author lxb
	 * 
	 */	
	public class MCacheAsset4Btn extends MAssetButton
	{
		private static const movies:Array = new Array(3);
		private static var _scale9Grid:Rectangle;
		private static var _TEXTFORMAT:TextFormat = new TextFormat("宋体",12,0xffffff);
		private static var _FILTER:Array = [new GlowFilter(0x3C4903,1,3,3,8)];
//		private static const _xscaleTypes:Vector.<Number> = Vector.<Number>([1,1.2,1.5]);
		private static const _xscaleTypes:Array = [1,1.3,1.5];
		
		private static function getScale9Grid():Rectangle
		{
			if(_scale9Grid == null)
			{
				_scale9Grid = new Rectangle(15,6,10,7);
			}
			return _scale9Grid;
		}
		
		
		private var _type:int;
		public function MCacheAsset4Btn(type:int,label:String = "")
		{
			_type = type;
			if(_type < 0)_type = 0;
			else if(_type > movies.length - 1)_type = movies.length - 1;
			super(null, label);
			labelField.defaultTextFormat = _TEXTFORMAT;
			labelField.setTextFormat(_TEXTFORMAT);
			labelField.filters = _FILTER;
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = movies[_type];
			if(f == null)
			{
				var xscale:Number = _xscaleTypes[_type];
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(BtnAsset4,1,40,19,1,xscale,1);
				if(xscale != 1)param.scale9Grid = getScale9Grid();
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				movies[_type] = f;
			}
			return f.getMovie() as DisplayObject;
		}
	}
}