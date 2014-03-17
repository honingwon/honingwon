/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-8 下午1:45:47 
 * 
 */ 
package sszt.scene.checks
{
	import flash.geom.Point;
	
	import mx.events.CloseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.collect.CollectTemplateInfo;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.MapSearch;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.collects.CollectItemInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerInviteSitRelaySocketHandler;
	import sszt.scene.socketHandlers.PlayerMoveSocketHandler;
	import sszt.scene.socketHandlers.PlayerSetHouseSocketHandler;
	import sszt.scene.utils.AStarIII;
	import sszt.scene.utils.ClickEffect;
	import sszt.ui.container.MAlert;

	public class WalkChecker
	{
		
		private static var _mediator:SceneMediator;
		private static var _sceneInfo:SceneInfo;
		private static var _pathFinder:AStarIII;
		private static var _doorId:int;
		
		
		public function WalkChecker()
		{
		}
		
		public static function setup(mediator:SceneMediator) : void
		{
			_mediator = mediator;
			_sceneInfo = _mediator.sceneInfo;
			_pathFinder = _mediator.sceneModule.sceneInit.getMapController().getPathFinder();
		}
		
		
		public static function doWalk(sceneId:int, 
									  targetP:Point, 
									  callBack:Function = null, 
									  stopAtDistance:Number = 0, 
									  clearHangupState:Boolean = true, 
									  showClickEffect:Boolean = false, 
									  clearSpanMapState:Boolean = true, 
									  clearCollectState:Boolean = true, 
									  clearFollowState:Boolean = true) : void
		{
			var walk:Function = function () : void
			{
				if(clearHangupState)
				{
					_mediator.sceneInfo.playerList.self.clearHangup();
				}
				if(clearCollectState)
					_mediator.sceneInfo.playerList.self.stopCollecting();
				if(self.info.isSit())
				{
					_mediator.selfSit(false);
				}
				if(clearFollowState)
					self.setFollower(null);
				var path:Array;
				var tmpCallback:Function = callBack;
				var isUpHouse:Boolean = false;
				var selfPoint:Point = new Point(self.sceneX,self.sceneY);
				if(sceneId != _mediator.sceneInfo.getSceneId())
				{
					var doorPath:Array = MapSearch.find(_mediator.sceneInfo.getSceneId(),sceneId);
					if(doorPath == null || doorPath.length == 0)return;
					if(doorPath != null)GlobalData.selfPlayer.scenePath = doorPath.slice(0);
					GlobalData.selfPlayer.scenePathTarget = targetP;
					GlobalData.selfPlayer.scenePathCallback = callBack;
					GlobalData.selfPlayer.scenePathStopAtDistance = stopAtDistance;
					var door:DoorTemplateInfo = DoorTemplateList.getDoorTemplate(doorPath[0]);
					_doorId = door.templateId;
					if(_mediator.sceneInfo.mapInfo.isSpaScene())
						path = _pathFinder.findpath(selfPoint,new Point(door.sceneX,door.sceneY),2500);
					else path = _pathFinder.findpath(selfPoint,new Point(door.sceneX,door.sceneY));
					tmpCallback = doChangeScene;
					isUpHouse = true;
				}
				else
				{
					//不同场景不需要清除回调
					if(clearSpanMapState)
					{
						GlobalData.selfPlayer.scenePath = null;
						GlobalData.selfPlayer.scenePathTarget = null;
						GlobalData.selfPlayer.scenePathCallback = null;
					}
					if(targetP == null)
					{
						path = [];
						_mediator.sceneInfo.playerList.self.state.setFindPath(false);
						if(tmpCallback != null)
						{
							tmpCallback();
						}
					}
					else if(Point.distance(selfPoint,targetP) < 2)
					{
						path = [];
						_mediator.sceneInfo.playerList.self.state.setFindPath(false);
						if(tmpCallback != null)
						{
							tmpCallback();
						}
					}
					else
					{
						if(_mediator.sceneInfo.mapInfo.isSpaScene())
							path = _pathFinder.findpath(selfPoint,targetP,stopAtDistance,2500);
						else path = _pathFinder.findpath(selfPoint,targetP,stopAtDistance);
					}
				}
				if(path && path.length > 0)
				{
					//距离短只调回调，否则走路
					if(Point.distance(path[path.length - 1],selfPoint) < 2)
					{
						_mediator.sceneInfo.playerList.self.state.setFindPath(false);
						if(tmpCallback != null)
						{
							tmpCallback();
						}
					}
					else
					{
						if(targetP != null && Point.distance(selfPoint,targetP) >= CommonConfig.SETHOUSE_DISTANCE)
						{
							isUpHouse = true;
						}
						var scenePath:Array = _mediator.sceneInfo.playerList.self.path;
						if(scenePath == null)PlayerMoveSocketHandler.send(path);
						else if(scenePath.length > 0)
						{
							if(scenePath[scenePath.length - 1].x != path[path.length - 1].x || scenePath[scenePath.length - 1].y != path[path.length - 1].y)
							{
								PlayerMoveSocketHandler.send(path);
							}
						}
						self.setPath(path,tmpCallback);
						if(showClickEffect)
						{
							var effect:BaseLoadEffect = ClickEffect.getInstance();
							var target:Point = path[path.length - 1];
							effect.move(target.x,target.y);
							_mediator.sceneModule.sceneInit.getScene().addToMap(effect);
							effect.play(SourceClearType.NEVER);
						}
					}
				}
				if(isUpHouse)
				{
					if(_mediator.sceneInfo.playerList.self.getIsDead())
					{
						return;
					}
					if(GlobalData.taskInfo.getTransportTask() != null)
					{
						return;
					}
					if(_mediator.sceneInfo.playerList.self.fightMounts)
					{
						PlayerSetHouseSocketHandler.send(true);
					}
				}
			}
			var doChangeScene:Function = function():void
			{
				_mediator.gotoScene(_doorId);
			}
			
			var self:SelfScenePlayerInfo = _mediator.sceneInfo.playerList.self;
			if(self == null || !self.getCanWalk())return;
			DoubleSitChecker.cancelDoubleSit(walk);
			GlobalData.selfPlayer.sceneTaskTarget = targetP;
			
		}
		
		
		
		public static function doWalkToNpc(npcId:int, sceneX:Number = -1, sceneY:Number = -1):void
		{
			var tmpSceneX:int;
			var tmpSceneY:int;
			var tmpSceneId:int;
			var tmpNpcId:int;
			var npc:NpcTemplateInfo = NpcTemplateList.getNpc(npcId);
			if (!npc) return;
			tmpNpcId = npc.getObjId();
			tmpSceneX = npc.sceneX;
			tmpSceneY = npc.sceneY;
			tmpSceneId = npc.sceneId;
			if (sceneX == -1 && sceneY == -1)
			{
				sceneX = tmpSceneX;
				sceneY = tmpSceneY;
			}
			
			
			doWalk(tmpSceneId,new Point(sceneX,sceneY),doShowNpcPanel,90);
			function doShowNpcPanel():void
			{
				if(npc.templateId == 102112 && GlobalData.selfPlayer.level >= 40)  //打开江湖令
				{
					SetModuleUtils.addSwordsman();		
				}
				else if(npc.templateId == 102109 && GlobalData.selfPlayer.level >= 40)
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ACCEPT_TRANSPORT_PANEL));
				}
				else if(npc.templateId == 102110 && GlobalData.selfPlayer.level >= 35 && GlobalData.pvpInfo.current_active_id == 1001) //打开pvp
				{
					SetModuleUtils.addPVP1();
				}
				else if(int(npc.sceneId*0.01) == 42006) //打开商店
				{
					var info:Object = npc.deploys[0];
					if(info.param1 == 30)
					{
						SetModuleUtils.addDuplicateStore(new ToStoreData(info.param2,info.param4,npc.templateId));
					}
					else
					{
						_mediator.showNpcPanel(npc.templateId);
					}
				}
				else
				{
					_mediator.showNpcPanel(npc.templateId);
				}
				GlobalData.npcId = tmpNpcId;
				_mediator.sceneModule.sceneInit.autoTaskPuase();
			}
			
			function judgeTaskComplete():int
			{
				/**
				 * 任务类型 11是江湖令
				 */
				var _taskType:int = 11;
				var selectIndex:int = 0
				if(GlobalData.taskInfo.getTaskByTaskType(_taskType) != null)
				{
//					var info:TaskItemInfo = GlobalData.taskInfo.getTaskByTaskType(_taskType)
//					if(GlobalData.taskInfo.taskStateChecker.checkStateComplete(TaskItemInfo(info).getCurrentState(),TaskItemInfo(info).requireCount))
//					{
//						selectIndex = 1
//					}
				}
				return selectIndex;
			}
			
//			_mediator.sceneModule.sceneInit.autoTaskPuase();
		}
		
		
		
		public static function doWalkToDoor(doorId:int):void
		{
			var door:DoorTemplateInfo = DoorTemplateList.getDoorTemplate(doorId);
			if(!door.canTo())return;
			doWalk(door.mapId,new Point(door.sceneX,door.sceneY),gotoScene);
			function gotoScene():void
			{
				_mediator.gotoScene(door.templateId);
			}
		}
		
		public static function doWalkToStall(playerId:Number,pos:Point,sceneId:int,playerName:String = ""):void
		{
			doWalk(sceneId,pos,showStall,60);
			function showStall():void
			{
				_mediator.showStall(playerId,playerName);
			}
		}
		public static function doWalkToHangup(monsterId:int, reset:Boolean = true):void
		{
			var monster:MonsterTemplateInfo;
			function attackMonster () : void
			{
				_mediator.setHangup(reset);
				_mediator.sceneModule.sceneInit.autoTaskPuase();
			}
			var currentSelect:BaseSceneMonsterInfo = _mediator.sceneInfo.getCurrentSelect() as BaseSceneMonsterInfo;
			if (currentSelect && currentSelect.templateId == monsterId)
			{
				attackMonster();
			}
			else
			{
				monster = MonsterTemplateList.getMonster(monsterId);
				doWalk(monster.sceneId, monster.getAPoint(), attackMonster);
			}
			
//			var monster:MonsterTemplateInfo = MonsterTemplateList.getMonster(monsterId);
//			doWalk(monster.sceneId,monster.getAPoint(),attackMonster);
//			function attackMonster():void
//			{
//				_mediator.sceneInfo.hangupData.monsterNeedCount = count;
//				_mediator.sceneInfo.hangupData.autoFindTask = autoFindTask;
//				_mediator.sceneInfo.hangupData.setTargetToTop(monsterId);
//				_mediator.sceneInfo.playerList.self.setHangupState();
//				//				_mediator.sceneInfo.playerList.self.attackState = 2;
//			}
		}
//		public static function doWalkToTaskAttack(monsterId:int,count:int,autoFindTask:Boolean):void
//		{
//			var currentSelect:BaseSceneMonsterInfo = _mediator.sceneInfo.getCurrentSelect() as BaseSceneMonsterInfo;
//			if(currentSelect && currentSelect.templateId == monsterId)
//			{
//				_mediator.sceneInfo.hangupData.monsterNeedCount = count;
//				_mediator.sceneInfo.hangupData.autoFindTask = autoFindTask;
//				_mediator.sceneInfo.hangupData.setTargetToTop(monsterId);
//				_mediator.sceneInfo.playerList.self.setHangupState();
//				//				_mediator.sceneInfo.playerList.self.attackState = 2;
//			}
//			else
//			{
//				doWalkToHangup(monsterId,count,autoFindTask);
//			}
//		}
		public static function doWalkToPickup(itemId:int,sceneX:Number,sceneY:Number,callback:Function = null,clearState:Boolean = true):void
		{
			doWalk(_mediator.sceneInfo.mapInfo.mapId,new Point(sceneX,sceneY),doWalkComplete,100,clearState);
			function doWalkComplete():void
			{
				_mediator.pickup(itemId);
				_mediator.sceneInfo.dropItemList.setCanClientPickup(itemId,false);
				if(callback != null)
				{
					callback();
				}
			}
		}
		public static function doWalkToDoubleSit(serverId:int,nick:String,id:Number,x:Number,y:Number):void
		{
			doWalk(_mediator.sceneInfo.mapInfo.mapId,new Point(x,y),doWalkComplete,40);
			function doWalkComplete():void
			{
				//判断是否能打坐
				var player:BaseScenePlayerInfo = _mediator.sceneInfo.playerList.getPlayer(id);
				if(player && Point.distance(new Point(player.sceneX,player.sceneY),new Point(x,y)) < 80)
				{
					PlayerInviteSitRelaySocketHandler.send(true,id);
				}
			}
		}
		
		
		public static function doWalkToCenterCollect(templateId:int):void
		{
			GlobalData.collectTarget = templateId;
			var collectItem:CollectItemInfo = _mediator.sceneInfo.collectList.getNearlyItemByTemplateId(templateId,new Point(_mediator.sceneInfo.playerList.self.sceneX,_mediator.sceneInfo.playerList.self.sceneY));
			if(collectItem)
			{
				doWalkToCollect(collectItem.id,collectItem.sceneX,collectItem.sceneY);
			}
			else
			{
				var template:CollectTemplateInfo = CollectTemplateList.getCollect(templateId);
				doWalk(template.sceneId,new Point(template.centerX,template.centerY),doWalkToCenterComplete);
			}
//			_mediator.sceneModule.sceneInit.autoTaskPuase();
			function doWalkToCenterComplete():void
			{
				var collectItem2:CollectItemInfo = _mediator.sceneInfo.collectList.getNearlyItemByTemplateId(templateId,new Point(_mediator.sceneInfo.playerList.self.sceneX,_mediator.sceneInfo.playerList.self.sceneY));
				if(collectItem2)
				{
					doWalkToCollect(collectItem2.id,collectItem2.sceneX,collectItem2.sceneY);
				}
			}
		}
		public static function doWalkToCollect(id:int,targetX:Number,targetY:Number):void
		{
			doWalk(_mediator.sceneInfo.mapInfo.mapId,new Point(targetX,targetY),doWalkComplete,60);
			function doWalkComplete():void
			{
				if(_mediator.sceneInfo.collectList.list[id])
				{
					_mediator.stopMoving();
//					_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
					if(_mediator.sceneInfo.playerList.self.isSit)
					{
						_mediator.selfSit(false);
					}
					_mediator.sceneInfo.playerList.self.setCollectState();
					_mediator.sceneInfo.playerList.self.setCollecting(id);
				}
				_mediator.sceneModule.sceneInit.autoTaskPuase();
			}
		}
		
		
		
		
		
	}
}