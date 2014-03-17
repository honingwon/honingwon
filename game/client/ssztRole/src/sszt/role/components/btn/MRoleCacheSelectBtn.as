package sszt.role.components.btn
{
	import fl.core.InvalidationType;
	
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
	
	import ssztui.role.XueweiBtnAsset1;
	
	public class MRoleCacheSelectBtn extends MSelectButton
	{
		private static const _scale9Grids:Array = [
			new Rectangle(0,0,0,0)
		];
		private static const _xscales:Array = [[1]];
		private static const _movies:Array = [new Array(1)];
	
		private static const _classes:Array = [XueweiBtnAsset1];
		private static const _sizes:Array = [new Point(26,26)];
		private var _type:int;
		private var _xscaleType:int;
		
		private var _open:Boolean;
		
		public function MRoleCacheSelectBtn(type:int,xscaleType:int)
		{
			_type = type;
			_xscaleType = xscaleType;
			if(_xscaleType < 0)_xscaleType = 0;
			else if(_xscaleType > (_xscales[type].length - 1))_xscaleType = _xscales[_type].length - 1;
			super(null,"");
			_open = false;
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
		
		public function get open():Boolean
		{
			return _open;
		}
		public function set open(value:Boolean):void
		{
			if(_open == value)return;
			_open = value;
			invalidate(InvalidationType.SELECTED);
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
				if(!_open)
					assetWrap.gotoAndStop(4);
			}
			else
			{
				assetWrap.gotoAndStop(1);
				if(_label)
				{
					_label.setTextFormat(unselectedTextformat);
					_label.filters = unselectedFilter;
				}
				if(!_open)
					assetWrap.gotoAndStop(3);
			}
		}
		
	}
}
