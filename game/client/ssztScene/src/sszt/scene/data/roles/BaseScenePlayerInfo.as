package sszt.scene.data.roles
{
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.events.ScenePlayerUpdateEvent;
	
	public class BaseScenePlayerInfo extends BaseRoleInfo
	{
		public var info:FigurePlayerInfo;
		/**
		 * 运镖剩余时间
		 */		
		public var inDarts:int;
		/**
		 * 运镖状态
		 */		
		public var isTransporting:Boolean;
		/**
		 *神魔乱斗状态 (0 没事，1仙，2魔, 3人   //3擂台战一方，4擂台战另一方，5泡温泉,6神魔岛雕像) 
		 */		
		public var warState:int;
		
		public var marryRelationType:int;
		public var marryNick:String;
		
		public function BaseScenePlayerInfo(info:FigurePlayerInfo,walkAction:CharacterWalkActionII)
		{
			this.info = info;
			super(walkAction);
		}
		
		override public function getName():String
		{
			return info.nick;
		}
		override public function getServerId():int
		{
			return info.serverId;
		}
		override public function getLevel():int
		{
			return info.level;
		}
		override public function getObjType():int
		{
			return MapElementType.PLAYER;
		}
		override public function getObjId():Number
		{
			return info.userId;
		}
		override public function getCareer():int
		{
			return info.career;
		}
		override public function getSex():Boolean
		{
			return info.sex;
		}
		
		
		public function doUpgrade(level:int,argTotalHP:int,argTotalMP:int,argCurrentHP:int,argCurrentMP:int):void
		{
			info.level = level;
			totalHp = argTotalHP;
			totalMp = argCurrentMP;
			currentHp = argCurrentHP;
			currentMp = argCurrentMP;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.UPGRADE));
		}
		
		public function setInDarts(value:int):void
		{
			if(inDarts == value)return;
			inDarts = value;
			if(inDarts > 0)setTransportState(true);
			else setTransportState(false);
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.INDARTS_UPDATE));
		}
		
		public function setTransportState(value:Boolean):void
		{
			if(isTransporting == value)return;
			isTransporting = value;
			dispatchEvent(new BaseRoleInfoUpdateEvent(BaseRoleInfoUpdateEvent.TRANSPORT_UPDATE));
		}
		
		override public function clearAttackState(isForce:Boolean=false):void
		{
			super.clearAttackState(isForce);
		}
		
		public function get isSit():Boolean
		{
			if(!info)return false;
			return info.isSit();
		}
		public function setSit(value:Boolean):void
		{
			if(!info)return;
			info.setSit(value);
		}
		public function setLifexpSit(value:Boolean):void
		{
			if(!info)return;
			info.updateLifexpSitState(value);
		}
		public function get isMount():Boolean
		{
			if(!info)return false;
			return info.getMounts();
		}
		public function get fightMounts():Boolean
		{
			if(!info)return false;
			return info.fightMounts;
		}
	}
}