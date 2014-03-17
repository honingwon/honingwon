package sszt.scene.data.roles
{
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CarInfo;
	import sszt.core.data.MapElementType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.mediators.SceneMediator;
	
	public class BaseSceneCarInfo extends BaseRoleInfo
	{
		public var carInfo:CarInfo;
		protected var _id:Number;
		public var owner:Number;
		public var name:String;
		public var quality:int;
		private var _follower:BaseRoleInfo;
		private var _mediator:SceneMediator;
		
		public function BaseSceneCarInfo(mediator:SceneMediator,walkAction:CharacterWalkActionII)
		{
			_mediator = mediator;
			super(walkAction);
			carInfo = new CarInfo();
		}
		
		public function setObjId(id:Number):void
		{
			_id = id;
		}
		
		override public function getObjId():Number
		{
			return _id;
		}
		
		override public function getObjType():int
		{
			return MapElementType.CAR;
		}
		
		public function setFollower(follower:BaseRoleInfo):void
		{
			if(_follower)
			{
				_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,followerRemoveHandler);
				_follower.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,followerMoveHandler);
			}
			_follower = follower;
			if(_follower)
			{
				_follower.addEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,followerRemoveHandler);
				_follower.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,followerMoveHandler);
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
			if(getDistance(target) > CommonConfig.CAR_FOLLOW_MAXDISTANCE)
			{
//				_mediator.petWalk(this,target,CommonConfig.CAR_FOLLOW_DISTANCE,true);
				_mediator.carWalk(this,target,CommonConfig.CAR_FOLLOW_DISTANCE,true);
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
	}
}