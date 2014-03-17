package sszt.ui.mcache.btns
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import mhsm.ui.BtnAsset1;
	/**
	 * 此类已过期 
	 * @author lxb
	 * 
	 */	
	public class MCacheAsset1Btn extends MAssetButton
	{
		private static const movies:Array = new Array(4);
		private static var _scale9Grid:Rectangle;
		private static var _TEXTFORMAT:TextFormat = new TextFormat("宋体",12,0xFFFFFF);
		private static var _FILTER:Array = [new GlowFilter(0x280000,1,2,2,4.5)];
//		private static const _xscaleTypes:Vector.<Number> = Vector.<Number>([1,1.2,1.5,1.9]);
		private static const _xscaleTypes:Array = [1,1.2,1.5,1.9];
		
		private static function getScale9Grid():Rectangle
		{
			if(_scale9Grid == null)
			{
				_scale9Grid = new Rectangle(15,8,2,2);
			}
			return _scale9Grid;
		}
		
		/**
		 * 0:原始长度，
		 * 1:1.2倍长度
		 * 2:1.5倍长度
		 * 3:1.9倍长度
		 */		
		private var _type:int;
		public function MCacheAsset1Btn(type:int,label:String = "")
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
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(BtnAsset1,2,49,26,1,xscale,1);
				if(xscale != 1)param.scale9Grid = getScale9Grid();
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				movies[_type] = f;
			}
			return f.getMovie() as DisplayObject;
		}
		
		override protected function overHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(2);
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(1);
		}
	}
}