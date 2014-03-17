package sszt.scene.data.roles
{
	import sszt.core.data.MapElementType;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	
	public class TeamScenePlayerInfo extends BaseRoleInfo
	{
		private var _serverId:int;
		private var _id:Number;
		private var _name:String;
		private var _level:int;
		/**
		 * 队伍位置，-1表示不存在
		 */		
		public var teamPos:int;
		public var sex:Boolean;
		public var career:int;
		public var cloth:int;
		public var weapon:int;
		public var mount:int;
		public var wing:int;
		public var strengthLevel:int;
		public var mountsStrengthLevel:int;
		public var hideWeapon:Boolean;
		public var hideSuit:Boolean;
		public var mapX:int;
		public var mapY:int;
		public var mapID:int;
		/**
		 * 是否在附近
		 */		
		private var _isNearby:Boolean;
		
		public function TeamScenePlayerInfo()
		{
			super(null);
		}
		
		public function setObjId(value:Number):void
		{
			_id = value;
		}
		
		override public function getObjId():Number
		{
			return _id;
		}
		
		public function setServerId(value:int):void
		{
			_serverId = value; 
		}
		override public function getServerId():int
		{
			return _serverId;
		}
		
		override public function setName(value:String):void
		{
			_name = value;
		}
		override public function getName():String
		{
			return _name;
		}
		
		public function setLevel(value:int):void
		{
			_level = value;
			dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_LEVEL));
		}		
		override public function getLevel():int
		{
			return _level;
		}
		
		override public function getObjType():int
		{
			return MapElementType.PLAYER;
		}
		
		override public function getCareer():int
		{
			return career;
		}
		
		public function get isNearby():Boolean
		{
			return _isNearby;
		}
		public function set isNearby(value:Boolean):void
		{
			if(_isNearby == value)return;
			_isNearby = value;
			dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_STATE));
		}
		
//		public function updateStyle(style:Vector.<int>):void
		public function updateStyle(style:Array):void
		{
			cloth = style[0];
			weapon = style[1];
			mount = style[2];
			wing = style[3];
			dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.UPDATE_PLAYER_STYLE));
		}
	}
}