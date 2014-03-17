package sszt.scene.data.collects
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import sszt.constData.SceneConfig;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.components.sceneObjs.BaseSceneCollect;
	import sszt.scene.mediators.SceneMediator;
	
	public class CollectItemList extends EventDispatcher implements ITick
	{
		public var list:Dictionary;
		private var _waitList:Array;
		private var _frameCount:int;
		
		public function CollectItemList()
		{
			list = new Dictionary();
			_waitList = [];
			_frameCount = 0;
		}
		
		public function addItem(item:CollectItemInfo):void
		{
			if(list[item.id] == null)
			{
				list[item.id] = item;
				_waitList.push(item);
//				dispatchEvent(new CollectItemListUpdateEvent(CollectItemListUpdateEvent.ADD_ITEM,item));
			}
		}
		
		public function removeItem(id:int,playerEffect:Boolean = false):void
		{
			var t:CollectItemInfo = list[id];
			if(t)
			{
				delete list[id];
				var n:int = _waitList.indexOf(t);
				if(n > -1)
				{
					_waitList.splice(n,1);
				}
				dispatchEvent(new CollectItemListUpdateEvent(CollectItemListUpdateEvent.REMOVE_ITEM,id,playerEffect,t.sceneX,t.sceneY));
				t.sceneRemove();
			}
		}
		
		public function getItem(id:int):CollectItemInfo
		{
			return list[id];
		}
		
		public function getNearlyItemByTemplateId(templateId:int,targetPoint:Point):CollectItemInfo
		{
			var dis:Number = 100000;
			var item:CollectItemInfo = null;
			for each(var i:CollectItemInfo in list)
			{
				if(i)
				{
					var n:Number = i.getDistance(targetPoint);
					if(n < dis && i.templateId == templateId)
					{
						dis = n;
						item = i;
					}
				}
			}
			return item;
		}
		
		public function removeOutBrostItem(gridX:int,gridY:int,maxGridX:int,maxGridY:int):void
		{
			var startX:int = Math.max(gridX - 1,0);
			var endX:int = Math.min(gridX + 1,maxGridX);
			var startY:int = Math.max(gridY - 1,0);
			var endY:int = Math.min(gridY + 1,maxGridY);
			for each(var i:CollectItemInfo in list)
			{
				var tmpX:int = int(i.sceneX / SceneConfig.BROST_WIDTH);
				var tmpY:int = int(i.sceneY / SceneConfig.BROST_HEIGHT);
				if(tmpX < startX || tmpX > endX || tmpY < startY || tmpY > endY)
				{
					removeItem(i.getObjId());
				}
			}
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_frameCount ++;
			if(_frameCount == 2)
			{
				_frameCount = 0;
				if(_waitList.length > 0)
				{
					var collect:CollectItemInfo = _waitList.shift() as CollectItemInfo;
					dispatchEvent(new CollectItemListUpdateEvent(CollectItemListUpdateEvent.ADD_ITEM,collect));
				}
			}
		}
		
		public function clear():void
		{
			for each(var i:CollectItemInfo in list)
			{
				delete list[i.id];
			}
			_waitList.length = 0;
		}
	}
}