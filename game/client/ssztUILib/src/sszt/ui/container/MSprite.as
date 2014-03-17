package sszt.ui.container
{
	import fl.core.InvalidationType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import sszt.interfaces.dispose.IDispose;

	public class MSprite extends Sprite implements IDispose
	{
		/**
		 * 防止回调里面调用callLater，造成死循环
		 */		
		public static var inCallLaterPhase:Boolean = false;
		
		private var _callLaterMethods:Dictionary;
		private var _invalidHash:Dictionary;
		
		private var _hasListenerEnterFrame:Boolean = false;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function MSprite()
		{
			super();
			_callLaterMethods = new Dictionary();
			_invalidHash = new Dictionary();
			configUI();
			invalidate(InvalidationType.ALL);
		}
		
		protected function configUI():void
		{
			tabEnabled = false;
		}
		
		public function drawNow():void
		{
			draw();
		}
		
		protected function draw():void
		{
			_invalidHash = new Dictionary();
		}
		
		public function invalidate(property:String = InvalidationType.ALL,callLater:Boolean = true):void
		{
			_invalidHash[property] = true;
			if(callLater)
				this.callLater(draw);
		}
		
		protected function isInvalid(property:String):Boolean
		{
			if(_invalidHash[property] || _invalidHash[InvalidationType.ALL])return true;
			return false;
		}
		
		protected function callLater(f:Function):void
		{
			if(inCallLaterPhase)return;
			_callLaterMethods[f] = true;
			if(stage != null)
			{
				if(!_hasListenerEnterFrame)
				{
					_hasListenerEnterFrame = true;
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
			}
		}
		
		private function callLaterDispatcher(evt:Event):void
		{
			if(evt.type == Event.ADDED_TO_STAGE)
			{
				removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
				if(!_hasListenerEnterFrame)
				{
					_hasListenerEnterFrame = true;
					addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
				}
				return;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME,callLaterDispatcher);
				_hasListenerEnterFrame = false;
				if(stage == null)
				{
					addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
				}
			}
			inCallLaterPhase = true;
			var methods:Dictionary = _callLaterMethods;
			for(var m:Object in methods)
			{
				m();
				delete(methods[m]);
			}
			inCallLaterPhase = false;
		}
		
//		override public function get width():Number{
//			return _width;
//		}
//		override public function set width(value:Number):void{
//			if (_width == value){
//				return;
//			}
//			setSize(value, height);
//		}
//		
//		override public function get height():Number{
//			return _height;
//		}
//		override public function set height(value:Number):void{
//			if (_height == value){
//				return;
//			}
//			setSize(width, value);
//		}
		
		public function setSize(width1:Number, height1:Number):void{
			if (width == width1 && height == height1){
				return;
			}
			width = width;
			height = height;
			invalidate(InvalidationType.SIZE);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
			removeEventListener(Event.ENTER_FRAME,callLaterDispatcher);
			if(parent)parent.removeChild(this);
		}
	}
}