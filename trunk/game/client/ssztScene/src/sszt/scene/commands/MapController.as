package sszt.scene.commands
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.LayerIndex;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.SetSocketHandler;
	import sszt.core.utils.MapSearch;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.scene.IScene;
	import sszt.interfaces.scene.IViewPort;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerMoveSocketHandler;
	import sszt.scene.socketHandlers.PlayerSetHouseSocketHandler;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	import sszt.scene.socketHandlers.TargetAttackWaitingSocketHandler;
	import sszt.scene.socketHandlers.TeamStopFollowSocketHandler;
	import sszt.scene.utils.AStarIII;
	import sszt.scene.utils.ClickEffect;
	import sszt.scene.utils.PathUtils;
	import sszt.scene.utils.pathFind3.FindPath8;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class MapController implements ITick
	{
		private var _scene:IScene;
		private var _viewPort:DisplayObject;
		private var _mediator:SceneMediator;
		private var _lastClickInterval:Number = 0;
		
		private var _pathFinder:AStarIII;
		private var _pathFinder2:FindPath8;
		private var _doubleSitAlert:MAlert;
		
		public function MapController(sc:IScene,mediator:SceneMediator)
		{
			_scene = sc;
			_viewPort = sc.getViewPort() as DisplayObject;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_pathFinder = new AStarIII();
		}
		
		private function initEvent():void
		{
			_scene.getViewPort().getLayerContainer(LayerIndex.MAPLAYER).addEventListener(MouseEvent.CLICK,clickHandler,false,-1);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var t:Number = getTimer();
			if(t - _lastClickInterval < CommonConfig.CLICK_INTERVAL)return;
			if(_mediator.sceneInfo.playerList.self == null)return;
			_mediator.sceneInfo.playerList.self.clearHangup();
			if(_mediator.sceneInfo.playerList.self.getIsReady())
			{
				TargetAttackWaitingSocketHandler.send();
			}
			_mediator.sceneInfo.playerList.self.clearAttackState();
			_mediator.sceneInfo.playerList.self.state.setFindPath(false);
			var mapLayer:Sprite = (_viewPort as IViewPort).getLayerContainer(LayerIndex.MAPLAYER);
			WalkChecker.doWalk(_mediator.sceneInfo.getSceneId(),new Point(mapLayer.mouseX,mapLayer.mouseY),null,0,true,true);
		}
		
		
		public function getPathFinder():AStarIII
		{
			return this._pathFinder;
		}
		
		
//		/**
//		 * 
//		 * @param sceneId
//		 * @param target
//		 * @param callBack
//		 * @param stopAtDistance
//		 * @param clearState是否清除挂机状态
//		 * @param showClickEffect是否显示点击效果
//		 * @param clearSpanMapState清除跨图寻路效果,如果不清，在跨图寻路中间打断，继续跨图时会自动走
//		 * @param clearCollectType清除采集状态
//		 */		
//		public function walk(sceneId:int,targetP:Point,callBack:Function = null,stopAtDistance:Number = 0,clearState:Boolean = true,
//							 showClickEffect:Boolean = false,clearSpanMapState:Boolean = true,clearCollectType:Boolean = true,clearFollowState:Boolean = true):void
//		{
////			if(!_pathFinder2)return;
//			var self:SelfScenePlayerInfo = _mediator.sceneInfo.playerList.self;
//			if(self == null)return;
//			if(_doubleSitAlert)return;
//			var doorId:int;
//			if(_mediator.sceneInfo.playerList.isDoubleSit())
//			{
//				_doubleSitAlert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,stopDoubleSit);
//			}
//			else
//			{
//				doWalk();
//			}
//			function stopDoubleSit(evt:CloseEvent):void
//			{
//				if(evt.detail == MAlert.OK)
//				{
//					_mediator.sceneInfo.playerList.clearDoubleSit();
//					doWalk();
//				}
//				_doubleSitAlert = null;
//			}
//			function doWalk():void
//			{
//				if(!self.getCanWalk())return;
////				if(self.getIsReady())
////				{
////					self.setFightState();
////				}
//				if(clearState)
//				{
//					_mediator.sceneInfo.playerList.self.clearHangup();
//				}
//				if(clearCollectType)
//					_mediator.sceneInfo.playerList.self.setCollecting(-1);
//				if(self.info.isSit())
//				{
//					_mediator.selfSit(false);
//				}
//				if(clearFollowState)
//					self.setFollower(null);
//				var path:Array;
//				var tmpCallback:Function = callBack;
//				var isUpHouse:Boolean = false;
//				var selfPoint:Point = new Point(self.sceneX,self.sceneY);
//				if(sceneId != _mediator.sceneInfo.getSceneId())
//				{
//					var doorPath:Array = MapSearch.find(_mediator.sceneInfo.getSceneId(),sceneId);
//					if(doorPath == null || doorPath.length == 0)return;
//					if(doorPath != null)GlobalData.selfPlayer.scenePath = doorPath.slice(0);
//					GlobalData.selfPlayer.scenePathTarget = targetP;
//					GlobalData.selfPlayer.scenePathCallback = callBack;
//					GlobalData.selfPlayer.scenePathStopAtDistance = stopAtDistance;
//					var door:DoorTemplateInfo = DoorTemplateList.getDoorTemplate(doorPath[0]);
//					doorId = door.templateId;
//					if(_mediator.sceneInfo.mapInfo.isSpaScene())
//						path = _pathFinder.findpath(selfPoint,new Point(door.sceneX,door.sceneY),2500);
//					else path = _pathFinder.findpath(selfPoint,new Point(door.sceneX,door.sceneY));
//					tmpCallback = doChangeScene;
//					isUpHouse = true;
//				}
//				else
//				{
//					//不同场景不需要清除回调
//					if(clearSpanMapState)
//					{
//						GlobalData.selfPlayer.scenePath = null;
//						GlobalData.selfPlayer.scenePathTarget = null;
//						GlobalData.selfPlayer.scenePathCallback = null;
//					}
//					if(targetP == null)
//					{
//						path = [];
//						_mediator.sceneInfo.playerList.self.state.setFindPath(false);
//						if(tmpCallback != null)
//						{
//							tmpCallback();
//						}
//					}
//					else if(Point.distance(selfPoint,targetP) < 2)
//					{
//						path = [];
//						_mediator.sceneInfo.playerList.self.state.setFindPath(false);
//						if(tmpCallback != null)
//						{
//							tmpCallback();
//						}
//					}
//					else
//					{
//						if(_mediator.sceneInfo.mapInfo.isSpaScene())
//							path = _pathFinder.findpath(selfPoint,targetP,stopAtDistance,2500);
//						else path = _pathFinder.findpath(selfPoint,targetP,stopAtDistance);
//					}
//				}
//				if(path && path.length > 0)
//				{
//					//距离短只调回调，否则走路
//					if(Point.distance(path[path.length - 1],selfPoint) < 2)
//					{
//						_mediator.sceneInfo.playerList.self.state.setFindPath(false);
//						if(tmpCallback != null)
//						{
//							tmpCallback();
//						}
//					}
//					else
//					{
//						if(targetP != null && Point.distance(selfPoint,targetP) >= CommonConfig.SETHOUSE_DISTANCE)
//						{
//							isUpHouse = true;
//						}
//						var scenePath:Array = _mediator.sceneInfo.playerList.self.path;
//						if(scenePath == null)PlayerMoveSocketHandler.send(path);
//						else if(scenePath.length > 0)
//						{
//							if(scenePath[scenePath.length - 1].x != path[path.length - 1].x || scenePath[scenePath.length - 1].y != path[path.length - 1].y)
//							{
//								PlayerMoveSocketHandler.send(path);
//							}
//						}
//						self.setPath(path,tmpCallback);
//						if(showClickEffect)
//						{
//							var effect:BaseLoadEffect = ClickEffect.getInstance();
//							var target:Point = path[path.length - 1];
//							effect.move(target.x,target.y);
//							_scene.addToMap(effect);
//							effect.play(SourceClearType.NEVER);
//						}
//					}
//				}
//				if(isUpHouse)
//				{
//					if(_mediator.sceneInfo.playerList.self.getIsDead())
//					{
//						return;
//					}
//					if(GlobalData.taskInfo.getTransportTask() != null)
//					{
//						return;
//					}
//					if(_mediator.sceneInfo.playerList.self.fightMounts)
//					{
//						PlayerSetHouseSocketHandler.send(true);
//					}
//				}
//			}
//			function doChangeScene():void
//			{
//				_mediator.gotoScene(doorId);
//			}
//		}
		/**
		 * 
		 * @param pet
		 * @param target
		 * @param stopAtDistance
		 * @param directly是否直接跟随，（走直线，不寻路）
		 * 
		 */		
		public function petWalk(pet:BaseScenePetInfo,to:Point,stopAtDistance:Number,directly:Boolean = false):void
		{
//			var self:SelfScenePetInfo = _mediator.sceneInfo.petList.self;
//			if(self == null)return;
			var path:Array;
			var start:Point = new Point(pet.sceneX,pet.sceneY);
			if(directly)
			{
				path = PathUtils.cutPathEnd([start,to],stopAtDistance,to);
			}
			else
			{
				path = _pathFinder.findpath(start,to,stopAtDistance);
//				path = _pathFinder2.find(start,to);
			}
			if(path && path.length > 1)
			{
				pet.setPath(path);
			}
		}
		
		public function carWalk(car:BaseSceneCarInfo,to:Point,stopAtDistance:Number,directly:Boolean = false):void
		{
			var path:Array;
			var start:Point = new Point(car.sceneX,car.sceneY);
			if(directly)
			{
				path = PathUtils.cutPathEnd([start,to],stopAtDistance,to);
			}
			else
			{
				path = _pathFinder.findpath(start,to,stopAtDistance);
			}
			if(path && path.length > 1)
			{
				car.setPath(path);
			}
		}
		
		public function update(times:int,dt:Number=0.04):void
		{
		}
		
		public function setPathSource():void
		{
			_pathFinder.setSource(_mediator.sceneInfo.mapInfo.gridSource);
//			_pathFinder2 = new FindPath8(_mediator.sceneInfo.mapInfo.gridSource);
		}
		
		public function clear():void
		{
		}
	}
}