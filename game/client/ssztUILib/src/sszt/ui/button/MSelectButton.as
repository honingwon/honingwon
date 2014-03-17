/**
 * @author lxb
 *  2012-9-13 修改
 */
package sszt.ui.button
{
	import fl.core.InvalidationType;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.interfaces.ISelectable;
	
	public class MSelectButton extends MAssetButton implements ISelectable
	{
		public static const SELECTED_TEXTFORMAT:TextFormat = new TextFormat("SimSun",12,0xff0000);
		public static const UNSELECTED_TEXTFORMAT:TextFormat = new TextFormat("SimSun",12,0x00FF00);
		
		protected var _selected:Boolean;
		protected var _selectedTextFormat:TextFormat;
		protected var _unselectedTextFormat:TextFormat;
		protected var _selctedFilter:Array;
		protected var _unselectedFileter:Array;
		protected var _clickCancel:Boolean;
		
		/**
		 * 
		 * @param source
		 * @param label
		 * @param width
		 * @param height
		 * @param xscale
		 * @param yscale
		 * @param scale9Grid
		 * @param clickCancel 是否点击取消选中
		 * 
		 */		
		public function MSelectButton(source:Object,label:String = "",width:Number = -1, height:Number = -1,xscale:Number = 1,yscale:Number = 1,scale9Grid:Rectangle = null,clickCancel:Boolean = false)
		{
			super(source,label, width, height,xscale,yscale,scale9Grid);
			_selected = true;
			selected = false;
			_clickCancel = clickCancel;
			_selctedFilter = [];
			_unselectedFileter = [];
		}
		
		public function set selectedTextformat(value:TextFormat):void
		{
			_selectedTextFormat = value;
		}
		public function get selectedTextformat():TextFormat
		{
			if(_selectedTextFormat == null)return SELECTED_TEXTFORMAT;
			return _selectedTextFormat;
		}
		
		public function set unselectedTextformat(value:TextFormat):void
		{
			_unselectedTextFormat = value;
		}
		public function get unselectedTextformat():TextFormat
		{
			if(_unselectedTextFormat == null)return UNSELECTED_TEXTFORMAT;
			return _unselectedTextFormat;
		}
		
		public function set selectedFilter(value:Array):void
		{
			_selctedFilter = value;
		}
		public function get selectedFilter():Array
		{
			return _selctedFilter;
		}
		
		public function set unselectedFilter(value:Array):void
		{
			_unselectedFileter = value;
		}
		public function get unselectedFilter():Array
		{
			return _unselectedFileter;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			invalidate(InvalidationType.SELECTED);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.SELECTED))
			{
				drawSelected();
			}
			super.draw();
		}
		
		protected function drawSelected():void
		{
			updateStyle();
		}
		
		public function updateStyle():void
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
		
		protected function get assetWrap():IMovieWrapper
		{
			return _asset as IMovieWrapper;
		}
		
		protected function clickHandler(evt:MouseEvent):void
		{
			if(_clickCancel)
				selected = !selected;
			else selected = true;
		}
		
		override protected function initEvent():void
		{
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		
	}
}