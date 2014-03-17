package sszt.scene.data.dropItem
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import sszt.constData.CategoryType;
	import sszt.constData.SceneConfig;
	import sszt.core.utils.Declear;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	
	public class DropItemList extends EventDispatcher
	{
		public var list:Dictionary;
		private var _sceneInfo:SceneInfo;
		
		public function DropItemList(sceneInfo:SceneInfo)
		{
			_sceneInfo = sceneInfo;
			list = new Dictionary();
		}
		
		public function addItem(item:DropItemInfo):void
		{
			if(list[item.id] == null)
			{
				list[item.id] = item;
				dispatchEvent(new DropItemListUpdateEvent(DropItemListUpdateEvent.ADD_ITEM,item));
			}
		}
		
		public function removeItem(id:int):void
		{
			var t:DropItemInfo = list[id];
			if(t)
			{
				delete list[id];
				dispatchEvent(new DropItemListUpdateEvent(DropItemListUpdateEvent.REMOVE_ITEM,id));
				t.sceneRemove();
			}
		}
		public function removeItemAll():void
		{
		 	for each(var t:DropItemInfo in list)
			{
				if(t)
				{
					dispatchEvent(new DropItemListUpdateEvent(DropItemListUpdateEvent.REMOVE_ITEM,t.id));
					t.sceneRemove();
				}
			}
			list = new Dictionary();
		}
		
		public function getItem(id:int):DropItemInfo
		{
			return list[id];
		}
		
		public function removeOutBrostItem(gridX:int,gridY:int,maxGridX:int,maxGridY:int):void
		{
			var startX:int = Math.max(gridX - 1,0);
			var endX:int = Math.min(gridX + 1,maxGridX);
			var startY:int = Math.max(gridY - 1,0);
			var endY:int = Math.min(gridY + 1,maxGridY);
			for each(var i:DropItemInfo in list)
			{
				var tmpX:int = int(i.sceneX / SceneConfig.BROST_WIDTH);
				var tmpY:int = int(i.sceneY / SceneConfig.BROST_HEIGHT);
				if(tmpX < startX || tmpX > endX || tmpY < startY || tmpY > endY)
				{
					removeItem(i.getObjId());
				}
			}
		}
		
//		public function getAllCanPick():Vector.<DropItemInfo>
		public function getAllCanPick():Array
		{
//			var result:Vector.<DropItemInfo> = new Vector.<DropItemInfo>();
			var result:Array = [];
			for each(var i:DropItemInfo in list)
			{
				if(i.canPick(_sceneInfo.teamData.teamPlayers))
					result.push(i);
			}
			return result;
		}
		
		public function getOneCanPick():DropItemInfo
		{
			var dis:Number = 50000;
			var item:DropItemInfo;
			var self:SelfScenePlayerInfo = _sceneInfo.playerList.self;
			for each(var i:DropItemInfo in list)
			{
				if(i.canPick(_sceneInfo.teamData.teamPlayers))
				{
					var tmp:Number = i.getDistance(new Point(self.sceneX,self.sceneY));
					if(tmp < dis)
					{
						dis = tmp;
						item = i;
					}
				}
			}
			return item;
		}
//		public function getOneEquipCanPickByQuality(qualitys:Vector.<int>):DropItemInfo
		public function getOneEquipCanPickByQuality(qualitys:Array):DropItemInfo
		{
			var dis:Number = 50000;
			var item:DropItemInfo;
			var self:SelfScenePlayerInfo = _sceneInfo.playerList.self;
			for each(var i:DropItemInfo in list)
			{
				if(!CategoryType.isEquip(i.getCategory()) || qualitys.indexOf(i.getQuality()) == -1)continue;
				if(i.canPick(_sceneInfo.teamData.teamPlayers))
				{
					var tmp:Number = i.getDistance(new Point(self.sceneX,self.sceneY));
					if(tmp < dis)
					{
						dis = tmp;
						item = i;
					}
				}
			}
			return item;
		}
//		public function getOneOtherCanPickByQuality(qualitys:Vector.<int>):DropItemInfo
		public function getOneOtherCanPickByQuality(qualitys:Array):DropItemInfo
		{
			var dis:Number = 50000;
			var item:DropItemInfo;
			var self:SelfScenePlayerInfo = _sceneInfo.playerList.self;
			for each(var i:DropItemInfo in list)
			{
				if(CategoryType.isEquip(i.getCategory()) || qualitys.indexOf(i.getQuality()) == -1)continue;
				if(i.canPick(_sceneInfo.teamData.teamPlayers))
				{
					var tmp:Number = i.getDistance(new Point(self.sceneX,self.sceneY));
					if(tmp < dis)
					{
						dis = tmp;
						item = i;
					}
				}
			}
			return item;
		}
		
		public function setCanClientPickup(id:int,value:Boolean):void
		{
			var item:DropItemInfo = getItem(id);
			if(item)item.canClientPickup = value;
		}
		
		public function clear():void
		{
			for each(var i:DropItemInfo in list)
			{
				delete list[i.id];
			}
		}
	}
}