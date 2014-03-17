package sszt.ui.mcache.btns.tabBtns
{
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.ui.UIManager;
	import sszt.ui.button.MTabButton;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import mhsm.ui.TabBtnAsset1;
	/**
	 * 此类已过期 
	 * @author lxb
	 * 
	 */	
	public class MCacheTab1Btn extends MTabButton
	{	
//		private static const _scale9Grids:Vector.<Rectangle> = Vector.<Rectangle>([
//			new Rectangle(15,10,7,3),new Rectangle(25,14,25,4)
//		]);
		private static const _scale9Grids:Array = [
			new Rectangle(15,10,7,3),new Rectangle(25,14,25,4)
		];
		private static const _xscales:Array = [[1,1.8,1.2],[1,1.3]];
//		private static const _movies:Array = [new Vector.<IBDMovieWrapperFactory>(3),new Vector.<IBDMovieWrapperFactory>(2)];
		private static const _movies:Array = [new Array(3),new Array(2)];
		
		/**
		 * item[SELECTED_TEXTFORMAT,UNSELECTED_TEXTFORMAT,SELECTED_FILTER,UNSELECTED_FILTER]
		 */		
		private static const _styles:Array = [
			[new TextFormat("宋体",12,0xb3e5db),new TextFormat("宋体",12,0xffffff),[new GlowFilter(0xFEFFDA,1,3,3,4.5)],[new GlowFilter(0x442B0B,1,3,3,4.5)]],
			[new TextFormat("宋体",12,0x46271E),new TextFormat("宋体",12,0xD9B580),[new GlowFilter(0xFEFFDA,1,3,3,4.5)],[new GlowFilter(0x442B0B,1,3,3,4.5)]]
		];
//		private static const _classes:Vector.<Class> = Vector.<Class>([TabBtnAsset1]);
		private static const _classes:Array = [TabBtnAsset1];
//		private static const _sizes:Vector.<Point> = Vector.<Point>([new Point(37,23)]);
		private static const _sizes:Array = [new Point(37,23)];
		
		private var _type:int;
		private var _xscaleType:int;
		
		public function MCacheTab1Btn(type:int,xscaleType:int,label:String = "")
		{
			_type = type;
			_xscaleType = xscaleType;
			if(_xscaleType < 0)xscaleType = 0;
			else if(_xscaleType > _xscales[_type].length - 1)_xscaleType = _xscales[_type].length - 1;
			super(null, label);
			selectedTextformat = _styles[_type][1];
			unselectedTextformat = _styles[_type][0];
			selectedFilter = _styles[_type][3];
			unselectedFilter = _styles[_type][4];
			updateStyle();
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = _movies[_type][_xscaleType];
			if(f == null)
			{
				var xscale:Number = _xscales[_type][_xscaleType];
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(_classes[_type],2,_sizes[_type].x,_sizes[_type].y,1,xscale);
				if(xscale != 0)param.scale9Grid = _scale9Grids[_type];
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				_movies[_type][_xscaleType] = f;
			}
			return f.getMovie() as DisplayObject;
		}
	}
}