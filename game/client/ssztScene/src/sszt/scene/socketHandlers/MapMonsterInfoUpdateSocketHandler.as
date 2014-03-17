package sszt.scene.socketHandlers
{
	import flash.geom.Point;
	
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	
	public class MapMonsterInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function MapMonsterInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_MONSTER_INFO_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var add:Boolean;
			var len:int = _data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				add = false;
				var id:int = _data.readInt();
				if(_data.readBoolean())
				{
					sceneModule.sceneInfo.monsterList.removeSceneMonster(id);
				}
				var monster:BaseSceneMonsterInfo = sceneModule.sceneInfo.monsterList.getMonster(id);
				var templateId:int = _data.readInt();
				if(monster == null)
				{
					monster = new BaseSceneMonsterInfo(new CharacterWalkActionII());
					monster.setObjId(id);
					monster.templateId = templateId;
					add = true;
				}
				var currentX:int = _data.readInt();
				var currentY:int = _data.readInt();
				monster.totalHp = _data.readInt();
				monster.currentHp = _data.readInt();
				monster.speed = _data.readByte() / 10;
				var pathLen:int = _data.readShort();
				if(pathLen > 0)
				{
					if(add)
					{
						monster.setScenePos(currentX,currentY);
						sceneModule.sceneInfo.monsterList.addSceneMonster(monster);
					}
					var path:Array = [];
					var lastX:int;
					var lastY:int;
					for(var j:int = 0; j < pathLen; j++)
					{
						lastX = _data.readShort();
						lastY = _data.readShort();
						path.push(new Point(lastX,lastY));
					}
					if(lastX != currentX || lastY != currentY)
						monster.setPath(path,null,0,false);
				}
				else
				{
					if(add)
					{
						monster.setScenePos(currentX,currentY);
						sceneModule.sceneInfo.monsterList.addSceneMonster(monster);
					}
					else 
						monster.setPath([new Point(monster.sceneX,monster.sceneY),new Point(currentX,currentY)]);
				}
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
	}
}