package com.codeTooth.actionscript.interaction.dragDrop.core
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	/**
	 * 拽管理器
	 */	
	
	public class DragDropManager implements IDestroy
	{
		public function DragDropManager()
		{
			
		}
		
		//-------------------------------------------------------------------------------------------
		// 模拟
		//-------------------------------------------------------------------------------------------
		
		/**
		 * 模拟拖拽对象
		 * 
		 * @param dragInitiator
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 当前正在有一个拖拽
		 */		
		public function simulateDragInitiator(dragInitiator:Object):void
		{
			if(dragInitiator == null)
			{
				throw new NullPointerException("Null dragInitiator");
			}
			
			if(_dragInitiator != null)
			{
				throw new IllegalOperationException("Has had a draging");
			}
			
			checkContainer();
			
			this.dragInitiator(dragInitiator);
		}
		
		/**
		 * 模拟拖拽容器指定点下的对象
		 * 
		 * @param x
		 * @param y
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 当前正在有一个拖拽
		 */		
		public function simulateDragUnderPoint(x:Number, y:Number):void
		{
			if(_dragInitiator != null)
			{
				throw new IllegalOperationException("Has had a draging");
			}
			
			checkContainer();
			
			var targets:Array = _container.getObjectsUnderPoint(new Point(x, y));
			var numberTargets:int = targets.length;
			var target:Object = null;
			for(var i:int = numberTargets - 1; i >= 0; i--)
			{
				target = targets[i];
				if(target is IDragInitiator)
				{
					dragInitiator(target);
					break;
				}
				else
				{
					if(target is DisplayObjectContainer)
					{
						if(!target.mouseEnabled)
						{
							break;
						}
					}
				}
			}
		}
		
		/**
		 * 模拟释放到一个对象上
		 * 
		 * @param dropReceiver
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 当前没有正在的拖动
		 */		
		public function simulateDropReceiver(dropReceiver:Object):void
		{
			if(dropReceiver == null)
			{
				throw new NullPointerException("Null dropReceiver");
			}
			
			if(_dragInitiator == null)
			{
				throw new IllegalOperationException("Has not dragging object");
			}
			
			checkContainer();
			
			dropReceiver(dropReceiver);
			containerMouseUpHandler(null);
		}
		
		/**
		 * 模拟释放到一个指定点下的对象
		 * 
		 * @param x
		 * @param y
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 当前没有正在的拖动
		 */		
		public function simulateDropUnderPoint(x:Number, y:Number):void
		{
			if(_dragInitiator == null)
			{
				throw new IllegalOperationException("Has not dragging object");
			}
			
			checkContainer();
			
			var targets:Array = _container.getObjectsUnderPoint(new Point(x, y));
			var numberTargets:int = targets.length;
			var target:Object = null;
			for(var i:int = numberTargets - 1; i >= 0; i--)
			{
				target = targets[i];
				if(target is IDropReceiver)
				{
					dropReceiver(target);
					containerMouseUpHandler(null);
					break;
				}
				else
				{
					if(target is DisplayObjectContainer)
					{
						if(!target.mouseEnabled)
						{
							break;
						}
					}
				}
			}
		}
		
		/**
		 * 放弃当前正在进行的拖拽
		 */		
		public function giveUpDragging():void
		{
			if(_dragInitiator == null)
			{
				throw new IllegalOperationException("Has not dragging object");
			}
			
			_dropReceiver = null;
			containerMouseUpHandler(null);
		}
		
		//-------------------------------------------------------------------------------------------
		// 容器
		//-------------------------------------------------------------------------------------------
		
		//拖拽的容器
		private var _container:DisplayObjectContainer = null;
		
		/**
		 * 拖拽的容器
		 */		
		public function set container(container:DisplayObjectContainer):void
		{
			destroy();
			
			_grayFilter = [new ColorMatrixFilter([ .33, .33, .33, 0, 0,
																	.33, .33, .33, 0, 0,
																	.33, .33, .33, 0, 0,
																	0, 0, 0, 1, 0 ])];
			
			_container = container;
			checkContainer();
			addContainerListeners();
		}
		
		/**
		 * @private
		 */		
		public function get container():DisplayObjectContainer
		{
			if(!hasContainer())
			{
				throw new NoSuchObjectException("Has not container");
			}
			
			return _container;
		}
		
		/**
		 * 判断是否已经设置了拖拽容器
		 * 
		 * @return 
		 */		
		public function hasContainer():Boolean
		{
			return _container != null;
		}
		
		//检测是否设置了拖拽容器
		private function checkContainer():void
		{
			if(_container == null)
			{
				throw new NullPointerException("Null container");
			}
		}
		
		//添加容器侦听
		private function addContainerListeners():void
		{
			_container.addEventListener(MouseEvent.MOUSE_DOWN, containerMosueDownHandler);
		}
		
		//移除容器侦听
		private function removeContainerListeners():void
		{
			_container.removeEventListener(MouseEvent.MOUSE_DOWN, containerMosueDownHandler);
		}
		
		//添加拖拽容器侦听
		private function addContainerDragListeners():void
		{
			if(!_container.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				_container.addEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
			}
			if(!_container.hasEventListener(MouseEvent.MOUSE_UP))
			{
				_container.addEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
			}
		}
		
		//移除拖拽容器侦听
		private function removeContainerDragListeners():void
		{
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
			_container.removeEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
		}
		
		//-------------------------------------------------------------------------------------------
		// 拖拽动作
		//-------------------------------------------------------------------------------------------
		
		//发起者
		private var _dragInitiator:IDragInitiator = null;
		
		//接收者
		private var _dropReceiver:IDropReceiver = null;
		
		//数据
		private var _dragData:DragData = null;
		
		//图片滤镜
		private var _grayFilter:Array = null;
		
		//清楚拖拽时产生的引用
		private function clearReference():void
		{
			_dragInitiator = null;
			_dropReceiver = null;
			
			if(_dragData != null)
			{
				if(_container.contains(_dragData.image))
				{
					_container.removeChild(_dragData.image);
				}
				_dragData.image.filters = null;
				_dragData = null;
			}
		}
		
		//移动图片
		private function moveImage():void
		{
			_dragData.image.x = _container.mouseX + _dragData.offsetX;
			_dragData.image.y = _container.mouseY + _dragData.offsetY;
		}
		
		private function shineImage():void
		{
			if(_dragData.image.filters != null)
			{
				_dragData.image.filters = null;
			}
		}
		
		private function grayImage():void
		{
			if(_dragData.image.filters == null || _dragData.image.filters.length == 0)
			{
				_dragData.image.filters = _grayFilter;
			}
		}
		
		private function dragInitiator(dragInitiator:Object):void
		{
			if(dragInitiator is IDragInitiator && IDragInitiator(dragInitiator).dragEnabled)
			{
				_dragInitiator = IDragInitiator(dragInitiator);
				_dragData = _dragInitiator.dragData;
				addContainerDragListeners();
				removeContainerListeners();
				
				if(_dragData == null)
				{
					throw new NullPointerException("Null dragData");
				}
			}
		}
		
		private function dropReceiver(dropReceiver:Object):void
		{
			if(dropReceiver is IDropReceiver && IDropReceiver(dropReceiver).allowDrop(_dragData))
			{
				if(_dropReceiver == dropReceiver)
				{
					_dropReceiver.dropMouseOver(_dragData);
				}
				else
				{
					if(_dropReceiver != null)
					{
						_dropReceiver.dropMouseOut(_dragData);
					}
				}
				_dropReceiver = IDropReceiver(dropReceiver);
				shineImage();
			}
			else
			{
				if(_dropReceiver != null)
				{
					_dropReceiver.dropMouseOut(_dragData);
				}
				_dropReceiver = null;
				grayImage();
			}
		}
		
		private function containerMosueDownHandler(event:MouseEvent):void
		{
			var target:Object = event.target;
			
			while(!(target is IDragInitiator) && target != _container)
			{
				target = target.parent;
			}
			
			dragInitiator(target);
		}
		
		private function containerMouseMoveHandler(event:MouseEvent):void
		{
			var target:Object = event.target;
			
			while(!(target is IDropReceiver) && target != _container)
			{
				target = target.parent;
			}
			
			dropReceiver(target);
			
			_container.addChild(_dragData.image);
			moveImage();
		}
		
		private function containerMouseUpHandler(event:MouseEvent):void
		{
			if(_dropReceiver != null && _dropReceiver.allowDrop(_dragData))
			{
				_dropReceiver.dropMouseOut(_dragData);
				_dragInitiator.dragToReceiver(true, _dragData);
				_dropReceiver.setDropData(_dragData);
			}
			else
			{
				_dragInitiator.dragToReceiver(false, _dragData);
			}
			
			addContainerListeners();
			removeContainerDragListeners();
			clearReference();
		}
		
		//-------------------------------------------------------------------------------------------
		// 实现IDestroy接口
		//-------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			clearReference();
			
			if(_container != null)
			{
				removeContainerListeners();
				removeContainerDragListeners();
				_container = null;
			}
			
			_grayFilter = null;
		}
	}
}