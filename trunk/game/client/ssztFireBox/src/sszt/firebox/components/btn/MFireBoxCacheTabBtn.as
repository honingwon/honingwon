package sszt.firebox.components.btn
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
		
		import ssztui.furnace.TabBtnAsset1;
		import ssztui.ui.TabBtnAsset2;
		
		public class MFireBoxCacheTabBtn extends MTabButton
		{
			private static const _scale9Grids:Array = [
				new Rectangle(10,12,27,6)
			];
			private static const _xscales:Array = [[1,1.2,1.46],[1]];
			private static const _movies:Array = [new Array(3),new Array(1)];
			
			private static const _styles:Array = [
				[new TextFormat("宋体",12,0x777467),new TextFormat("宋体",14,0xFFFFFF),[new GlowFilter(0x000000,1,2,2,4)],[new GlowFilter(0x000000,1,2,2,4)]],
				[new TextFormat("宋体",12,0x777467),new TextFormat("宋体",14,0xFFFFFF),[new GlowFilter(0x000000,1,2,2,4)],[new GlowFilter(0x000000,1,2,2,4)]]
			];
			private static const _classes:Array = [TabBtnAsset1,TabBtnAsset2];
			private static const _sizes:Array = [new Point(28,73),new Point(39,20)];
			
			private var _type:int;
			private var _xscaleType:int;
			
			public function MFireBoxCacheTabBtn(type:int,xscaleType:int,label:String = "")
			{
				_type = type;
				_xscaleType = xscaleType;
				if(_xscaleType < 0)_xscaleType = 0;
				else if(_xscaleType > _xscales[_type].length - 1)_xscaleType = _xscales[_type].length - 1;
//				this._label.width = 20;
				super(null, label, 30);
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
			
			override protected function createLabel(str:String):TextField
			{
				//			_labelYOffset = 2;
				return super.createLabel(str);
			}
			
			
			override public function updateStyle():void
			{
				if(_selected)
				{
					assetWrap.gotoAndStop(4);
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