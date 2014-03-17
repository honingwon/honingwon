package sszt.ui.mcache.btns.selectBtns
{
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mhqy.ui.SelectBtnAsset1;
	import mhqy.ui.SelectBtnAsset2;
	import sszt.ui.UIManager;
	import sszt.ui.button.MSelectButton;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	/**
	 * 此类已过期 
	 * @author lxb
	 * 
	 */	
	public class MCacheSelectBtn extends MSelectButton
	{
//		private static const _scale9Grids:Vector.<Rectangle> = Vector.<Rectangle>([
//			new Rectangle(10,12,20,2),new Rectangle(30,12,30,2)
//		]);
		private static const _scale9Grids:Array = [
			new Rectangle(10,12,20,2),new Rectangle(30,12,30,2)
		];
		private static const _xscales:Array = [[1,1.2,1.6,2],[1,1.5,1.9]];
		private static const _movies:Array = [new Array(2),new Array(3)];
		
		/**
		 * SELECT_TEXTFORMAT,UNSELECT_TEXTFORMAT,SELECT_FILTER,UNSELECT_FILTER
		 */		
		private static const _styles:Array = [
			[new TextFormat("宋体",12,0xFFFFFF),new TextFormat("宋体",12,0xF7EEA0),[new GlowFilter(0x336666,1,2,2,4)],[new GlowFilter(0x384A40,1,2,2,4)]],
			[new TextFormat("宋体",14,0x660000),new TextFormat("宋体",14,0xFEE17E),[new GlowFilter(0xFFFFC0,1,2,2,8)],[new GlowFilter(0x512315,1,2,2,8)]],
			[new TextFormat("宋体",14,0x660000),new TextFormat("宋体",14,0xFEE17E),[new GlowFilter(0xFFFFC0,1,2,2,8)],[new GlowFilter(0x512315,1,2,2,8)]],
			[new TextFormat("宋体",14,0x660000),new TextFormat("宋体",14,0xFEE17E),[new GlowFilter(0xFFFFC0,1,2,2,8)],[new GlowFilter(0x512315,1,2,2,8)]]
		];
//		private static const _classes:Vector.<Class> = Vector.<Class>([SelectBtnAsset1,SelectBtnAsset2]);
		private static const _classes:Array = [SelectBtnAsset1,SelectBtnAsset2];
//		private static const _sizes:Vector.<Point> = Vector.<Point>([new Point(33,19),new Point(30,17)]);
		private static const _sizes:Array = [new Point(33,19),new Point(30,17)];
		
		private var _type:int;
		private var _xscaleType:int;
		
		public function MCacheSelectBtn(type:int,xscaleType:int,label:String = "")
		{
			_type = type;
			_xscaleType = xscaleType;
			if(_xscaleType < 0)_xscaleType = 0;
			else if(_xscaleType > (_xscales[type].length - 1))_xscaleType = _xscales[_type].length - 1;
			super(null,label);
			selectedTextformat = _styles[_type][0];
			unselectedTextformat = _styles[_type][1];
			selectedFilter = _styles[_type][2];
			unselectedFilter = _styles[_type][3];
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = _movies[_type][_xscaleType];
			if(f == null)
			{
				var xscale:Number = _xscales[_type][_xscaleType];
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(_classes[_type],2,_sizes[_type].x,_sizes[_type].y,1,xscale,1);
				if(xscale != 1)param.scale9Grid = _scale9Grids[_type];
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				_movies[_type][_xscaleType] = f;
			}
			return f.getMovie() as DisplayObject;
		}
		
		override protected function createLabel(str:String):TextField
		{
//			_labelYOffset = 2;
			return super.createLabel(str);
		}
	}
}
