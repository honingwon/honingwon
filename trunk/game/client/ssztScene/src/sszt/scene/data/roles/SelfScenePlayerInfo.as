package sszt.scene.data.roles
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SceneConfig;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.data.HangupData;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.mediators.SceneMediator;
	
	public class SelfScenePlayerInfo extends BaseScenePlayerInfo
	{
		/**
		 * 跟随者
		 */		
		private var _follower:BaseRoleInfo;
		private var _mediator:SceneMediator;
		private var _collectint:int;
		
		public function SelfScenePlayerInfo(info:FigurePlayerInfo,mediator:SceneMediator,walkAction:CharacterWalkActionII)
		{
			_mediator = mediator;
			_collectint = -1;
			super(info,walkAction);
		}
		
		override public function getObjType():int
		{
			return MapElementType.SELF_PLAYER;
		}
		
		/**************挂机处理********************************/
		public function clearHangup():void
		{
			state.setNotAttack(true);
		}
		public function setKillOne():void
		{
			state.setKillOne(true);
 		}
		public function setHangupState():void
		{
			state.setHangup(true);
		}
		public function setHangupPickup():void
		{
			state.setPickUp(true);
		}
		
		public function setCollectState():void
		{
			state.setCollect(true);
		}
		
		public function getIsHangupAttack():Boolean
		{
			return state.getHangup();
		}
		public function getIsPick():Boolean
		{
			return state.getPickUp();
		}
		public function getIsHangup():Boolean
		{
			return state.getHangup() || state.getPickUp();
		}
		public function getIsKillOne():Boolean
		{
			return state.getKillOne();
		}
		public function getIsNotAttack():Boolean
		{
			return state.getNotAttack();
		}
		public function getIsFindPath():Boolean
		{
			return state.getFindPath();
		}
		/**********************************************/
		
//		override public function setDeadState():void
//		{
//			if(!_mediator.sceneInfo.hangupData.autoRelive || GlobalData.selfPlayer.getVipType() != VipType.BESTVIP)
//			{
//				clearHangup();
//			}
//			super.setDeadState();
//		}
		
		override public function setAttackState(value:int):void
		{
			super.setAttackState(value);
			if(getIsDead())
			{
				if(!_mediator.sceneInfo.hangupData.autoRelive || GlobalData.selfPlayer.getVipType() != VipType.BESTVIP)
				{
					clearHangup();
				}
			}
		}
		
		public function setFollower(role:BaseRoleInfo):void
		{
			if(_follower)
			{
				_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,followerRemoveHandler);
				_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,followerMoveHandler);
			}
			_follower = role;
			if(_follower)
			{
				_follower.addEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,followerRemoveHandler);
				_follower.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,followerMoveHandler);
				followerMoveHandler(null);
			}
		}
		
		private function followerRemoveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,followerRemoveHandler);
			_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,followerMoveHandler);
		}
		
		private function followerMoveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			var target:Point = new Point(_follower.sceneX,_follower.sceneY);
			if(getDistance(target) > CommonConfig.TEAM_FOLLOW_MAXDISTANCE)
			{
				_mediator.walk(_mediator.sceneInfo.getSceneId(),target,null,CommonConfig.TEAM_FOLLOW_DISTANCE,true,false);
			}
		}
		
		override public function sceneRemove():void
		{
			if(_follower)
			{
				_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,followerRemoveHandler);
				_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,followerMoveHandler);
				_follower = null;
			}
			_mediator = null;
			super.sceneRemove();
		}
		
		override public function set currentHp(value:int):void
		{
			super.currentHp = value;
			GlobalData.selfPlayer.updateHPMP(value,GlobalData.selfPlayer.currentMP);
		}
		override public function set currentMp(value:int):void
		{
			super.currentMp = value;
			GlobalData.selfPlayer.updateHPMP(GlobalData.selfPlayer.currentHP,value);
		}
		
		public function setCollecting(value:int,dispatch:Boolean=true):void
		{
			if(_collectint == value)return;
			_collectint = value;
			if(dispatch)
				dispatchEvent(new SelfScenePlayerInfoUpdateEvent(SelfScenePlayerInfoUpdateEvent.COLLECT_UPDATE,_collectint));
		}
		public function getCollecting():int
		{
			return _collectint;
		}
		
		public function stopCollecting():void
		{
			setCollecting(-1,false);
			dispatchEvent(new SelfScenePlayerInfoUpdateEvent(SelfScenePlayerInfoUpdateEvent.STOP_COLLECT,_collectint));
		}
		
		override public function setScenePos(x:Number, y:Number):void
		{
			if(!_mediator)return;
			if(GlobalData.copyEnterCountList.isRemoveOther())
			{
				var currentGridX:int = int(sceneX / SceneConfig.BROST_WIDTH);
				var currentGridY:int = int(sceneY / SceneConfig.BROST_HEIGHT);
				var nextGridX:int = int(x / SceneConfig.BROST_WIDTH);
				var nextGridY:int = int(y / SceneConfig.BROST_HEIGHT);
				if(currentGridX != nextGridX || currentGridY != nextGridY)
				{
					var sceneInfo:SceneInfo = _mediator.sceneInfo;
//					//删除怪
//					sceneInfo.monsterList.removeOutBrostMonster(nextGridX,nextGridY,sceneInfo.mapInfo.maxServerGridCountX,sceneInfo.mapInfo.maxServerGridCountY);
					//删除掉落和采集物
					sceneInfo.dropItemList.removeOutBrostItem(nextGridX,nextGridY,sceneInfo.mapInfo.maxServerGridCountX,sceneInfo.mapInfo.maxServerGridCountY);
					sceneInfo.collectList.removeOutBrostItem(nextGridX,nextGridY,sceneInfo.mapInfo.maxServerGridCountX,sceneInfo.mapInfo.maxServerGridCountY);
				}
			}
			super.setScenePos(x,y);
		}
	}
}