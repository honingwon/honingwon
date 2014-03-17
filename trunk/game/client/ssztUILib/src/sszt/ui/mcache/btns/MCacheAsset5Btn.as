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
	import mhsm.ui.BtnAsset5;
	/**
	 * 此类已过期 
	 * @author lxb
	 * 
	 */	
	public class MCacheAsset5Btn extends MAssetButton
	{
		private static const movies:Array = new Array(3);
		private static var _scale9Grid:Rectangle;
		private static var _TEXTFORMAT:TextFormat = new TextFormat("宋体",12,0xFFFFFF);
		private static var _FILTER:Array = [new GlowFilter(0x3C4903,1,3,3,8)];
//		private static const _xscaleTypes:Vector.<Number> = Vector.<Number>([1,1.2,1.5]);
		private static const _xscaleTypes:Array = [1,1.2,1.5];
		
		private static function getScale9Grid():Rectangle
		{
			if(_scale9Grid == null)
			{
				_scale9Grid = new Rectangle(13,8,7,3);
			}
			return _scale9Grid;
		}
		
		
		private var _type:int;
		public function MCacheAsset5Btn(type:int,label:String = "")
		{
			_type = type;
			_labelYOffset = 2;
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
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(BtnAsset5,1,33,19,1,xscale,1);
				if(xscale != 1)param.scale9Grid = getScale9Grid();
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				movies[_type] = f;
			}
			return f.getMovie() as DisplayObject;
		}
	}
}