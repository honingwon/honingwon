package sszt.ui.mcache.btns.selectBtns
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import sszt.ui.UIManager;
	import sszt.ui.button.MSelectButton;
	
	import ssztui.ui.SelectBtnSkin1;
	
	public class MCacheSelectBtn1 extends MSelectButton
	{
		
		private static const _scale9Grids:Array = [
			new Rectangle(0,0,0,0)
		];
		private static const _xscales:Array = [[1]];
		private static const _movies:Array = [new Array(1)];
	
		private static const _styles:Array = [
			[new TextFormat("SimSun",12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER),new TextFormat("SimSun",12,0x9c977f,null,null,null,null,null,TextFormatAlign.CENTER),[new GlowFilter(0x000000,1,2,2,4)],[new GlowFilter(0x000000,1,2,2,4)]]
			
		];
		private static const _classes:Array = [SelectBtnSkin1];
		private static const _sizes:Array = [new Point(26,22)];
		
		private var _type:int;
		private var _xscaleType:int;
		
		public function MCacheSelectBtn1(type:int,xscaleType:int,label:String = "")
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
			return super.createLabel(str);
		}
		
		
		override public function updateStyle():void
		{
			if(_selected)
			{
				assetWrap.gotoAndStop(2);
				if(_label)
				{
					_label.setTextFormat(selectedTextformat);
					_label.filters = selectedFilter;
				}
			}
			else
			{
				assetWrap.gotoAndStop(1);
				if(_label)
				{
					_label.setTextFormat(unselectedTextformat);
					_label.filters = unselectedFilter;
				}
			}
		}
	
		
	}
}
