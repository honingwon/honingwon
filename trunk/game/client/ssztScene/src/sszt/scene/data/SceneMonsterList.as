package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SceneConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.components.sceneObjs.BaseSceneMonster;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	
	public class SceneMonsterList extends EventDispatcher implements ITick
	{
		private var _monsterList:Dictionary;
		private var _waitList:Array;
		private var _frameCount:int;
		
		public function SceneMonsterList()
		{
			_monsterList = new Dictionary();
			_waitList = [];
			_frameCount = 0;
		}
		
		public function getMonsters():Dictionary
		{
			return _monsterList;
		}
		
		public function getMonster(id:int):BaseSceneMonsterInfo
		{
			return _monsterList[id];
		}
		public function isAllDead():Boolean
		{
			for each(var t:BaseSceneMonsterInfo in _monsterList)
			{
				if(t && t.currentHp > 0 && t.template.type != 6)//%%石头类怪物不记录
				{
					return false;
				}
			}
			return true;
		}
		
		public function addSceneMonster(monster:BaseSceneMonsterInfo):void
		{
			_monsterList[monster.getObjId()] = monster;
			_waitList.push(monster);
//			dispatchEvent(new SceneMonsterListUpdateEvent(SceneMonsterListUpdateEvent.ADD_MONSTER,monster));
		}
		
		public function removeSceneMonster(id:int):void
		{
			var t:BaseSceneMonsterInfo = _monsterList[id];
			if(t)
			{
				delete _monsterList[id];
				var n:int = _waitList.indexOf(t);
				if(n > -1)
				{
					_waitList.splice(n,1);
				}
				dispatchEvent(new SceneMonsterListUpdateEvent(SceneMonsterListUpdateEvent.REMOVE_MONSTER,t));
				t.sceneRemove();
			}
		}
		
		public function removeSceneMonsterAll():void
		{
			for each(var t:BaseSceneMonsterInfo in _monsterList)
			{
				if(t)
				{
					var n:int = _waitList.indexOf(t);
					if(n > -1)
					{
						_waitList.splice(n,1);
					}
					dispatchEvent(new SceneMonsterListUpdateEvent(SceneMonsterListUpdateEvent.REMOVE_MONSTER,t));
					t.sceneRemove();
					
				}
			}
			_monsterList = new Dictionary();			
		}
		
		public function removeSceneMonsterByTemplateId(id:int):void
		{
			var list:Array;
			for each(var t:BaseSceneMonsterInfo in _monsterList)
			{
				if(t && t.templateId == id)
				{
					list.push(t.getObjId());
					var n:int = _waitList.indexOf(t);
					if(n > -1)
					{
						_waitList.splice(n,1);
					}
					dispatchEvent(new SceneMonsterListUpdateEvent(SceneMonsterListUpdateEvent.REMOVE_MONSTER,t));
					t.sceneRemove();
					
				}
			}
			for (var i:int = 0; i < list.length; ++i)
			{
				delete _monsterList[list[i]];
			}
		}
		public function removeOutBrostMonster(gridX:int,gridY:int,maxGridX:int,maxGridY:int):void
		{
			var startX:int = Math.max(gridX - 1,0);
			var endX:int = Math.min(gridX + 1,maxGridX);
			var startY:int = Math.max(gridY - 1,0);
			var endY:int = Math.min(gridY + 1,maxGridY);
			for each(var i:BaseSceneMonsterInfo in _monsterList)
			{
				var tmpX:int = int(i.sceneX / SceneConfig.BROST_WIDTH);
				var tmpY:int = int(i.sceneY / SceneConfig.BROST_HEIGHT);
				if(tmpX < startX || tmpX > endX || tmpY < startY || tmpY > endY)
				{
					removeSceneMonster(i.getObjId());
				}
			}
		}
		
		public function getNearlyMonsterByType(list:Array,targetPos:Point):BaseSceneMonsterInfo
		{
			var dis:Number = 1000000;
			var result:BaseSceneMonsterInfo;
			for each(var i:BaseSceneMonsterInfo in _monsterList)
			{
				if(i.getObjType() == MapElementType.OUR_TOWER ) continue;
				if(i.getCamp() == GlobalData.selfPlayer.camp) continue;
				if(list.indexOf(i.templateId) == -1)continue;
				var d:Number = i.getDistance(targetPos);
				if(d < dis)
				{
					dis = d;
					result = i;
				}
			}
			if(result)return result;
			return null;
		}
		public function getNearlyMonster(targetPos:Point):BaseSceneMonsterInfo
		{
			var dis:Number = 1000000;
			var result:BaseSceneMonsterInfo;
			for each(var i:BaseSceneMonsterInfo in _monsterList)
			{
				if(i.getObjType() == MapElementType.OUR_TOWER ) continue;
				if(i.getCamp() == GlobalData.selfPlayer.camp) continue;
				var d:Number = i.getDistance(targetPos);
				if(d < dis)
				{
					dis = d;
					result = i;
				}
			}
			if(result)return result;
			return null;
		}
		public function getGuarderNum():int
		{
			var num:int = 0;
			for each(var i:BaseSceneMonsterInfo in _monsterList)
			{
				if(i.template.type == MapElementType.OUR_TOWER)
					num ++;
			}
			return num;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_frameCount++;
			if(_frameCount == 2)
			{
				_frameCount = 0;
				if(_waitList.length > 0)
				{
					var t:BaseSceneMonsterInfo = _waitList.shift() as BaseSceneMonsterInfo;
					dispatchEvent(new SceneMonsterListUpdateEvent(SceneMonsterListUpdateEvent.ADD_MONSTER,t));
				}
			}
		}
		
		public function clear():void
		{
			for each(var i:BaseSceneMonsterInfo in _monsterList)
			{
				delete _monsterList[i.getObjId()];
			}
			_waitList.length = 0;
		}

		public function get waitList():Array
		{
			return _waitList;
		}

		public function set waitList(value:Array):void
		{
			_waitList = value;
		}

	}
}