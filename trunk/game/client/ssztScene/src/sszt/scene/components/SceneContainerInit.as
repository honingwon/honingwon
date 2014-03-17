package sszt.scene.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import scene.camera.BaseCamera;
	import scene.events.BaseSceneObjectEvent;
	import scene.events.MapEvent;
	import scene.events.SceneEvent;
	import scene.map.BaseMap;
	import scene.render.BaseMapRender;
	import scene.render.BaseSceneObjRender;
	import scene.scene.BaseMapScene;
	import scene.viewport.BaseViewPort;
	
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.LayerIndex;
	import sszt.constData.SceneConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.LayerInfo;
	import sszt.core.data.collect.CollectTemplateInfo;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.data.scene.MoveType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.GCUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.scene.ICamera;
	import sszt.interfaces.scene.ISceneObj;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.actions.AutoTaskActionII;
	import sszt.scene.actions.ClubFireAction;
	import sszt.scene.actions.FireworkAction;
	import sszt.scene.actions.RoseAction;
	import sszt.scene.actions.ShakeAction;
	import sszt.scene.actions.ShakeActionII;
	import sszt.scene.actions.TransferCallBackAction;
	import sszt.scene.commands.MapController;
	import sszt.scene.commands.activities.CarListController;
	import sszt.scene.commands.activities.CollectListController;
	import sszt.scene.commands.activities.DoorListController;
	import sszt.scene.commands.activities.DropListController;
	import sszt.scene.commands.activities.MonsterListController;
	import sszt.scene.commands.activities.NpcListController;
	import sszt.scene.commands.activities.PetListController;
	import sszt.scene.commands.activities.PlayerListController;
	import sszt.scene.commands.activities.SpecialController;
	import sszt.scene.components.sceneObjs.BaseRoleUpdateEvent;
	import sszt.scene.components.shenMoWar.shenMoIcon.ShenMoIconView;
	import sszt.scene.data.SceneMapInfoUpdateEvent;
	import sszt.scene.data.collects.CollectItemInfo;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.proxy.SceneLoadMapDataProxy;
	import sszt.scene.socketHandlers.PlayerInviteSitRelaySocketHandler;
	import sszt.scene.socketHandlers.PlayerInviteSitSocketHandler;
	import sszt.ui.container.MAlert;
	
	public class SceneContainerInit extends EventDispatcher implements ITick
	{
		private var _mediator:SceneMediator;
		private var _map:BaseMap;
		private var _scene:BaseMapScene;
		private var _camera:ICamera;
		private var _viewPort:BaseViewPort;
		private var _mapSceneRender:BaseMapRender;
		private var _sceneObjRender:BaseSceneObjRender;
		
		private var _hadInitScene:Boolean;
		
		private var _monsterListController:MonsterListController;
		/**玩家列表*/
		private var _playerListController:PlayerListController;
		private var _petListController:PetListController;
		private var _mapController:MapController;
		private var _dropListController:DropListController;
		private var _npcController:NpcListController;
		private var _doorListController:DoorListController;
		private var _collectListController:CollectListController;
		private var _carListController:CarListController;
		private var _specialController:SpecialController;
		private var _doRender:Boolean;
		
		private var _shakeAction:ShakeAction;
		private var _shakeAction1:ShakeActionII;
		private var _clubFireAction:ClubFireAction;
		private var _fireworkAction:FireworkAction;
		private var _roseAction:RoseAction;
		private var _selectedSceneObj:ISceneObj;
		private var _frameCount:int;
		private var _autoTaskAction:AutoTaskActionII;
		
		private var _transferCallbackAction:TransferCallBackAction;
		
		public function SceneContainerInit(mediator:SceneMediator)
		{
//			JSUtils.doFullScene();
//			CommonConfig.isFull = true;
			SceneLoadMapDataProxy.setup(mediator);
			_frameCount = 0;
			_mediator = mediator;
			_hadInitScene = false;
			_shakeAction = new ShakeAction();
			_shakeAction1 = new ShakeActionII();
			_clubFireAction = new ClubFireAction();
			_fireworkAction = new FireworkAction();
			_roseAction = new RoseAction();
			_autoTaskAction = new AutoTaskActionII();
			createScene();
			startLoad();
			GlobalAPI.tickManager.addTick(this);
			GCUtil.instance.start();
			if(GlobalData.fullScene)
			{
//				JSUtils.doFullScene();
				CommonConfig.isFull = true;
			}
		}
		
		public function startLoad():void
		{
			GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.loadingScene"));
			this._mediator.sceneInfo.mapDatas.addEventListener(SceneMapInfoUpdateEvent.LOAD_DATA_COMPLETE, this.loadDataCompleteHandler);
			this._mediator.sceneInfo.mapDatas.loadMapData(this._mediator.sceneInfo.mapInfo.mapId);
		}
		
		private function loadDataCompleteHandler(event:SceneMapInfoUpdateEvent):void
		{
			var id:int = event.data as int;
			if (this._mediator.sceneInfo.mapInfo.mapId == id)
			{
				
				this._mediator.sceneInfo.mapInfo.setInfo(this._mediator.sceneInfo.mapDatas.getMapInfo(this._mediator.sceneInfo.mapInfo.mapId));
				this.loadMapInfoComplete();
			}
			this._mediator.sceneInfo.mapDatas.removeEventListener(SceneMapInfoUpdateEvent.LOAD_DATA_COMPLETE, this.loadDataCompleteHandler);
		}
		
		private function loadMapInfoComplete():void
		{
//			_mediator.sceneInfo.mapInfo.setData(data);
			_mediator.loadMapPre(_mediator.sceneInfo.mapInfo.mapId,loadThumbnailComplete);
			SoundManager.instance.playBackgroup(MapTemplateList.getMapTemplate(_mediator.sceneInfo.mapInfo.mapId).music);
			initScene();
		}
		
		private function loadThumbnailComplete(data:BitmapData):void
		{
			_mediator.sceneInfo.setMapThumbnail(data);
			_map.setThumbnail(data,10,10);
//			initScene();
		}
		
		private function needDataHandler(evt:MapEvent):void
		{
			_mediator.loadNeedMapData(_mediator.sceneInfo.mapInfo.mapId,evt.row,evt.col,needMapDataComplete);
		}
		
		private function needMapDataComplete(data:Bitmap,row:int,col:int):void
		{
			_map.addTileBitmap(row,col,data);
		}
		
		public function get playerListController():PlayerListController
		{
			return _playerListController;
		}
		
		public function get petListController() : PetListController
		{
			return _petListController;
		}
		
		public function get specialController():SpecialController
		{
			return _specialController;
		}
		
		private function createScene():void
		{
			_map = new BaseMap();
			_map.addEventListener(MapEvent.NEED_DATA,needDataHandler);
			_camera = new BaseCamera();
			_viewPort = new BaseViewPort(CommonConfig.GAME_WIDTH,CommonConfig.GAME_HEIGHT,CommonConfig.GAME_WIDTH / 2,CommonConfig.GAME_HEIGHT / 2,100,80,CommonConfig.GAME_WIDTH,CommonConfig.GAME_HEIGHT);
			_scene = new BaseMapScene(_mediator.sceneInfo,_viewPort);
			_scene.setMap(_map);
			GlobalAPI.tickManager.addTick(_map);
			_mapSceneRender = new BaseMapRender(_scene,_camera,_viewPort);
			GlobalAPI.tickManager.addTick(_mapSceneRender);
			_mediator.sceneModule.addChildAt(_viewPort,0);
			_sceneObjRender = new BaseSceneObjRender(_scene,_camera,_viewPort);
			GlobalAPI.tickManager.addTick(_sceneObjRender);
			_playerListController = new PlayerListController(_scene,_mediator);
			GlobalAPI.tickManager.addTick(_playerListController);
			_petListController = new PetListController(_scene,_mediator);
			_specialController = new SpecialController(_scene,_mediator);
			if(_playerListController.getSelf())
			{
				_viewPort.focusPoint = new Point(_playerListController.getSelf().getBaseRoleInfo().sceneX,_playerListController.getSelf().getBaseRoleInfo().sceneY);
			}
			else
			{
				_playerListController.addEventListener(PlayerListController.SETSELF_COMPLETE,setSelfCompleteHandler);
			}
			_viewPort.getLayerContainer(LayerIndex.MAPLAYER).addEventListener(MouseEvent.CLICK,viewPortClickHandler,false,1);
			_mediator.sceneInfo.addEventListener(SceneInfoUpdateEvent.RENDER,renderHandler);
			_monsterListController = new MonsterListController(_scene,_mediator);
			_mapController = new MapController(_scene,_mediator);
			_dropListController = new DropListController(_scene,_mediator);
			_doorListController = new DoorListController(_scene,_mediator);
			_npcController = new NpcListController(_scene,_mediator);
			_collectListController = new CollectListController(_scene,_mediator); 
			_carListController = new CarListController(_scene,_mediator);
			_clubFireAction.setParent(_scene);
			_fireworkAction.setParent(_scene);
			_autoTaskAction.setup(_scene, _mediator);
			GlobalAPI.tickManager.addTick(_fireworkAction);
			GlobalAPI.tickManager.addTick(_roseAction);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			_viewPort.viewRect.width = CommonConfig.GAME_WIDTH;
			_viewPort.viewRect.height = CommonConfig.GAME_HEIGHT;
			renderScene();
		}
		
		private function initScene():void
		{
			_viewPort.maxRect = new Rectangle(0,0,_mediator.sceneInfo.getWidth(),_mediator.sceneInfo.getHeight());
			_scene.setRect(_viewPort.maxRect);
			_mapController.setPathSource();
			_clubFireAction.configure(CategoryType.isClubMap(_mediator.sceneInfo.mapInfo.mapId));
			if(!_mediator.sceneInfo.mapInfo.getIsCopy())
			{
				GlobalData.copyEnterCountList.isInCopy = false;
				GlobalData.copyEnterCountList.inCopyId = 0;
			}
			_hadInitScene = true;
			if(_playerListController.getSelf())
			{
				_viewPort.focusPoint = new Point(_playerListController.getSelf().getBaseRoleInfo().sceneX,_playerListController.getSelf().getBaseRoleInfo().sceneY);
			}
			else
			{
				_viewPort.focusPoint = new Point(_mediator.sceneInfo.bornX,_mediator.sceneInfo.bornY);
			}
			renderScene();
			
//			_mediator.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMORANKING);
			_mediator.sceneInfo.mapInfo.updateNpcState();
			_mediator.sendMapRound();
		}
		
		private function setSelfCompleteHandler(evt:Event):void
		{
			//去掉loading
			GlobalAPI.waitingLoading.hide();
			if(!_mediator.sceneInfo.mapInfo.getIsSafeArea())
				QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveSafeArea"));
			
			_viewPort.focusPoint = new Point(_playerListController.getSelf().getBaseRoleInfo().sceneX,_playerListController.getSelf().getBaseRoleInfo().sceneY);
			_mediator.sceneInfo.dispatchRender();
			if(_hadInitScene)
				renderScene();
			_specialController.initScene();
			if(MapTemplateList.needClearPath())
			{
				GlobalData.selfPlayer.scenePath = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathCallback = null;
				playerListController.getSelf().stopMoving();
			}
			
			if (GlobalData.transferType != 0)
			{
				if (_transferCallbackAction == null)
				{
					_transferCallbackAction = new TransferCallBackAction(this._mediator);
				}
				_transferCallbackAction.configure();
			}
			else
			{
				if (GlobalData.npcId != 0 && GlobalData.npcId != 102110 && !GlobalData.copyEnterCountList.isInCopy) //
				{
					if(GlobalData.npcId != 102110) // 102110 是擂台npc id
					{
						_mediator.showNpcPanel(GlobalData.npcId);
					}
				}
			}
			
			initNewly();
			
			//跨图寻路
			var doorId:int;
			
			if(GlobalData.selfPlayer.scenePathTarget != null || (GlobalData.selfPlayer.scenePath != null && GlobalData.selfPlayer.scenePath.length > 0))
			{
				GlobalData.selfPlayer.scenePath.splice(0,1);
				if(GlobalData.selfPlayer.scenePath.length > 0)
				{
					var door:DoorTemplateInfo = DoorTemplateList.getDoorTemplate(GlobalData.selfPlayer.scenePath[0]);
					doorId = door.templateId;
					_mediator.walk(_mediator.sceneInfo.getSceneId(), new Point(door.sceneX, door.sceneY), doChangeScene, 0, true, true, false, false);
				}
				else if(GlobalData.selfPlayer.scenePathTarget != null)
				{
					_mediator.walk(_mediator.sceneInfo.getSceneId(), GlobalData.selfPlayer.scenePathTarget.clone(), scenePathComplete, GlobalData.selfPlayer.scenePathStopAtDistance, true, true, false, false);
				}
			}
			else {
				_autoTaskAction.autoTaskPause();
			}
			if (GlobalData.currentMapId != GlobalData.preMapId)
			{
				SceenShowWordView.getInstance().show(150000000+GlobalData.currentMapId);
			}
			
			function doChangeScene():void
			{
				_mediator.gotoScene(doorId);
			}
			function scenePathComplete():void
			{
				if(GlobalData.selfPlayer.scenePathCallback != null)
					GlobalData.selfPlayer.scenePathCallback();
				GlobalData.selfPlayer.scenePathCallback = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathStopAtDistance = 0;
			}
		}
		
		private function initNewly() : void
		{
			if (
				GlobalData.taskInfo.getTaskByTemplateId(550001)==null &&
				GlobalData.taskInfo.getTaskByTemplateId(550101) ==null &&
				GlobalData.taskInfo.getTaskByTemplateId(550201)==null )
			{
				//接第一个任务
				var deploy:DeployItemInfo = new DeployItemInfo();
				deploy.type = DeployEventType.TASK_NPC;
				switch(GlobalData.selfPlayer.career)
				{
					case CareerType.SANWU:
						deploy.param1 = 102303;
						break;
					case CareerType.XIAOYAO:
						deploy.param1 = 102206;
						break;
					case CareerType.LIUXING:
						deploy.param1 = 102406;
						break;
				}
				DeployEventManager.handle(deploy);
				
				var deploy3:DeployItemInfo = new DeployItemInfo();
				deploy3.type = DeployEventType.GUIDE_TIP;
				deploy3.param1 = GuideTipDeployType.NPC_TASK;
				deploy3.param2 = 8;
				deploy3.param3 = 352;
				deploy3.param4 = 124;
				GlobalData.setGuideTipInfo(deploy3);
				
			}
		}
		
		
		public function getViewPortPos():Point
		{
			return new Point(_viewPort.viewRect.x,_viewPort.viewRect.y);
		}
		
		public function getScene() : BaseMapScene
		{
			return this._scene;
		}
		
		public function getMapController() : MapController
		{
			return this._mapController;
		}
		
		
//		public function walk(scene:int,p:Point,walkComplete:Function = null,stopAtDistance:Number = 0,clearState:Boolean = true,showClickEffect:Boolean = false,
//							 clearSpanMapState:Boolean = true,clearFollowState:Boolean = true):void
//		{
//			_mapController.walk(scene,p,walkComplete,stopAtDistance,clearState,showClickEffect,clearSpanMapState,true,clearFollowState);
//		}
//		public function walkToNpc(npcId:int):void
//		{
//			var npc:NpcTemplateInfo = NpcTemplateList.getNpc(npcId);
//			if(!npc)return;
//			walk(npc.sceneId,new Point(npc.sceneX,npc.sceneY),doShowNpcPanel,60);
//			function doShowNpcPanel():void
//			{
//				_mediator.showNpcPanel(npc.templateId);
//			}
//		}
//		public function walkToDoor(doorId:int):void
//		{
//			var door:DoorTemplateInfo = DoorTemplateList.getDoorTemplate(doorId);
//			if(!door.canTo())return;
//			walk(door.mapId,new Point(door.sceneX,door.sceneY),gotoScene);
//			function gotoScene():void
//			{
//				_mediator.gotoScene(door.templateId);
//			}
//		}
//		public function walkToStall(playerId:Number,pos:Point,sceneId:int,playerName:String = ""):void
//		{
//			walk(sceneId,pos,showStall,60);
//			function showStall():void
//			{
//				_mediator.showStall(playerId,playerName);
//			}
//		}
//		public function walkToHangup(monsterId:int,count:int,autoFindTask:Boolean):void
//		{
//			var monster:MonsterTemplateInfo = MonsterTemplateList.getMonster(monsterId);
//			walk(monster.sceneId,monster.getAPoint(),attackMonster);
//			function attackMonster():void
//			{
//				_mediator.sceneInfo.hangupData.monsterNeedCount = count;
//				_mediator.sceneInfo.hangupData.autoFindTask = autoFindTask;
//				_mediator.sceneInfo.hangupData.setTargetToTop(monsterId);
//				_mediator.sceneInfo.playerList.self.setHangupState();
////				_mediator.sceneInfo.playerList.self.attackState = 2;
//			}
//		}
//		public function walkToTaskAttack(monsterId:int,count:int,autoFindTask:Boolean):void
//		{
//			var currentSelect:BaseSceneMonsterInfo = _mediator.sceneInfo.getCurrentSelect() as BaseSceneMonsterInfo;
//			if(currentSelect && currentSelect.templateId == monsterId)
//			{
//				_mediator.sceneInfo.hangupData.monsterNeedCount = count;
//				_mediator.sceneInfo.hangupData.autoFindTask = autoFindTask;
//				_mediator.sceneInfo.hangupData.setTargetToTop(monsterId);
//				_mediator.sceneInfo.playerList.self.setHangupState();
////				_mediator.sceneInfo.playerList.self.attackState = 2;
//			}
//			else
//			{
//				walkToHangup(monsterId,count,autoFindTask);
//			}
//		}
//		public function walkToPickup(itemId:int,sceneX:Number,sceneY:Number,callback:Function = null,clearState:Boolean = true):void
//		{
//			walk(_mediator.sceneInfo.mapInfo.mapId,new Point(sceneX,sceneY),walkComplete,100,clearState);
//			function walkComplete():void
//			{
//				_mediator.pickup(itemId);
//				_mediator.sceneInfo.dropItemList.setCanClientPickup(itemId,false);
//				if(callback != null)
//				{
//					callback();
//				}
//			}
//		}
//		public function walkToDoubleSit(serverId:int,nick:String,id:Number,x:Number,y:Number):void
//		{
//			walk(_mediator.sceneInfo.mapInfo.mapId,new Point(x,y),walkComplete,40);
//			function walkComplete():void
//			{
//				//判断是否能打坐
//				var player:BaseScenePlayerInfo = _mediator.sceneInfo.playerList.getPlayer(id);
//				if(player && Point.distance(new Point(player.sceneX,player.sceneY),new Point(x,y)) < 80)
//				{
//					PlayerInviteSitRelaySocketHandler.send(true,id);
//				}
//			}
//		}
//		public function walkToCenterCollect(templateId:int):void
//		{
//			var collectItem:CollectItemInfo = _mediator.sceneInfo.collectList.getNearlyItemByTemplateId(templateId,new Point(_mediator.sceneInfo.playerList.self.sceneX,_mediator.sceneInfo.playerList.self.sceneY));
//			if(collectItem)
//			{
//				walkToCollect(collectItem.id,collectItem.sceneX,collectItem.sceneY);
//			}
//			else
//			{
//				var template:CollectTemplateInfo = CollectTemplateList.getCollect(templateId);
//				walk(template.sceneId,new Point(template.centerX,template.centerY),walkToCenterComplete);
//			}
//			function walkToCenterComplete():void
//			{
//				var collectItem2:CollectItemInfo = _mediator.sceneInfo.collectList.getNearlyItemByTemplateId(templateId,new Point(_mediator.sceneInfo.playerList.self.sceneX,_mediator.sceneInfo.playerList.self.sceneY));
//				if(collectItem2)
//				{
//					walkToCollect(collectItem2.id,collectItem2.sceneX,collectItem2.sceneY);
//				}
//			}
//		}
//		public function walkToCollect(id:int,targetX:Number,targetY:Number):void
//		{
//			walk(_mediator.sceneInfo.mapInfo.mapId,new Point(targetX,targetY),walkComplete,60);
//			function walkComplete():void
//			{
//				if(_mediator.sceneInfo.collectList.list[id])
//				{
//					_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
//					if(_mediator.sceneInfo.playerList.self.isSit)
//					{
//						_mediator.selfSit(false);
//					}
//					_mediator.sceneInfo.playerList.self.setCollecting(id);
//				}
//			}
//		}
		
		public function shakeScene():void
		{
			_shakeAction.configure(_viewPort);
			GlobalAPI.tickManager.addTick(_shakeAction);
		}
		
		public function shakeScene1():void
		{
			_shakeAction1.configure(_viewPort);
			GlobalAPI.tickManager.addTick(_shakeAction1);
		}
		
		public function petWalk(pet:BaseScenePetInfo,to:Point,stopAtDistance:Number,directly:Boolean = false):void
		{
			_mapController.petWalk(pet,to,stopAtDistance,directly);
		}
		public function carWalk(car:BaseSceneCarInfo,to:Point,stopAtDistance:Number,directly:Boolean = false):void
		{
			_mapController.carWalk(car,to,stopAtDistance,directly);
		}
		
		public function playFirework(id:Number,type:int):void
		{
			var player:BaseScenePlayerInfo = _mediator.sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				_fireworkAction.configure(player.sceneX,player.sceneY,type);
			}
		}
		public function rosePlay():void
		{
			_roseAction.configure();
		}
		
		
		private function renderHandler(evt:SceneInfoUpdateEvent):void
		{
			renderScene();
		}
		
		private function renderScene():void
		{
//			_mapSceneRender.render();
//			_sceneObjRender.render();
			_doRender = true;
		}
		
		private function viewPortClickHandler(evt:MouseEvent):void
		{
			if(_selectedSceneObj)
			{
				_selectedSceneObj.doMouseClick();
				evt.stopImmediatePropagation();
			}
			GlobalAPI.layerManager.getPopLayer().stage.focus = GlobalAPI.layerManager.getPopLayer().stage;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_doRender)
			{
				_mapSceneRender.render();
				_sceneObjRender.render();
				_doRender = false;
			}
			_frameCount++;
			if(_frameCount >= 3)
			{
				_frameCount = 0;
				
				if(_mediator.sceneInfo.playerList.self && _mediator.sceneInfo.mapInfo && CopyTemplateList.needClearOutBrost(GlobalData.copyEnterCountList.inCopyId) )
				{
					var nextGridX:int = int(_mediator.sceneInfo.playerList.self.sceneX / SceneConfig.BROST_WIDTH);
					var nextGridY:int = int(_mediator.sceneInfo.playerList.self.sceneY / SceneConfig.BROST_HEIGHT);
					_mediator.sceneInfo.monsterList.removeOutBrostMonster(nextGridX,nextGridY,_mediator.sceneInfo.mapInfo.maxServerGridCountX,_mediator.sceneInfo.mapInfo.maxServerGridCountY);
				}
				
				var obj:ISceneObj = _sceneObjRender.getMouseOverObject();
				if(obj == _selectedSceneObj)return;
				if(_selectedSceneObj)_selectedSceneObj.doMouseOut();
				_selectedSceneObj = obj;
				if(_selectedSceneObj)_selectedSceneObj.doMouseOver();
			}
		}
		
		public function autoTaskPuase() : void
		{
			_autoTaskAction.autoTaskPause();
		}
		
		public function clear():void
		{
			if(_map)_map.clear();
			if(_monsterListController)_monsterListController.clear();
			if(_playerListController)_playerListController.clear();
			if(_petListController)_petListController.clear();
			if(_mapController)_mapController.clear();
			if(_dropListController)_dropListController.clear();
			if(_npcController)_npcController.clear();
			if(_doorListController)_doorListController.clear();
			if(_collectListController)_collectListController.clear();
			if(_carListController)_carListController.clear();
			_hadInitScene = false;
			if(_shakeAction)GlobalAPI.tickManager.removeTick(_shakeAction);
			if(_shakeAction1)GlobalAPI.tickManager.removeTick(_shakeAction1);
			if(_clubFireAction)_clubFireAction.clear();
			if(_fireworkAction)_fireworkAction.clear();
			if (_autoTaskAction) _autoTaskAction.autoTaskPause();
			if(_specialController)_specialController.clearScene();
		}
		
		public function changeScene():void
		{
			
		}

		public function get monsterListController():MonsterListController
		{
			return _monsterListController;
		}

	}
}
