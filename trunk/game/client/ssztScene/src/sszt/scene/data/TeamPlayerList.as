package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	
	public class TeamPlayerList extends EventDispatcher
	{		
		public var autoInTeam:Boolean = false;
		public var allocationValue:int = 0;
		
//		private var _playerList:Vector.<TeamScenePlayerInfo>;
		private var _playerList:Array;
		public var leader:TeamScenePlayerInfo;
		public var self:TeamScenePlayerInfo;
		private var _leadId:Number;
		
		public function TeamPlayerList()
		{
			_leadId = 0;
//			_playerList = new Vector.<TeamScenePlayerInfo>();
			_playerList = [];
		}
		
		public function addPlayer(player:TeamScenePlayerInfo):void
		{
			_playerList.push(player);
			if(player.getObjId() == GlobalData.selfPlayer.userId) self = player;
			if(player.getObjId() == _leadId)leader = player;
			dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.ADDPlAYER,player));
		}
		
//		public function get teamPlayers():Vector.<TeamScenePlayerInfo>
		public function get teamPlayers():Array
		{
			return _playerList;
		}
		
		public function getPlayer(id:Number):TeamScenePlayerInfo
		{
			for each(var i:TeamScenePlayerInfo in _playerList)
			{
				if(i.getObjId() == id)
					return i;
			}
			return null;
		}
		
		public function updatePartnerPosition(id:Number,MapID:int,x:int,y:int):void
		{
			var partner:TeamScenePlayerInfo = getPlayer(id);
			if(partner)
			{
				partner.mapID = MapID;
				partner.mapX = x;
				partner.mapY = y;
			}
			dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.UPDATE_PARTNER_POSITION));
		}
		
		public function removePlayer(id:Number):void
		{
			for(var i:int = _playerList.length - 1; i >= 0; i--)
			{
				if(_playerList[i].getObjId() == id)
				{
					var player:TeamScenePlayerInfo = _playerList.splice(i,1)[0];
					if(player == self)self = null;
					dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,player));
					break;
				}
			}
			if(_playerList.length == 0)
				dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.DISBAND));
		}
		
		public function setLeader(id:Number):void
		{
			if(_leadId == id) return;
			_leadId = id;
			GlobalData.leaderId = id;
			dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.CHANGELEADER,id));
		}
		/**
		 * 是否排在自己前面一个位的玩家
		 * @return 
		 * 
		 */		
		public function isPrePlayer(id:Number):Boolean
		{
			var player:TeamScenePlayerInfo = getPlayer(id);
			if(player && player.teamPos == self.teamPos - 1)return true;
			return false;
		}
		
		public function get leadId():Number
		{
			return  _leadId;
		}
		
		/**
		 * 设置队伍远离状态
		 * 
		 */		
		public function setNearBy(value:Boolean):void
		{
			for each(var player:TeamScenePlayerInfo in _playerList)
			{
				player.isNearby = value;
			}
		}
		/**
		 * 自己离队时清除 
		 * 
		 */		
		public function teamDisband():void
		{
			var len:int = _playerList.length;
			for(var i:int =0;i<len;i++)
			{
				removePlayer(_playerList[0].getObjId());
			}
			autoInTeam = true;
			setLeader(0);
		}
		
		/**
		 *检测队伍状态是否可以进入副本 
		 * @param copy
		 * @return 
		 * 
		 */		
		public function canEnterCopy(copy:CopyTemplateItem):Boolean
		{
			var result:Boolean = true;
			for(var i:int = 0;i<_playerList.length;i++)
			{
				var level:int = (_playerList[i] as TeamScenePlayerInfo).getLevel();
				if(level < copy.minLevel || level >copy.maxLevel)
				{
					result = false;
					break;
				}
			}
			return result;
		}
		
		/**
		 *获取队伍平均等级 
		 */
		public function getAverageLevel():int
		{
			if(_leadId == 0) return GlobalData.selfPlayer.userId;
			var total:int = 0;
			for(var i:int = 0;i<_playerList.length;i++)
			{
				total = total + (_playerList[i] as TeamScenePlayerInfo).getLevel();
			}
			return total/i;
		}
	}
}