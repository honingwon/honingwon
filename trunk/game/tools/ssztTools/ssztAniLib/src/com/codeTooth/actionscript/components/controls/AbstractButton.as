package com.codeTooth.actionscript.components.controls
{
	import com.codeTooth.actionscript.components.controls.ButtonMode;
	import com.codeTooth.actionscript.components.core.AbstractComponent;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 在开关模式下状态变化事触发
	 * 
	 * @eventType flash.events.Event.CHANGE 
	 */
	[Event(name="change", type="flash.event.Event")]
	
	/**
	 * 抽象按钮，内置了按钮的基本行为
	 */	
	
	public class AbstractButton extends AbstractComponent
	{
		[Event(name="change", type="flash.events.Event")]
		
		public function AbstractButton()
		{
			_width = 100;
			_height = 22;
			addMouseListeners();
			mouseChildren = false;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */		
		override public function set enabled(bool:Boolean):void
		{
			if(_enabled != bool)
			{
				_enabled = bool;
				
				mouseEnabled = _enabled;
				
				changeSkin2();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 模式
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 按钮的模式
		protected var _mode:String = ButtonMode.BUTTON;
		
		/**
		 * 按钮模式还是开关模式
		 */		
		public function set mode(mode:String):void
		{
			if(_mode != mode)
			{
				_mode = mode;
				
				if(_mode != ButtonMode.BUTTON && _mode != ButtonMode.SWITCH)
				{
					throw new IllegalParameterException("Illegal button mode \"" + _mode + "\"");
				}
				
				changeSkin2();
			}
		}
		
		/**
		 * @private
		 */		
		public function get mode():String
		{
			return _mode;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 是否可选
		//--------------------------------------------------------------------------------------------------------------------------
		
		protected var _selected:Boolean = false;
		
		/**
		 * 是否处于选择状态，只有开关模式的按钮才能对此功能进行设置
		 */		
		public function set selected(bool:Boolean):void
		{
			if(_mode == ButtonMode.SWITCH && _selected != bool)
			{
				setSelectedInternal(bool);
			}
		}
		
		/**
		 * @private
		 */		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		internal function setSelectedInternal(bool:Boolean):void
		{
			_selected = bool;
			changeSkin2();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 鼠标事件
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 鼠标不在按钮上
		private static const MOUSE_STATE_OUT:int = 0;
		
		// 鼠标在按钮上
		private static const MOUSE_STATE_OVER:int = 1;
		
		// 鼠标在按钮上按下
		private static const MOUSE_STATE_DOWN:int = 2;
		
		// 当前鼠标的状态
		private var _currentMouseState:int = 0;
		
		// 判断是否进行了点击操作的计数器
		private var _click:int = 0;
		
		private function changeSkin(skin:DisplayObject):void
		{
			if(skin != _currentSkin)
			{
				if(_currentSkin != null)
				{
					removeChild(_currentSkin);
				}
				
				_currentSkin = skin;
				addChildAt(_currentSkin, 0);
			}
		}
		
		// 变换皮肤的逻辑判断
		private function changeSkin2():void
		{
			if(_enabled)
			{
				if(_mode == ButtonMode.SWITCH && _selected)
				{
					if(_currentMouseState == MOUSE_STATE_OUT)
					{
						changeSkin(_skinSelectedMouseOut);
					}
					else if(_currentMouseState == MOUSE_STATE_OVER)
					{
						changeSkin(_skinSelectedMouseOver);
					}
					else if(_currentMouseState == MOUSE_STATE_DOWN)
					{
						changeSkin(_skinSelectedMouseDown);
					}
				}
				else
				{
					if(_currentMouseState == MOUSE_STATE_OUT)
					{
						changeSkin(_skinMouseOut);
					}
					else if(_currentMouseState == MOUSE_STATE_OVER)
					{
						changeSkin(_skinMouseOver);
					}
					else if(_currentMouseState == MOUSE_STATE_DOWN)
					{
						changeSkin(_skinMouseDown);
					}
				}
			}
			else
			{
				if(_mode == ButtonMode.SWITCH && _selected)
				{
					changeSkin(_skinSelectedDisabled);
				}
				else
				{
					changeSkin(_skinDisabled);
				}
			}
		}
		
		private function addMouseListeners():void
		{
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler); 
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler); 
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler); 
		}
		
		private function removeMouseListeners():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler); 
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler); 
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler); 
		}
		
		// 鼠标滑过触发
		private function rollOverHandler(event:MouseEvent):void
		{
			_currentMouseState = MOUSE_STATE_OVER;
			changeSkin2();
			_click--;
		}
		
		// 鼠标划出触发
		private function rollOutHandler(event:MouseEvent):void
		{
			_currentMouseState = MOUSE_STATE_OUT;
			changeSkin2();
			_click++;
		}
		
		// 鼠标按下触发
		private function mouseDownHandler(event:MouseEvent):void
		{
			_currentMouseState = MOUSE_STATE_DOWN;
			
			changeSkin2();
			
			_click = 1;
		}
		
		// 鼠标释放触发
		private function mouseUpHandler(event:MouseEvent):void
		{
			clickExecute();
		}
		
		protected function clickExecute():void
		{
			if(_click ==1)
			{
				if(_mode == ButtonMode.SWITCH)
				{
					_selected = !_selected;
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			
			rollOverHandler(null);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */		
		override public function set width(width:Number):void
		{
			_width = width;
			
			_skinMouseOut.width = _width;
			_skinMouseOver.width = _width;
			_skinMouseDown.width = _width;
			_skinDisabled.width = _width;
			
			if(_skinSelectedMouseOut != null)
			{
				_skinSelectedMouseOut.width = _width;
			}
			if(_skinSelectedMouseOver != null)
			{
				_skinSelectedMouseOver.width = _width;
			}
			if(_skinSelectedMouseDown != null)
			{
				_skinSelectedMouseDown.width = _width;
			}
			if(_skinSelectedDisabled != null)
			{
				_skinSelectedDisabled.width = _width;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(height:Number):void
		{
			_height = height;
			
			_skinMouseOut.height = _height;
			_skinMouseOver.height = _height;
			_skinMouseDown.height = _height;
			_skinDisabled.height = _height;
			
			if(_skinSelectedMouseOut != null)
			{
				_skinSelectedMouseOut.height = _height;
			}
			if(_skinSelectedMouseOver != null)
			{
				_skinSelectedMouseOver.height = _height;
			}
			if(_skinSelectedMouseDown != null)
			{
				_skinSelectedMouseDown.height = _height;
			}
			if(_skinSelectedDisabled != null)
			{
				_skinSelectedDisabled.height = _height;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写 ISkinable 接口
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _skinNameMouseOut:String;
		
		private var _skinNameMouseOver:String;
		
		private var _skinNameMouseDown:String;
		
		private var _skinNameDisabled:String;
		
		private var _skinNameSelectedMouseOut:String;
		
		private var _skinNameSelectedMouseOver:String;
		
		private var _skinNameSelectedMouseDown:String;
		
		private var _skinNameSelecedDisabled:String;
		
		private var _skinMouseOut:DisplayObject;
		
		private var _skinMouseOver:DisplayObject;
		
		private var _skinMouseDown:DisplayObject;
		
		private var _skinDisabled:DisplayObject;
		
		private var _skinSelectedMouseOut:DisplayObject;
		
		private var _skinSelectedMouseOver:DisplayObject;
		
		private var _skinSelectedMouseDown:DisplayObject;
		
		private var _skinSelectedDisabled:DisplayObject;
		
		private var _currentSkin:DisplayObject;
		
		/**
		 * @inheritDoc
		 */
		override public function updateSkin():void
		{
			_skinMouseOut = _skinsManager.createSkin(_skinNameMouseOut);
			_skinMouseOver = _skinsManager.createSkin(_skinNameMouseOver);
			_skinMouseDown = _skinsManager.createSkin(_skinNameMouseDown);
			_skinDisabled = _skinsManager.createSkin(_skinNameDisabled);
			
			if(_skinsManager.hasSkin(_skinNameSelectedMouseOut))
			{
				_skinSelectedMouseOut = _skinsManager.createSkin(_skinNameSelectedMouseOut);
			}
			if(_skinsManager.hasSkin(_skinNameSelectedMouseOver))
			{
				_skinSelectedMouseOver = _skinsManager.createSkin(_skinNameSelectedMouseOver);
			}
			if(_skinsManager.hasSkin(_skinNameSelectedMouseDown))
			{
				_skinSelectedMouseDown = _skinsManager.createSkin(_skinNameSelectedMouseDown);
			}
			if(_skinsManager.hasSkin(_skinNameSelecedDisabled))
			{
				_skinSelectedDisabled = _skinsManager.createSkin(_skinNameSelecedDisabled);
			}
			
			width = _width;
			height = _height;
			
			changeSkin2();
		}

		/**
		 * @private
		 */
		public function get skinNameMouseOut():String
		{
			return _skinNameMouseOut;
		}

		/**
		 * @private
		 */
		public function set skinNameMouseOut(value:String):void
		{
			_skinNameMouseOut = value;
		}

		/**
		 * @private
		 */
		public function get skinNameMouseOver():String
		{
			return _skinNameMouseOver;
		}

		/**
		 * @private
		 */
		public function set skinNameMouseOver(value:String):void
		{
			_skinNameMouseOver = value;
		}

		/**
		 * @private
		 */
		public function get skinNameMouseDown():String
		{
			return _skinNameMouseDown;
		}

		/**
		 * @private
		 */
		public function set skinNameMouseDown(value:String):void
		{
			_skinNameMouseDown = value;
		}

		/**
		 * @private
		 */
		public function get skinNameDisabled():String
		{
			return _skinNameDisabled;
		}

		/**
		 * @private
		 */
		public function set skinNameDisabled(value:String):void
		{
			_skinNameDisabled = value;
		}

		/**
		 * @private
		 */
		public function get skinNameSelectedMouseOut():String
		{
			return _skinNameSelectedMouseOut;
		}

		/**
		 * @private
		 */
		public function set skinNameSelectedMouseOut(value:String):void
		{
			_skinNameSelectedMouseOut = value;
		}

		/**
		 * @private
		 */
		public function get skinNameSelectedMouseOver():String
		{
			return _skinNameSelectedMouseOver;
		}

		/**
		 * @private
		 */
		public function set skinNameSelectedMouseOver(value:String):void
		{
			_skinNameSelectedMouseOver = value;
		}
	
		/**
		 * @private
		 */
		public function get skinNameSelectedMouseDown():String
		{
			return _skinNameSelectedMouseDown;
		}

		/**
		 * @private
		 */
		public function set skinNameSelectedMouseDown(value:String):void
		{
			_skinNameSelectedMouseDown = value;
		}

		/**
		 * @private
		 */
		public function get skinNameSelecedDisabled():String
		{
			return _skinNameSelecedDisabled;
		}
		
		/**
		 * @private
		 */
		public function set skinNameSelecedDisabled(value:String):void
		{
			_skinNameSelecedDisabled = value;
		}
	}
}