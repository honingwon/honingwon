package sszt.drag
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import mx.effects.IEffect;
	
	import sszt.constData.DragActionType;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.drag.*;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.pool.IPoolObj;
	import sszt.module.ModuleEventDispatcher;
	
	public class DragManager implements IDragManager 
	{
		
		private var _isDraging:Boolean;
		private var _dragable:IDragable;
		private var _proxy:Sprite;
		private var _proxyEnable:Boolean;
		private var _dragData:IDragData;
		private var _dragLayer:DisplayObjectContainer;
		
		public function acceptDrag():void
		{
			if (!_isDraging){
				return;
			}
			if (!_dragData){
				return;
			}
			if (!_dragData.dragSource){
				return;
			}
			try 
			{
				_dragData.dragSource.dragStop(_dragData);
			} 
			catch(e:Error) 
			{
				trace(e.message);
			}
			if (_dragable)
			{
				if ((_dragable as DisplayObject).stage)
				{
					(_dragable as DisplayObject).stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragableMoveHandler);
				}
				(_dragable as DisplayObject).removeEventListener(MouseEvent.MOUSE_UP, dragableUpHandler);
			}
			_isDraging = false;
			_dragData = null;
			_dragable = null;
			_proxy = null;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.DRAG_COMPLETE));
		}
		
		private function dragableUpHandler(evt:MouseEvent):void
		{
			if (_dragable && (_dragable as DisplayObject).stage){
				(_dragable as DisplayObject).stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragableMoveHandler);
				(_dragable as DisplayObject).removeEventListener(MouseEvent.MOUSE_UP, dragableUpHandler);
			}
			if (_dragData)
			{			
				_dragData.dragSource.dragStop(_dragData);
			}
		}
		
		private function removeFromStageHandler(evt:Event):void
		{
			_proxy.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			_proxy.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			if (_proxy.stage)
			{
				_proxy.stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			}
			Mouse.show();
			_dragData.action = DragActionType.NONE;
			acceptDrag();
		}
		private function dragableMoveHandler(evt:MouseEvent):void
		{
			if (_dragable && (_dragable as DisplayObject).stage){
				(_dragable as DisplayObject).stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragableMoveHandler);
				(_dragable as DisplayObject).removeEventListener(MouseEvent.MOUSE_UP, dragableUpHandler);
			}
			if (!_dragData){
				return;
			}
			var img:DisplayObject = _dragData.dragSource.getDragImage();
			if (!_isDraging && img){
				_isDraging = true;
				_proxy = new Sprite();
				img.x = -(img.width) >> 1;
				img.y = -(img.height) >> 1;
				_proxy.addChild(img);
				Mouse.hide();
				_proxy.mouseEnabled = true;
				_proxy.mouseChildren = false;
				_proxy.startDrag(true);
				_dragLayer.addChild(_proxy);
				_proxy.mouseEnabled = (_proxy.mouseChildren = _proxyEnable);
				_proxy.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
				_proxy.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
				_proxy.stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			}
		}
		
		public function setup(sp:DisplayObjectContainer):void
		{
			_dragLayer = sp;
		}
		
		public function startDrag(dragable:IDragable, proxyEnable:Boolean=false):Boolean
		{
			_proxyEnable = proxyEnable;
			_dragable = dragable;
			_dragData = new DragData(dragable, null, DragActionType.UNDRAG);
			(dragable as DisplayObject).stage.addEventListener(MouseEvent.MOUSE_MOVE, dragableMoveHandler);
			(dragable as DisplayObject).addEventListener(MouseEvent.MOUSE_UP, dragableUpHandler);
			return true;
		}
		
		private function checkIsEffect(ds:DisplayObject):Boolean
		{
			var i:IPoolObj = ds as IPoolObj;
			if(i)return true;
			return false;
		}
		
		private function stopDragHandler(evt:MouseEvent):void
		{
			var list:Array;
			var _stage:Stage;
			var ds:DisplayObject;
			var temp:DisplayObject;
			var flag:Boolean;
			var ad:IAcceptDrag;
			var evt:MouseEvent = evt;
			Mouse.show();
			_proxy.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			_proxy.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			if (_proxy.stage)
			{
				_proxy.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			}
			_dragData.action = DragActionType.NONE;
			try 
			{
				try 
				{
					list = _proxy.stage.getObjectsUnderPoint(new Point(evt.stageX, evt.stageY));
					_stage = _proxy.stage;
					list = list.reverse();
					for each (ds in list) 
					{
						if (!_proxy.contains(ds) && !checkIsEffect(ds)){
							temp = ds;
							flag = false;
							while (temp && temp != _stage) 
							{
								if (temp == _dragData.dragSource){
									_dragData.action = DragActionType.ONSELF;
									flag = true;
									break;
								}
								ad = (temp as IAcceptDrag);
								if (ad)
								{
									_dragData.dragTarget = ad;
									_dragData.action = ad.dragDrop(_dragData);
									flag = true;
									break;
								}
								temp = temp.parent;
							}
							if (flag){
								break;
							}
						}
					}
				}
				catch(e:Error) {
					trace(e.message);
				}
			} 
			finally 
			{
				if (_proxy)
				{
					if (_proxy)
					{
						_proxy.parent.removeChild(_proxy);
					}
				}
				Mouse.show();
			}
			acceptDrag();
			return;
		}
		
	}
}
