package sszt.scene.data.roles
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemList;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.mediators.SceneMediator;
	
	public class BaseScenePetInfo extends BaseRoleInfo
	{
		protected var _id:Number;
		public var owner:Number;
		private var _templateId:int;
		private var _template:PetTemplateInfo;
		private var _follower:BaseRoleInfo;
		protected var _mediator:SceneMediator;
		private var _name:String;
		private var _styleId:int;
		private var _titleState:int;
		
		public function BaseScenePetInfo(mediator:SceneMediator,walkAction:CharacterWalkActionII)
		{
			_mediator = mediator;
			super(walkAction);
		}
		
		public function setObjId(id:Number):void
		{
			_id = id;
		}
		
		override public function getObjId():Number
		{
			return _id;
		}
		
		public function set templateId(value:int):void
		{
			_templateId = value;
		}
		public function get templateId():int
		{
			return _templateId;
		}
		
		public function set titleState(value:int):void
		{
			_titleState = value;
		}
		
		public function getIsQualityFirst():Boolean
		{
			return (_titleState & 2) > 0;
		}
		
		public function getIsQualitySecond():Boolean
		{
			return (_titleState & 4) > 0;
		}
		
		public function getIsQualityThird():Boolean
		{
			return (_titleState & 8) > 0;
		}
		
		public function getIsGrowFirst():Boolean
		{
			return (_titleState & 16) > 0;
		}
		
		public function getIsGrowSecond():Boolean
		{
			return (_titleState & 32) > 0;
		}
		
		public function getIsGrowThird():Boolean
		{
			return (_titleState & 64) > 0;
		}
		
		public function get template():PetTemplateInfo
		{
			if(_template == null)
				_template = PetTemplateList.getPet(_templateId) as PetTemplateInfo;
			return _template;
		}
		
		public function get styleId():int
		{
			return _styleId;
		}
		public function set styleId(value:int):void
		{
			if(_styleId == value)return;
			_styleId = value;
			dispatchEvent(new BaseScenePetInfoUpdateEvent(BaseScenePetInfoUpdateEvent.STYLE_UPDATE));
		}
		
		override public function getObjType():int
		{
			return MapElementType.PET;
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
			if(getDistance(target) > CommonConfig.PET_FOLLOW_MAXDISTANCE)
			{
				_mediator.petWalk(this,target,CommonConfig.PET_FOLLOW_DISTANCE,true);
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
		
		public function getOwner():BaseScenePlayerInfo
		{
			return _mediator.sceneInfo.playerList.getPlayer(owner);
		}
		
		public function getOwnerName():String
		{
			var player:BaseScenePlayerInfo = _mediator.sceneInfo.playerList.getPlayer(owner);
			if(player && player.info)
				return player.info.nick;
			return "";
		}
		
		public function getOwnerServerId():int
		{
			var player:BaseScenePlayerInfo = _mediator.sceneInfo.playerList.getPlayer(owner);
			if(player && player.info)
				return player.info.serverId;
			return 0;
		}
		
		override public function setName(name:String):void
		{
			if(_name == name)return;
			_name = name;
			dispatchEvent(new BaseScenePetInfoUpdateEvent(BaseScenePetInfoUpdateEvent.NAME_UPDATE));
			if(owner == GlobalData.selfPlayer.userId)
			{
				var petitem:PetItemInfo = GlobalData.petList.getPetById(_id);
				if(petitem)
					petitem.reName(_name);
			}
		}
		override public function getName():String
		{
			return _name;
		}
	}
}