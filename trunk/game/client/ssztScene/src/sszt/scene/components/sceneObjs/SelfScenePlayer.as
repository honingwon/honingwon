package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.LayerManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.actions.SelfAttackAction;
	import sszt.scene.actions.SelfHangupSelectAction;
	import sszt.scene.actions.characterActions.PlayerCollectAction;
	import sszt.scene.actions.characterActions.TimeSitAction;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.components.common.SitBtns;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfoUpdateEvent;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerMoveSocketHandler;
	import sszt.scene.socketHandlers.PlayerMoveStepSocketHandler;

	public class SelfScenePlayer extends BaseScenePlayer
	{
//		private static const _autoWalkTip:Bitmap = new Bitmap(new AutoWalkTipAsset());
//		private static const _hangupTip:Bitmap = new Bitmap(new HangupingTipAsset());
		private static var _autoWalkTip:Bitmap;
		private static var _hangupTip:Bitmap;
		public static function getAutoWalkTip():Bitmap
		{
			if(!_autoWalkTip)
			{
				_autoWalkTip = new Bitmap(AssetUtil.getAsset("ssztui.scene.AutoWalkTipAsset") as BitmapData);
			}
			return _autoWalkTip;
		}
		public static function getHangupTip():Bitmap
		{
			if(!_hangupTip)
			{
				_hangupTip = new Bitmap(AssetUtil.getAsset("ssztui.scene.HangupingTipAsset") as BitmapData);
			}
			return _hangupTip;
		}
		
		private var _selfAttackAction:SelfAttackAction;
		private var _selfHangupSelectAction:SelfHangupSelectAction;
		private var _collectAction:PlayerCollectAction;
		private var _timeSitAction:TimeSitAction;
		private var _mediator:SceneMediator;
		private var _taskAcceptEffect:BaseLoadEffect;
		private var _taskSubmitEffect:BaseLoadEffect;
		private var _sitBtns:SitBtns;
		
		public function SelfScenePlayer(info:SelfScenePlayerInfo,mediator:SceneMediator)
		{
			_mediator = mediator;
			super(info,_mediator);
			
		}
		
		override protected function init():void
		{
			_sitBtns = new SitBtns(_mediator);
			_sitBtns.x = -40;
			super.init();
			mouseChildren = mouseEnabled = tabChildren = tabEnabled = false;
			_mouseAvoid = true;
			_selfAttackAction = new SelfAttackAction(this,_mediator);
			_selfHangupSelectAction = new SelfHangupSelectAction(this,_mediator);
			_collectAction = new PlayerCollectAction(this,_mediator);
			_timeSitAction = new TimeSitAction(_mediator,this);
			startTimeToSit();
			if(selfScenePlayerInfo.isTransporting)_mediator.showTransport();
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			selfScenePlayerInfo.state.addEventListener(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE,clientStateChangeHandler);
			selfScenePlayerInfo.addEventListener(SelfScenePlayerInfoUpdateEvent.COLLECT_UPDATE,collectUpdateHandler);
			selfScenePlayerInfo.addEventListener(SelfScenePlayerInfoUpdateEvent.STOP_COLLECT,stopCollectHandler);
			_mediator.sceneInfo.addEventListener(SceneInfoUpdateEvent.SELECT_CHANGE,selectChangeHandler);
			_mediator.sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER,addMonsterHandler);
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.TASK_ACCEPT,taskAcceptHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.TASK_SUBMIT,taskSubmitHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.EXPUPDATE,expUpdateHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			selfScenePlayerInfo.state.removeEventListener(PlayerStateUpdateEvent.CLIENT_STATE_CHANGE,clientStateChangeHandler);
			selfScenePlayerInfo.removeEventListener(SelfScenePlayerInfoUpdateEvent.COLLECT_UPDATE,collectUpdateHandler);
			selfScenePlayerInfo.removeEventListener(SelfScenePlayerInfoUpdateEvent.STOP_COLLECT,stopCollectHandler);
			_mediator.sceneInfo.removeEventListener(SceneInfoUpdateEvent.SELECT_CHANGE,selectChangeHandler);
			_mediator.sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER,addMonsterHandler);
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.TASK_ACCEPT,taskAcceptHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.TASK_SUBMIT,taskSubmitHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.EXPUPDATE,expUpdateHandler);
		}
		
		private function clientStateChangeHandler(e:PlayerStateUpdateEvent):void
		{
			if(selfScenePlayerInfo.getIsHangup())
			{
				startAttack();
				startHangup(false);
				getHangupTip().x = -getHangupTip().width / 2;
				if(selfScenePlayerInfo.info.getMounts())
				{
					getHangupTip().y = -330;
				}
				else
				{
					getHangupTip().y = -260;
				}
				addChild(getHangupTip());
				if(getAutoWalkTip().parent)getAutoWalkTip().parent.removeChild(getAutoWalkTip());
			}
			else if(selfScenePlayerInfo.getIsKillOne())
			{
				startAttack();
				if(getHangupTip().parent)getHangupTip().parent.removeChild(getHangupTip());
				if(getAutoWalkTip().parent)getAutoWalkTip().parent.removeChild(getAutoWalkTip());
			}
			else if(selfScenePlayerInfo.getIsFindPath())
			{
				stopAttack();
				getAutoWalkTip().x = -getAutoWalkTip().width/2;
				if(selfScenePlayerInfo.info.getMounts())
				{
					getAutoWalkTip().y =  -330;
				}
				else{
					getAutoWalkTip().y =  -260;
				}
				addChild(getAutoWalkTip());
				if(getHangupTip().parent)getHangupTip().parent.removeChild(getHangupTip());
			}
			else
			{
				stopAttack();
				startTimeToSit();
				if(getHangupTip().parent)getHangupTip().parent.removeChild(getHangupTip());
				if(getAutoWalkTip().parent)getAutoWalkTip().parent.removeChild(getAutoWalkTip());
			}
		}
		
		override public function setFigureVisible(value:Boolean):void
		{
			super.setFigureVisible(true);
		}
		
		private function selectChangeHandler(evt:SceneInfoUpdateEvent):void
		{
			//选择改变（为空，目标已被打死）时，重新检测挂机状态
			_mediator.sceneInfo.hangupData.updateCount();
			startHangup();
		}
		private function addMonsterHandler(evt:SceneMonsterListUpdateEvent):void
		{
			//添加怪物时需要检测挂机状态
			startHangup();
		}
		private function addPlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			//添加人物时检测挂机状态（可以挂的是敌人）
			startHangup();
		}
		
		/**
		 * 改变挂机状态时不判断当前是否有正在打的怪。其他的需要判断
		 * @param judgCurrent
		 * 
		 */		
		public function startHangup(judgCurrent:Boolean = true):void
		{
			if(!_mediator.sceneInfo.hangupData.hangupIng())
			{
				if(_mediator.sceneInfo.playerList.self.getIsHangupAttack())
					_mediator.sceneInfo.playerList.self.clearHangup();
				return;
			}
			if(judgCurrent && !(_mediator.sceneInfo.getCurrentSelect() == null && _mediator.sceneInfo.playerList.self.getIsHangupAttack()))
			{
			}
			else
			{
				_selfHangupSelectAction.configure();
				addAction(_selfHangupSelectAction);
			}
		}
		
		override protected function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			super.playerStateUpdateHandler(e);
			if(selfScenePlayerInfo.getIsDead())
			{
				if(selfScenePlayerInfo.info.getMounts())
				{
					//死亡，下马
					_mediator.mountAvoid();
				}
			}
			if(selfScenePlayerInfo.getIsDeadOrDizzy())
			{
				if(selfScenePlayerInfo.info.isSit())
				{
					//取消打坐
					_mediator.selfSit(false);
				}
				stopMoving();
			}
			if(selfScenePlayerInfo.getIsDeadOrDizzy() && !selfScenePlayerInfo.getIsHangup())
			{
				stopAttack();
			}
			if(selfScenePlayerInfo.getIsFight())
			{
				if(selfScenePlayerInfo.getCollecting() != -1)
				{
					_collectAction.stopCollect();
					GlobalAPI.tickManager.removeTick(_collectAction);
				}
			}
		}
		
		override protected function walkComplete():void
		{
			super.walkComplete();
			startTimeToSit();
			selfScenePlayerInfo.state.setFindPath(false);
		}
		
		private function startTimeToSit():void
		{
			if(selfScenePlayerInfo.getIsCommon() && isMoving == false && selfScenePlayerInfo.getIsNotAttack())
			{
				_timeSitAction.configure();
				GlobalAPI.tickManager.addTick(_timeSitAction);
			}
		}
		
		override public function hideHpBar():void
		{
			super.hideHpBar();
			//清除攻击状态，挂机状态不清除
			if(!selfScenePlayerInfo.getIsHangup())
				selfScenePlayerInfo.clearHangup();
			startTimeToSit();
		}
		
		override protected function transportUpdateHandler(e:BaseRoleInfoUpdateEvent):void
		{
			super.transportUpdateHandler(e);
			
			if(selfScenePlayerInfo.isTransporting)_mediator.showTransport();
			else _mediator.hideTransport();
		}
		
		override protected function walkStartHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			super.walkStartHandler(evt);
			GlobalAPI.tickManager.removeTick(_timeSitAction);
		}
		
		public function startAttack():void
		{
			_selfAttackAction.configure();
			addAction(_selfAttackAction);
		}
		
		public function stopAttack():void
		{
			removeAction(_selfAttackAction);
		}
		
		override protected function getTotalHP():int
		{
			return selfScenePlayerInfo.totalHp;
		}
		
		override protected function getCurrentHP():int
		{
			return selfScenePlayerInfo.currentHp;
		}
		
		public function get selfScenePlayerInfo():SelfScenePlayerInfo
		{
			return _info as SelfScenePlayerInfo;
		}
		
		override public function setScenePos(x:Number, y:Number):void
		{
			super.setScenePos(x,y);
			var info:MapTemplateInfo = MapTemplateList.getMapTemplate(_mediator.sceneInfo.mapInfo.mapId);
//			if(info.checkIsInSafe(x,y))
//			{
//				if(selfScenePlayerInfo.isInSafe == false)QuickTips.show(LanguageManager.getWord("ssztl.scene.enterSafeArea"));
//				selfScenePlayerInfo.isInSafe = true;
//			}
//			else
//			{
//				if(selfScenePlayerInfo.isInSafe == true)QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveSafeArea"));
//				selfScenePlayerInfo.isInSafe = false;
//			}
		}
		
		private function taskAcceptHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			if(_taskSubmitEffect)
			{
				_taskSubmitEffect.removeEventListener(Event.COMPLETE,taskAcceptCompleteHandler);
				_taskSubmitEffect.dispose();
				_taskSubmitEffect = null;
			}
			
			if(!_taskAcceptEffect)
			{
				_taskAcceptEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TASK_ACCEPT_EFFECT));
				var w:int = CommonConfig.GAME_WIDTH >> 1;
				var h:int = Math.max( (CommonConfig.GAME_HEIGHT >> 1) - 200,200);
				_taskAcceptEffect.move(w,h);
				_taskAcceptEffect.addEventListener(Event.COMPLETE,taskAcceptCompleteHandler);
				_taskAcceptEffect.play(SourceClearType.NEVER);
				GlobalAPI.layerManager.getEffectLayer().addChild(_taskAcceptEffect);
//				addChild(_taskAcceptEffect);
			}
		}
		private function taskAcceptCompleteHandler(evt:Event):void
		{
			_taskAcceptEffect.removeEventListener(Event.COMPLETE,taskAcceptCompleteHandler);
			_taskAcceptEffect = null;
		}
		private function taskSubmitHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			if(_taskAcceptEffect)
			{
				_taskAcceptEffect.removeEventListener(Event.COMPLETE,taskAcceptCompleteHandler);
				_taskAcceptEffect.dispose();
				_taskAcceptEffect = null;
				
			}
			if(!_taskSubmitEffect)
			{
				_taskSubmitEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TASK_SUBMIT_EFFECT));
				var w:int = CommonConfig.GAME_WIDTH >> 1;
				var h:int = Math.max( (CommonConfig.GAME_HEIGHT >> 1) - 200,200);
				_taskSubmitEffect.move(w,h);
				_taskSubmitEffect.addEventListener(Event.COMPLETE,taskSubmitCompleteHandler);
				_taskSubmitEffect.play(SourceClearType.NEVER);
				GlobalAPI.layerManager.getEffectLayer().addChild(_taskSubmitEffect);
//				addChild(_taskSubmitEffect);
			}
		}
		private function taskSubmitCompleteHandler(evt:Event):void
		{
			_taskSubmitEffect.removeEventListener(Event.COMPLETE,taskSubmitCompleteHandler);
			_taskSubmitEffect = null;
		}
		
		private function collectUpdateHandler(evt:SelfScenePlayerInfoUpdateEvent):void
		{
//			if(selfScenePlayerInfo.info.getMounts())
//			{
//				_mediator.mountAvoid();
//			}
			var collect:int = selfScenePlayerInfo.getCollecting();
			if(collect == -1)
			{
				_collectAction.stopCollect();
//				removeAction(_collectAction);
				GlobalAPI.tickManager.removeTick(_collectAction);
				if(!MapTemplateList.getCanAutoCollect()) return;
				if(selfScenePlayerInfo.state.getCollect())
					WalkChecker.doWalkToCenterCollect(GlobalData.collectTarget);
			}
			else
			{
				_collectAction.configure(collect);
//				addAction(_collectAction);
				GlobalAPI.tickManager.addTick(_collectAction);
			}
		}
		
		private function stopCollectHandler(evt:SelfScenePlayerInfoUpdateEvent):void
		{
			_collectAction.stopCollect();
			GlobalAPI.tickManager.removeTick(_collectAction);
			
		}
		
		
		private function expUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			var old:int = int(evt.data);
			var current:int = GlobalData.selfPlayer.currentExp;
			if(current > old)
			{
//				var blood:BloodMovies = new BloodMovies(current - old,AttackTargetResultType.EXP);
//				blood.move(sceneX,sceneY);
//				this.scene.addEffect(blood);
			}
		}
		
		override protected function doSit():void
		{
			super.doSit();
			_sitBtns.x = sceneX;
			_sitBtns.y = sceneY + 12;
			if(this.scene)
			{
				this.scene.addControl(_sitBtns);
			}
		}
		override protected function unDoSit():void
		{
			super.unDoSit();
			if(_sitBtns && _sitBtns.parent)_sitBtns.parent.removeChild(_sitBtns);
		}
		
		override protected function upgradeHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			super.upgradeHandler(evt);
			shakeScene();
			SoundManager.instance.playSound(SoundManager.UPGRADE);
		}
		
		public function shakeScene():void
		{
			_mediator.shakeScene();
		}
		
		public function shakeScene1():void
		{
			_mediator.shakeScene1();
		}
		
		public function stopMoving():void
		{
			if(isMoving)
			{
				PlayerMoveSocketHandler.send([new Point(sceneX,sceneY)]);
				PlayerMoveStepSocketHandler.send(sceneX,sceneY,10000);
			}
			if(_info)
				_info.setStand();
//			moving = false;
			doCommonAction();
//			GlobalAPI.tickManager.removeTick(_walkAction);
//			_walkAction.walkStop();
			selfScenePlayerInfo.state.setFindPath(false);
		}
		
		override protected function doWalk():void
		{
			if(_isSit)_mediator.selfSit(false);
			super.doWalk();
		}
		
		override protected function moveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			super.moveHandler(evt);
			if(this.scene && _info)
			{
				this.scene.getViewPort().focusPoint = new Point(_info.sceneX,_info.sceneY);
				this.scene.mapData.dispatchRender();
			}
		}
		
		override public function dispose():void
		{
			if(_taskAcceptEffect)
			{
				_taskAcceptEffect.removeEventListener(Event.COMPLETE,taskAcceptCompleteHandler);
				_taskAcceptEffect.dispose();
				_taskAcceptEffect = null;
			}
			if(_taskSubmitEffect)
			{
				_taskSubmitEffect.removeEventListener(Event.COMPLETE,taskSubmitCompleteHandler);
				_taskSubmitEffect.dispose();
				_taskSubmitEffect = null;
			}
			if(_selfAttackAction)
			{
				GlobalAPI.tickManager.removeTick(_selfAttackAction);
				_selfAttackAction.dispose();
				_selfAttackAction = null;
			}
			if(_collectAction)
			{
				GlobalAPI.tickManager.removeTick(_collectAction);
				_collectAction.dispose();
				_collectAction = null;
			}
			if(_timeSitAction)
			{
				GlobalAPI.tickManager.removeTick(_timeSitAction);
				_timeSitAction.dispose();
				_timeSitAction = null;
			}
			if(_selfHangupSelectAction)
			{
				GlobalAPI.tickManager.removeTick(_selfHangupSelectAction);
				_selfHangupSelectAction.dispose();
				_selfHangupSelectAction = null;
			}
			if(_sitBtns)
			{
				_sitBtns.dispose();
				_sitBtns = null;
			}
			super.dispose();
			_mediator = null;
		}
	}
}