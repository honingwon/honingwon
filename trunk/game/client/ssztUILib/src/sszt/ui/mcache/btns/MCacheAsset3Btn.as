package sszt.ui.mcache.btns
{
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import ssztui.ui.BtnDeathAsset;
	/**
	 * 此类已过期 
	 * @author lxb
	 * 
	 */	
	public class MCacheAsset3Btn extends MAssetButton
	{
		private static const movies:Array = new Array(5);
		private static var _scale9Grid:Rectangle;
		private static var _TEXTFORMAT:TextFormat = new TextFormat("SimSun",12,0xffe18d);
		private static var _FILTER:Array = [new GlowFilter(0x1c404b,1,2,2,8)];
//		private static const _xscaleTypes:Vector.<Number> = Vector.<Number>([1,1.3,1.6,4.1,2]);
		private static const _xscaleTypes:Array = [1,1.3,1.6,6.8,2];
		
		private static function getScale9Grid():Rectangle
		{
			if(_scale9Grid == null)
			{
				_scale9Grid = new Rectangle(20,10,6,3);
			}
			return _scale9Grid;
		}
		
		
		private var _type:int;
		public function MCacheAsset3Btn(type:int,label:String = "")
		{
			_type = type;
			if(_type < 0)_type = 0;
			else if(_type > movies.length - 1)_type = movies.length - 1;
			super(null, label);
			labelField.defaultTextFormat = _TEXTFORMAT;
			labelField.setTextFormat(_TEXTFORMAT);
			labelField.filters = _FILTER;
		}
		
		/**
		 * 此方法不重新绘制按钮背景
		 * @param label
		 * 
		 */		
		public function setLabel(label:String):void
		{
			labelField.text = label;
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = movies[_type];
			if(f == null)
			{
				var xscale:Number = _xscaleTypes[_type];
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(BtnDeathAsset,1,30,25,1,xscale,1);
				if(xscale != 1)param.scale9Grid = getScale9Grid();
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				movies[_type] = f;
			}
			return f.getMovie() as DisplayObject;
		}
	}
}