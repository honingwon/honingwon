package com.codeTooth.actionscript.components.controls
{
	import com.codeTooth.actionscript.components.controls.scrollBarClasses.ScrollBarBar;
	import com.codeTooth.actionscript.components.controls.scrollBarClasses.ScrollBarDownArrow;
	import com.codeTooth.actionscript.components.controls.scrollBarClasses.ScrollBarUpArrow;
	import com.codeTooth.actionscript.components.core.AbstractComponent;
	import com.codeTooth.actionscript.components.core.ComponentsApplication;
	import com.codeTooth.actionscript.components.events.ScrollBarEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 垂直滚动条
	 */	
	
	public class VScrollBar extends AbstractComponent
	{
		public function VScrollBar()
		{
			_width = 15;
			_height = 200;
			
			_upArrow = ComponentsApplication.getInstance().createComponent("scrollBarUpArrow");
			addChild(_upArrow);
			_upArrow.addEventListener(MouseEvent.MOUSE_DOWN, upArrowMouseDownHandler);
			
			_downArrow = ComponentsApplication.getInstance().createComponent("scrollBarDownArrow");
			addChild(_downArrow);
			_downArrow.addEventListener(MouseEvent.MOUSE_DOWN, downArrowMouseDownHandler);
			
			_scrollBarBar = ComponentsApplication.getInstance().createComponent("scrollBarBar");
			addChild(_scrollBarBar);
			_scrollBarBar.addEventListener(MouseEvent.MOUSE_DOWN, barMouseDownHandler);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  重写是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inherotDoc
		 */		
		override public function set enabled(bool:Boolean):void
		{
			if(_enabled != bool)
			{
				_enabled = bool;
				changeSkin();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inherotDoc
		 */
		override public function set width(width:Number):void
		{
			if(_width != width)
			{
				_width = width;
				resizeWidth();
				reposition();
			}
		}
		
		/**
		 * @inherotDoc
		 */
		override public function set height(height:Number):void
		{
			if(_height != height)
			{
				_height = height;
				resizeHeight();
				reposition();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  重新定位和调整尺寸
		//--------------------------------------------------------------------------------------------------------------------------
		
		private function reposition():void
		{
			_downArrow.y = _height - _downArrow.height;
			
			_scrollBarBar.y = _maxScrollPosition == _minScrollPosition ? 0 : 
																									 _upArrow.height + 
																									 (_height - _upArrow.height - _downArrow.height - _scrollBarBar.height) * 
																									 ((_scrollPosition - _minScrollPosition) / (_maxScrollPosition - _minScrollPosition));
		}
		
		private function resizeWidth():void
		{
			_trackEnabled.width = _width;
			_trackDisabled.width = _width;
			_downArrow.width = _width;
			_upArrow.width = _width;
			_scrollBarBar.width = _width;
		}
		
		private function resizeHeight():void
		{
			_trackEnabled.height = _height;
			_trackDisabled.height = _height;
			_scrollBarBar.height = int((_height - _upArrow.height - _downArrow.height) * (_pageHeight / _scrollHeight));
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 滚动速度
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 点击上下箭头按钮的滚动单位数
		private var _lineScrollSpeed:Number = 4;
		
		// 点击轨道的滚动单位数
		private var _pageScrollSpeed:Number = 10;
		
		// 记录当前使用的是那个滚动级别
		private var _currentScrollSpeed:Number;
	
		/**
		 * 点击上下箭头按钮的滚动单位数
		 */		
		public function get lineScrollSpeed():Number
		{
			return _lineScrollSpeed;
		}
		
		/**
		 * @private
		 */		
		public function set lineScrollSpeed(value:Number):void
		{
			_lineScrollSpeed = value;
		}
		
		/**
		 * 点击轨道的滚动单位数
		 */		
		public function get pageScrollSpeed():Number
		{
			return _pageScrollSpeed;
		}

		/**
		 * @private
		 */		
		public function set pageScrollSpeed(value:Number):void
		{
			_pageScrollSpeed = value;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 滚动
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 向上滚动箭头
		private var _upArrow:ScrollBarUpArrow;
		
		// 向下滚动箭头
		private var _downArrow:ScrollBarDownArrow;
		
		// 滚动方向
		private var _scrollDirection:int;
		
		// 临时存储舞台对象，以便侦听鼠标事件
		private var _stage:Stage;
		
		// 添加点击上下滚动按钮时的侦听
		private function addScrollListeners():void
		{
			if(stage != null)
			{
				_stage = stage;
				addEventListener(Event.ENTER_FRAME, scrollHandler);
				_stage.addEventListener(MouseEvent.MOUSE_UP, stopScrollHandler);
			}
		}
		
		private function upArrowMouseDownHandler(event:MouseEvent):void
		{
			_scrollDirection = -1;
			_currentScrollSpeed = _lineScrollSpeed;
			addScrollListeners();
		}
		
		private function downArrowMouseDownHandler(event:MouseEvent):void
		{
			_scrollDirection = 1;
			_currentScrollSpeed = _lineScrollSpeed;
			addScrollListeners();
		}
		
		private function scrollHandler(event:Event):void
		{
			_scrollPosition = Math.min(Math.max(_scrollPosition + _currentScrollSpeed * _scrollDirection, _minScrollPosition), _maxScrollPosition);
			reposition();
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.SCROLL, false, false, _scrollPosition));
		}
		
		private function stopScrollHandler(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, scrollHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrollHandler);
			_stage = null;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 滑块轨道
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _trackEnabled:DisplayObject;
		
		private var _trackDisabled:DisplayObject;
		
		private var _currentTrack:DisplayObject;
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 滚动参数
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 最小的滚动单位值
		private var _minScrollPosition:Number = 0;
		
		// 最大的滚动单位值
		private var _maxScrollPosition:Number = 100;
		
		// 当前的滚动单位值
		private var _scrollPosition:Number = 0;

		// 滚动区当前显示的单位高度
		private var _pageHeight:Number = 200;
		
		// 整个滚动页的高度
		private var _scrollHeight:Number = 200;
		
		/**
		 * 整个滚动页的高度
		 */		
		public function get scrollHeight():Number
		{
			return _scrollHeight;
		}
		
		/**
		 * @private
		 */		
		public function set scrollHeight(value:Number):void
		{
			if(_enabled)
			{
				if(value < _pageHeight)
				{
					value = _pageHeight;
				}
				
				if(_scrollHeight != value)
				{
					_scrollHeight = value;
					resizeHeight();
					reposition();
				}
			}
		}
		
		/**
		 * 滚动区当前显示的单位高度
		 */		
		public function get pageHeight():Number
		{
			return _pageHeight;
		}
		
		/**
		 * @private
		 */		
		public function set pageHeight(value:Number):void
		{	
			if(_enabled)
			{
				value = Math.min(Math.max(value, 0), _scrollHeight);
				
				if(_pageHeight != value)
				{
					_pageHeight = value;
					resizeHeight();
					reposition();
				}
			}
		}
		
		/**
		 * 最大的滚动单位值
		 */		
		public function get maxScrollPosition():Number
		{
			return _maxScrollPosition;
		}
		
		/**
		 * @private
		 */		
		public function set maxScrollPosition(value:Number):void
		{
			if(_enabled)
			{
				if(value < _minScrollPosition)
				{
					value = _minScrollPosition;
				}
				
				if(_maxScrollPosition != value)
				{
					_maxScrollPosition = value;
					
					if(_scrollPosition > _maxScrollPosition)
					{
						_scrollPosition = _maxScrollPosition;
					}
					
					reposition();
				}
			}
		}
		
		/**
		 * 最小的滚动单位值
		 */		
		public function get minScrollPosition():Number
		{
			return _minScrollPosition;
		}
		
		/**
		 * @private
		 */		 
		public function set minScrollPosition(value:Number):void
		{
			if(_enabled)
			{
				value = Math.min(Math.max(value, 0), _maxScrollPosition);
				
				if(_minScrollPosition != value)
				{
					_minScrollPosition = value;
					
					if(_scrollPosition < _minScrollPosition)
					{
						_scrollPosition = _minScrollPosition;
					}
					
					reposition();
				}
			}
		}
		
		/**
		 * 当前的滚动位置
		 */		
		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}
		
		/**
		 * @private
		 */		
		public function set scrollPosition(value:Number):void
		{
			if(_enabled)
			{
				value = Math.min(Math.max(value, _minScrollPosition), _maxScrollPosition);
				
				if(_scrollPosition != value)
				{
					_scrollPosition = value;
					reposition();
				}
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 滑块
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 滑块
		private var _scrollBarBar:ScrollBarBar;
		
		// 记录滑动时鼠标的零时点
		private var _dragMouseDy:Number;
		
		private function barMouseDownHandler(event:MouseEvent):void
		{
			if(stage != null)
			{
				_dragMouseDy = mouseY - _scrollBarBar.y;
				_stage = stage;
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, dragBarHandler);
				_stage.addEventListener(MouseEvent.MOUSE_UP, stopDragBarHandler);
			}
		}
		
		private function dragBarHandler(event:MouseEvent):void
		{
			var minY:Number = _upArrow.height;
			var maxY:Number = _height - _downArrow.height - _scrollBarBar.height;
			
			_scrollBarBar.y = Math.min(Math.max(mouseY - _dragMouseDy, minY), maxY);
			_scrollPosition =  _minScrollPosition + (maxY == minY ? 0 : 
																							 (_maxScrollPosition - _minScrollPosition) * ((_scrollBarBar.y - minY) / (maxY - minY)));
			
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.SCROLL, false, false, _scrollPosition));
		}
		
		private function stopDragBarHandler(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragBarHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragBarHandler);
			_stage = null;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写 ISkinable方法
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _skinNameTrackEnabled:String;
		
		private var _skinNameTrackDisabled:String;
		
		/**
		 * @inherotDoc
		 */		
		override public function updateSkin():void
		{	
			_trackEnabled = _skinsManager.createSkin(_skinNameTrackEnabled);
			_trackDisabled = _skinsManager.createSkin(_skinNameTrackDisabled);
			
			changeSkin();
			resizeWidth();
			resizeHeight();
			reposition();
		}
		
		private function changeSkin():void
		{
			var track:DisplayObject = _enabled ? _trackEnabled : _trackDisabled;
			
			if(_currentTrack != track)
			{
				if(_currentTrack != null)
				{
					removeChild(_currentTrack);
				}
				
				_currentTrack = track;
				addChildAt(_currentTrack, 0);
			}
			
			_upArrow.enabled = _enabled;
			_downArrow.enabled = _enabled;
			_scrollBarBar.enabled = _enabled;
		}

		/**
		 * @private
		 */
		public function get skinNameTrackDisabled():String
		{
			return _skinNameTrackDisabled;
		}

		/**
		 * @private
		 */
		public function set skinNameTrackDisabled(value:String):void
		{
			_skinNameTrackDisabled = value;
		}

		/**
		 * @private
		 */
		public function get skinNameTrackEnabled():String
		{
			return _skinNameTrackEnabled;
		}

		/**
		 * @private
		 */
		public function set skinNameTrackEnabled(value:String):void
		{
			_skinNameTrackEnabled = value;
		}
	}
}