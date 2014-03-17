package sszt.scene.commands.activities
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SharedObjectManager;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.scene.IScene;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.sceneObjs.BaseSceneMonster;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerAttackSocketHandler;
	
	import scene.events.BaseSceneObjectEvent;

	public class MonsterListController
	{
		private var _mediator:SceneMediator;
		
//		private var _monsterList:Vector.<BaseSceneMonster>;
		private var _monsterList:Array;
		private var _scene:IScene;
		private var _lastClick:Number;
		private var _voidResponseMouse:Array;
		private var _doubleSitAlert:MAlert;
		
		public function MonsterListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_monsterList = new Vector.<BaseSceneMonster>();
			_voidResponseMouse = [];
			_monsterList = [];
			initMonsters();
		}
		
		private function initMonsters():void
		{
			var list:Dictionary = _mediator.sceneInfo.monsterList.getMonsters();
			for each(var i:BaseSceneMonsterInfo in list)
			{
				addMonster(i);
			}
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER,addMonsterHandler);
			_mediator.sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER,removeMonsterHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.UPDATE_MONSTER_FIGURE,updateMonsterFigureHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER,addMonsterHandler);
			_mediator.sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER,removeMonsterHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.UPDATE_MONSTER_FIGURE,updateMonsterFigureHandler);
		}
		
		private function addMonsterHandler(evt:SceneMonsterListUpdateEvent):void
		{
			addMonster(evt.data as BaseSceneMonsterInfo);
		}
		
		private function addMonster(info:BaseSceneMonsterInfo):void
		{
			var monster:BaseSceneMonster = new BaseSceneMonster(_mediator,info);
			_scene.addChild(monster);
			_monsterList.push(monster);
			monster.getCharacter().setFigureVisible(SharedObjectManager.hideMonsterCharacter.value != true);
//			monster.addEventListener(MouseEvent.CLICK,monsterClickHandler);
			if(_voidResponseMouse.indexOf(info.getObjId()) > -1)
			{
				monster.setMouseAvoid(true);
			}
			else
			{
				monster.addEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,monsterClickHandler);
			}
		}
		
		public function getMonster(id:int):BaseSceneMonster
		{
			for each(var i:BaseSceneMonster in _monsterList)
			{
				if(i.getBaseRoleInfo() && i.getBaseRoleInfo().getObjId() == id)
				{
					return i;
				}
			}
			return null;
		}
		
		private function removeMonsterHandler(evt:SceneMonsterListUpdateEvent):void
		{
			var info:BaseSceneMonsterInfo = evt.data as BaseSceneMonsterInfo;
			var len:int = _monsterList.length;
			for(var i:int = 0; i < len; i++)
			{
				if(_monsterList[i].getSceneMonsterInfo() == info)
				{
					var monster:BaseSceneMonster = _monsterList.splice(i,1)[0];
					monster.removeEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,monsterClickHandler);
					monster.dispose();
					break;
				}
			}
		}
		
		private function monsterClickHandler(evt:BaseSceneObjectEvent):void
		{
//			evt.stopImmediatePropagation();
			if(_mediator.sceneInfo.playerList.isDoubleSit() && _doubleSitAlert == null)
			{
				_doubleSitAlert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,stopDoubleSit);
			}
			else
			{
				doKillMonster();
			}
			function stopDoubleSit(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sceneInfo.playerList.clearDoubleSit();
					doKillMonster();
				}
				_doubleSitAlert = null;
			}
			function doKillMonster():void
			{
				var t:Number = getTimer();
				if(t - _lastClick < 500)return;
				_lastClick = t;
				var monster:BaseSceneMonster = evt.currentTarget as BaseSceneMonster;
//				if(!monster.isMouseSelect)return;
				_mediator.sceneInfo.setCurrentSelect(monster.getSceneMonsterInfo());
				_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
				//挂机时点怪不停止挂机
				if(_mediator.sceneInfo.playerList.self.getIsPick())
					_mediator.sceneInfo.playerList.self.setHangupState();
				else if(!_mediator.sceneInfo.playerList.self.getIsHangupAttack())
					_mediator.sceneInfo.playerList.self.setKillOne();
//				if(PlayerHangupType.isHangupPickup(_mediator.sceneInfo.playerList.self.hangupState))
//					_mediator.sceneInfo.playerList.self.setHangupState();
//				else if(!PlayerHangupType.isHangupAttack(_mediator.sceneInfo.playerList.self.hangupState))
//					_mediator.sceneInfo.playerList.self.setHangupOne();
//				_mediator.sceneInfo.playerList.self.attackBack();
			}
		}
		
		public function setMonsterMouseAvoid(id:int,value:Boolean):void
		{
			var monster:BaseSceneMonster = getMonster(id);
			if(!value)
			{
				//响应鼠标事件
				var tn:int = _voidResponseMouse.indexOf(id);
				if(tn > -1)
				{
					_voidResponseMouse.splice(tn,1);
				}
				if(monster)
				{
					monster.setMouseAvoid(false);
				}
			}
			else
			{
				//屏蔽鼠标事件
				var n:int = _voidResponseMouse.indexOf(id);
				if(n == -1)
				{
					_voidResponseMouse.push(id);
				}
				if(monster)
				{
					monster.setMouseAvoid(true);
				}
			}
		}
		
		private function updateMonsterFigureHandler(evt:SceneModuleEvent):void
		{
			for each(var i:BaseSceneMonster in _monsterList)
			{
				i.getCharacter().setFigureVisible(SharedObjectManager.hideMonsterCharacter.value != true);
			}
		}
		
		public function clear():void
		{
			for each(var i:BaseSceneMonster in _monsterList)
			{
				i.removeEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,monsterClickHandler);
				i.dispose();
			}
			_monsterList = [];
		}
		
		public function dispose():void
		{
			removeEvent();
		}

//		public function get voidResponseMouse():Array
//		{
//			return _voidResponseMouse;
//		}
		public function clearVoidResponseMouseList():void
		{
			_voidResponseMouse.length = 0;
		}
	}
}