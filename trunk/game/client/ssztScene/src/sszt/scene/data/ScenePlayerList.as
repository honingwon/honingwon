package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	
	public class ScenePlayerList extends EventDispatcher implements ITick
	{
		private var _playerList:Dictionary;
		private var _islandKingList:Dictionary;
		public var self:SelfScenePlayerInfo;
		private var _waitList:Array;
		private var _frameCount:int;
		/**
		 * 双修状态判定
		 */		
		public var doubleSits:Array;
		
		public var selectedList:Dictionary;
		
		public function ScenePlayerList()
		{
			_playerList = new Dictionary();
			_islandKingList = new Dictionary();
			selectedList = new Dictionary();
			doubleSits = [];
			_waitList = [];
			_frameCount = 0;
		}
		
		public function isDoubleSit():Boolean
		{
			return doubleSits.length == 2;
		}
		public function clearDoubleSit():void
		{
//			if(doubleSits.length > 0)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.scene.exitSitState"));
//			}
			doubleSits.length = 0;
			dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.DOUBLESIT_CHANGE));
		}
		public function setDoubleSit(id1:Number,id2:Number):void
		{
			doubleSits.length = 0;
			doubleSits.push(id1);
			doubleSits.push(id2);
			dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.DOUBLESIT_CHANGE));
		}
		public function isSitParner(id:Number):Boolean
		{
			return isDoubleSit() && (doubleSits[0] == id || doubleSits[1] == id) && id != GlobalData.selfPlayer.userId;
		}
		
		public function getPlayers():Dictionary
		{
			return _playerList;
		}
		
		public function getIslandKingsList():Dictionary
		{
			return _islandKingList;
		}
		
		public function getKingPlayer(id:Number):BaseScenePlayerInfo
		{
			return _islandKingList[id];
		}
		
		public function getPlayer(id:Number):BaseScenePlayerInfo
		{
			return _playerList[id];
		}
		public function getPlayerByNick(serverId:int,nick:String):BaseScenePlayerInfo
		{
			for each(var i:BaseScenePlayerInfo in _playerList)
			{
				if(i && i.info.serverId == serverId && i.info.nick == nick)return i;
			}
			return null;
		}
		
		public function addIslandKing(player:BaseScenePlayerInfo):void
		{
//			var count:int;
//			for each(var i:BaseScenePlayerInfo in _islandKingList)
//			{
//				count++;
//			}
//			if(count >= 3)return;
			_islandKingList[player.info.userId] = player;
			dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.ADDPLAYER,player));
		}
		
		public function removeIslandKing(id:Number):void
		{
			var t:BaseScenePlayerInfo = _islandKingList[id];
			if(t)
			{
				delete _islandKingList[id];
				dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.REMOVEPLAYER,t));
				t.sceneRemove();
			}
		}
		
		public function addPlayer(player:BaseScenePlayerInfo):void
		{
			_playerList[player.info.userId] = player;
			if(player.info.userId == GlobalData.selfPlayer.userId)
			{
				setSelf(player as SelfScenePlayerInfo);
				dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.ADDPLAYER,player));
			}
			else
			{
				_waitList.push(player);
			}
		}
		
		private function removeAPlayer():void
		{
			
		}
		
		private function setSelf(player:SelfScenePlayerInfo):void
		{
			self = player;
			dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.SETSELF_COMPLETE));
		}
		
		public function removePlayer(id:Number):void
		{
			var t:BaseScenePlayerInfo = _playerList[id];
			if(t)
			{
				delete _playerList[id];
				var n:int = _waitList.indexOf(t);
				if(n > -1)
				{
					_waitList.splice(n,1);
				}
				dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.REMOVEPLAYER,t));
				t.sceneRemove();
			}
			
			if(selectedList[id])delete selectedList[id];
		}
		
		public function addToSelected(id:Number):void
		{
			selectedList[id] = id;
		}
		
		public function clearSelected():void
		{
			for each(var j:Number in selectedList)
			{
				delete selectedList[j];
			}
		}
		
		public function removeOtherMapGrids(gridX:int,gridY:int,maxGridX:int,maxGridY:int):void
		{
			var startX:int = Math.max(gridX - 1,0);
			var endX:int = Math.min(gridX + 1,maxGridX);
			var startY:int = Math.max(gridY - 1,0);
			var endY:int = Math.min(gridY + 1,maxGridY);
			
			for each(var i:BaseScenePlayerInfo in _playerList)
			{
				if(i is SelfScenePlayerInfo)continue;
				var tmpX:int = int(i.sceneX / CommonConfig.MAP_9_GRID_WIDTH);
				var tmpY:int = int(i.sceneY / CommonConfig.MAP_9_GRID_HEIGHT);
				if(tmpX < startX || tmpX > endX || tmpY < startY || tmpY > endY)
				{
					removePlayer(i.info.userId);
				}
			}
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_frameCount ++;
			if(_frameCount == 2)
			{
				_frameCount = 0;
				if(_waitList.length > 0)
				{
					var player:BaseScenePlayerInfo = _waitList.shift() as BaseScenePlayerInfo;
					dispatchEvent(new ScenePlayerListUpdateEvent(ScenePlayerListUpdateEvent.ADDPLAYER,player));
				}
			}
		}
		
		public function clearKingList():void
		{
			for each(var m:BaseScenePlayerInfo in _islandKingList)
			{
				removeIslandKing(m.info.userId);
			}
		}
		
		public function clear():void
		{
			for each(var i:BaseScenePlayerInfo in _playerList)
			{
				removePlayer(i.info.userId);
//				if(i)
//				{
//					i.sceneRemove();
//					i.dispose();
//				}
//				delete _playerList[i.getObjId()];
			}
			clearKingList();
			for each(var j:Number in selectedList)
			{
				delete selectedList[j];
			}
			self = null;
			_waitList.length = 0;
		}
	}
}