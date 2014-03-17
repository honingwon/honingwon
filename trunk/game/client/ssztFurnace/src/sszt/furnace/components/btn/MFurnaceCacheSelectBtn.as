package sszt.furnace.components.btn
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import sszt.ui.UIManager;
	import sszt.ui.button.MSelectButton;
	
	import ssztui.furnace.LockBtnAsset;
	
	
	public class MFurnaceCacheSelectBtn extends MSelectButton
	{
		private static const _scale9Grids:Array = [
			new Rectangle(0,0,0,0)
		];
		private static const _xscales:Array = [[1]];
		private static const _movies:Array = [new Array(1)];
	
		private static const _classes:Array = [LockBtnAsset];
		private static const _sizes:Array = [new Point(18,18)];
		private var _type:int;
		private var _xscaleType:int;
		
		public function MFurnaceCacheSelectBtn(type:int,xscaleType:int)
		{
			_type = type;
			_xscaleType = xscaleType;
			if(_xscaleType < 0)_xscaleType = 0;
			else if(_xscaleType > (_xscales[type].length - 1))_xscaleType = _xscales[_type].length - 1;
			super(null,"",-1,-1,1,1,null,true);
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
