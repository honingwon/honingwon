package sszt.ui.mcache.btns
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mhqy.ui.BtnAsset2;
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	/**
	 * 此类已过期 
	 * @author lxb
	 * 
	 */	
	public class MCacheAsset2Btn extends MAssetButton
	{
		private static const movies:Array = new Array(3);
		private static var _scale9Grid:Rectangle;
		private static var _TEXTFORMAT1:TextFormat = new TextFormat("宋体",12,0xffffff);
		private static var _TEXTFORMAT2:TextFormat = new TextFormat("宋体",12,0xF3FF4B);
		private static var _FILTER:Array = [new GlowFilter(0x3C4903,1,3,3,8)];
//		private static const _xscaleTypes:Vector.<Number> = Vector.<Number>([1,1.4,1.7]);
		private static const _xscaleTypes:Array = [1,1.4,1.7];
		
		private static function getScale9Grid():Rectangle
		{
			if(_scale9Grid == null)
			{
				_scale9Grid = new Rectangle(40,15,9,6);
			}
			return _scale9Grid;
		}
		
		private var _type:int;
		public function MCacheAsset2Btn(ScaleType:int,label:String = "",colorType:int = 1)
		{
			_labelYOffset = -1;
			_type = ScaleType;
			if(_type < 0)_type = 0;
			else if(_type > movies.length - 1)_type = movies.length - 1;
			super(null, label);
			switch(colorType)
			{
				case 1:
					labelField.setTextFormat(_TEXTFORMAT1);
					labelField.filters = _FILTER;
					break;
				case 2:
					labelField.setTextFormat(_TEXTFORMAT2);
					break;
			}
			
			labelField.defaultTextFormat = _TEXTFORMAT1;
			
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = movies[_type];
			if(f == null)
			{
				var xscale:Number = _xscaleTypes[_type];
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(BtnAsset2,1,89,36,1,xscale,1);
				if(_type != 0)param.scale9Grid = getScale9Grid();
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				movies[_type] = f;
			}
			return f.getMovie() as DisplayObject;
		}
	}
}