/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-13 上午11:16:52 
 * 
 */ 
package sszt.ui.mcache.btns.tabBtns
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
	import sszt.ui.button.MTabButton;
	
	import ssztui.ui.TabBtnAsset1;
	import ssztui.ui.TabBtnAsset2;
	import ssztui.ui.TabBtnAsset3;

	public class MCacheTabBtn1 extends MTabButton
	{
		private static const _scale9Grids:Array = [
			new Rectangle(5,8,37,10),
			new Rectangle(8,6,24,10),
			new Rectangle(20,10,74,10)
		];
		private static const _xscales:Array = [[1,1.2,1.46,1.8],[1,1.65,2,0.5],[1,1,0.7]];
		private static const _movies:Array = [new Array(3),new Array(3),new Array(3)];
		
		private static const _styles:Array = [
			[new TextFormat("SimSun",12,0x7ecad0),new TextFormat("SimSun",12,0xFFFCCC),[new GlowFilter(0x000000,1,2,2,4)],[new GlowFilter(0x000000,1,2,2,4)]],
			[new TextFormat("SimSun",12,0xfffccc),new TextFormat("SimSun",12,0xffcc00),[new GlowFilter(0x0c1213,1,2,2,8)],[new GlowFilter(0x002a32,1,2,2,8)]],
			[new TextFormat("SimSun",12,0xdccda0),new TextFormat("SimSun",12,0xfffccc),[new GlowFilter(0x4b3910,1,2,2,8)],[new GlowFilter(0x4b3910,1,2,2,8)]]
		];
		private static const _classes:Array = [TabBtnAsset1,TabBtnAsset2,TabBtnAsset3];
		private static const _sizes:Array = [new Point(47,26),new Point(40,22),new Point(114,30)];
		
		private var _type:int;
		private var _xscaleType:int;
		
		public function MCacheTabBtn1(type:int,xscaleType:int,label:String = "")
		{
			_type = type;
			_xscaleType = xscaleType;
			if(_xscaleType < 0)
				_xscaleType = 0;
			else if(_xscaleType > _xscales[_type].length - 1)
				_xscaleType = _xscales[_type].length - 1;
			super(null, label);
			selectedTextformat = _styles[_type][1];
			unselectedTextformat = _styles[_type][0];
			selectedFilter = _styles[_type][3];
			unselectedFilter = _styles[_type][3];
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
		
		override protected function createLabel(str:String):TextField
		{
			if(_type ==1)
				_labelYOffset = 2;
			else
				_labelYOffset = 3;
			return super.createLabel(str);
		}
		
		
		override public function updateStyle():void
		{
			if(_selected)
			{
				assetWrap.gotoAndStop(4);
				if(_label)
				{
					if(_type == 0) _label.y = _labelY;
					_label.setTextFormat(selectedTextformat);
					_label.filters = selectedFilter;
				}
			}
			else
			{
				assetWrap.gotoAndStop(1);
				if(_label)
				{
					if(_type == 0) _label.y = _labelY + 1;
					_label.setTextFormat(unselectedTextformat);
					_label.filters = unselectedFilter;
				}
			}
		}
		
		
		override protected function overHandler(evt:MouseEvent):void
		{
			if(selected) return;
			(_asset as IMovieWrapper).gotoAndStop(2);
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			if(selected) return;
			(_asset as IMovieWrapper).gotoAndStop(1);
		}
		override protected function downHandler(evt:MouseEvent):void
		{
			if(selected) return;
			(_asset as IMovieWrapper).gotoAndStop(3);
		}
		
		override protected function upHandler(evt:MouseEvent):void
		{
			if(selected) return;
			(_asset as IMovieWrapper).gotoAndStop(2);
		}
		
		
		
		
	}
}