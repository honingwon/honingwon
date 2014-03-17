package sszt.scene.commands.activities
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import scene.events.BaseSceneObjectEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.data.titles.TitleNameEvents;
	import sszt.core.manager.SharedObjectManager;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.scene.IScene;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.events.SelfScenePlayerUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	
	public class PlayerListController extends EventDispatcher implements ITick
	{
		public static const SETSELF_COMPLETE:String = "setSelfComplete";
		
		private var _mediator:SceneMediator;
		
//		private var _playerList:Vector.<BaseScenePlayer>;
		private var _playerList:Array;
		private var _self:SelfScenePlayer;
		private var _scene:IScene;
		
		private var _waitingList:Array;
		
		public function PlayerListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_playerList = new Vector.<BaseScenePlayer>();
			_playerList = [];
			_waitingList = [];
			initPlayers();
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.UPDATE_PLAYER_NAME,updatePlayerNameHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.UPDATE_PLAYER_FIGURE,updatePlayerFigureHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.TARGET_CHANGE,targetChangeHandler);
			GlobalData.selfPlayer.addEventListener(TitleNameEvents.TITLE_NAME_UPDATE,updatePlayersTitleHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.UPDATE_PLAYER_NAME,updatePlayerNameHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.UPDATE_PLAYER_FIGURE,updatePlayerFigureHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.TARGET_CHANGE,targetChangeHandler);
			GlobalData.selfPlayer.removeEventListener(TitleNameEvents.TITLE_NAME_UPDATE,updatePlayersTitleHandler);
		}
		
		private function initPlayers():void
		{
			var list:Dictionary = _mediator.sceneInfo.playerList.getPlayers();
			for each(var i:BaseScenePlayerInfo in list)
			{
				addPlayer(i);
			}
		}
		
		public function update(timers:int,dt:Number = 0.04):void
		{
		}
		
		private function addPlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			addPlayer(evt.data as BaseScenePlayerInfo);
		}
		
		private function removePlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			removePlayer(evt.data as BaseScenePlayerInfo);
		}
		
		public function getSelf():SelfScenePlayer
		{
			return _self;
		}
		
		public function addPlayer(info:BaseScenePlayerInfo):void
		{
			var player:BaseScenePlayer;
			if(info.info.userId == GlobalData.selfPlayer.userId )//&& info.warState != 6
			{
				if(_self)
				{
					if(_self.getBaseRoleInfo())
					{
						_self.getBaseRoleInfo().state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
					}
				}
				_self = new SelfScenePlayer(info as SelfScenePlayerInfo,_mediator);
				player = _self;
				GlobalData.selfScenePlayerInfo = info;
				dispatchEvent(new Event(SETSELF_COMPLETE));
				_self.getBaseRoleInfo().state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
				GlobalData.selfScenePlayer = _self;
//				player.getCharacter().setFigureVisible(true);
				player.setFigureVisible(true);
				if(_mediator.sceneInfo.mapInfo.isShenmoDouScene() || _mediator.sceneInfo.mapInfo.isAcrossServer())
				{
					for(var i:int = 0; i < _playerList.length; i++)
					{
						var tmp:BaseScenePlayer = _playerList[i] as BaseScenePlayer;
						if(tmp)
						{
							if(tmp != _self)
							{
								if(_mediator.sceneInfo.mapInfo.isShenmoDouScene() && tmp.getScenePlayerInfo().warState == _self.getScenePlayerInfo().warState)
									tmp.setMouseAvoid(true);
								else if(MapTemplateList.isShenMoIsland() && tmp.getScenePlayerInfo().warState == 6)
								{
									tmp.setMouseAvoid(true);
								}
								else if(MapTemplateList.isCrystalWar() && tmp.getScenePlayerInfo().info.serverId == _self.getScenePlayerInfo().info.serverId)
								{
									tmp.setMouseAvoid(true);
								}
//								else if(_mediator.sceneInfo.mapInfo.isAcrossServer() && tmp.getScenePlayerInfo().info.serverId == _self.getScenePlayerInfo().info.serverId)
//									tmp.setMouseAvoid(true);
							}
						}
					}
				}
			}
			else
			{
				player = new BaseScenePlayer(info,_mediator);
				player.setFigureVisible(SharedObjectManager.hidePlayerCharacter.value != true);
//				player.getCharacter().setFigureVisible(SharedObjectManager.hidePlayerCharacter.value != true);
			}
			player.updatePlayerNick();
			_scene.addChild(player);
			_playerList.push(player);
//			player.addEventListener(MouseEvent.CLICK,playerClickHandler);
			player.addEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,playerClickHandler);
			if(_self)
			{
				if(_mediator.sceneInfo.mapInfo.isShenmoDouScene() && player != _self && player.getScenePlayerInfo().warState == _self.getScenePlayerInfo().warState)
				{
					player.setMouseAvoid(true);
				}
				else if(MapTemplateList.isShenMoIsland() && player != _self && player.getScenePlayerInfo().warState == 6)
				{
					player.setMouseAvoid(true);
				}
				else if(MapTemplateList.isCrystalWar() && player != _self && player.getScenePlayerInfo().info.serverId == _self.getScenePlayerInfo().info.serverId)
				{
					player.setMouseAvoid(true);
				}
				//目前无跨服战斗
//				if(_mediator.sceneInfo.mapInfo.isAcrossServer() && player != _self && player.getScenePlayerInfo().info.serverId == _self.getScenePlayerInfo().info.serverId)
//				{
//					player.setMouseAvoid(true);
//				}
			}
		}
		
		private function addToWait(info:BaseScenePlayerInfo):void
		{
			addPlayer(info);
		}
		
		/**
		 * 自己死亡
		 * @param evt
		 * 
		 */
		private function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			if(!_self || !_self.getBaseRoleInfo())return;
			if(_self.getBaseRoleInfo().getIsDead())
			{
				GlobalData.selfPlayer.scenePath = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathCallback = null;
				_self.stopMoving();
				if(_self.getBaseRoleInfo().getIsDead())_mediator.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWRELIVE);
				
				if(GlobalData.selfPlayer.level < 45)
					_mediator.sendNotification(SceneMediatorEvent.SHOW_DEATH_TIP);
			}
		}
		
		public function removePlayer(info:BaseScenePlayerInfo):void
		{
			var len:int = _playerList.length;			
			for(var i:int = 0; i < len; i++)
			{
				if(_playerList[i].getScenePlayerInfo() == info)
				{
					var character:BaseScenePlayer = _playerList.splice(i,1)[0];
					character.scene.removeChild(character);
					character.removeEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,playerClickHandler);
					character.dispose();
					break;
				}
			}
			var index:int = _waitingList.indexOf(info);
			if(index > -1)
			{
				_waitingList.splice(index,1);
			}
		}
		
		private function playerClickHandler(evt:BaseSceneObjectEvent):void
		{
//			evt.stopImmediatePropagation();
			var player:BaseScenePlayer = evt.currentTarget as BaseScenePlayer;
			if(!player || player is SelfScenePlayer)return;
//			if(player.getScenePlayerInfo().info.stallName != "")
//			{
//				_mediator.walkToStall(player.getBaseRoleInfo().getObjId(),new Point(player.sceneX,player.sceneY),_mediator.sceneInfo.getSceneId(),player.getBaseRoleInfo().getName());
//			}
//			else
//			{
				if(_mediator.sceneInfo.getCurrentSelect() != player.getBaseRoleInfo())
					_mediator.sceneInfo.setCurrentSelect(player.getScenePlayerInfo());
				else
				{
					if(_mediator.getCanAttackPlayer(player.getScenePlayerInfo()))_mediator.sceneInfo.playerList.self.setKillOne();
				}
//			}
		}
		
		public function setPlayerDir(id:Number,dir:int):void
		{
			var player:BaseScenePlayer;
			for each(var i:BaseScenePlayer in _playerList)
			{
				if(i.getBaseRoleInfo().getObjId() == id)
				{
					player = i;
					break;
				}
			}
			if(player == null)
			{
				var infoList:Dictionary = _mediator.sceneInfo.playerList.getPlayers();
				for each(var j:BaseScenePlayerInfo in infoList)
				{
					if(j.getObjId() == id)
					{
						j.dir = dir;
						break;
					}
				}
			}
			else
			{
				player.updateDir(dir);
			}
		}
		
		private function updatePlayerNameHandler(evt:SceneModuleEvent):void
		{
			updatePlayerName();
		}
		public function updatePlayerName():void
		{
			for each(var i:BaseScenePlayer in _playerList)
			{
				i.updatePlayerNick();
			}
		}
		
		private function updatePlayersTitleHandler(e:TitleNameEvents):void
		{
			for each(var i:BaseScenePlayer in _playerList)
			{
				i.updateTitleName();
			}
		}
		
		public function getPlayer(id:Number):BaseScenePlayer
		{
			for each(var i:BaseScenePlayer in _playerList)
			{
				if(i.getBaseRoleInfo().getObjId() == id)
					return i;
			}
			return null;
		}
		
		private function updatePlayerFigureHandler(evt:SceneModuleEvent):void
		{
			updatePlayerFigure();
		}
		public function updatePlayerFigure():void
		{
			for each(var i:BaseScenePlayer in _playerList)
			{
				if(!(i is SelfScenePlayer))
					i.setFigureVisible(SharedObjectManager.hidePlayerCharacter.value != true);
				else 
					i.setFigureVisible(true);
			}
		}
		
		private function targetChangeHandler(e:SceneModuleEvent):void
		{
			var list:Dictionary = _mediator.sceneInfo.playerList.getPlayers();
			var selectedList:Dictionary = _mediator.sceneInfo.playerList.selectedList;
			var p:Boolean = true;
			for each(var info:BaseScenePlayerInfo in list)
			{
				if(info.getObjId() == GlobalData.selfPlayer.userId)continue;
				if(selectedList[info.getObjId()] == null && _mediator.getCanAttackPlayer(info,false))
				{
					_mediator.sceneInfo.setCurrentSelect(info);
					_mediator.sceneInfo.playerList.addToSelected(info.getObjId());
					p = false;
					break;
				}
			}
			if(p)
			{
				_mediator.sceneInfo.playerList.clearSelected();
			}
		}
		
		public function clear():void
		{
			if(_self)
			{
				if(_self.getBaseRoleInfo())
				{
					_self.getBaseRoleInfo().state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
				}
				_self = null;
			}
			for each(var i:BaseScenePlayer in _playerList)
			{
				i.removeEventListener(MouseEvent.CLICK,playerClickHandler);
				i.dispose();
			}
			_playerList = [];
			_waitingList = [];
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}