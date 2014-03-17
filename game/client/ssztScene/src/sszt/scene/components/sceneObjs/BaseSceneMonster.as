package sszt.scene.components.sceneObjs
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.ActionType;
	import sszt.constData.DirectType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.MapElementType;
	import sszt.core.data.characterActionInfos.SceneMonsterActionInfos;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.character.ICharacter;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.mediators.SceneMediator;

	public class BaseSceneMonster extends BaseRole
	{
		private var _timeoutIndex:int;
		private var _mediator:SceneMediator;
		private var _bossEffect:BaseLoadEffect;
		
		
		public function BaseSceneMonster(mediator:SceneMediator,info:BaseSceneMonsterInfo)
		{
			super(info);
			_mediator = mediator;
			_timeoutIndex = setTimeout(checkDead,200);
		}
		
		//检测如果怪物死了，清掉怪物，（有可能怪物数据死的时候，由于视图没有实例化而没有删掉怪）
		private function checkDead():void
		{
			if(getBaseRoleInfo() && getBaseRoleInfo().currentHp <= 0 && this.scene)
			{
				(this.scene.mapData as SceneInfo).monsterList.removeSceneMonster(getBaseRoleInfo().getObjId());
			}
			if (this._timeoutIndex != 0)
			{
				clearTimeout(this._timeoutIndex);
				_timeoutIndex = 0;
			}
			
		}
		
		override protected function init():void
		{
			super.init();
			mouseChildren = mouseEnabled = tabChildren = tabEnabled = false;
			nick.htmlText = "<font color='#FFFFFF'>" + getSceneMonsterInfo().template.name + "</font>";
			nick.y = titleY - 20;
			bloodBar.move(-30,nick.y + 10);
		}
		
		public function getSceneMonsterInfo():BaseSceneMonsterInfo
		{
			return _info as BaseSceneMonsterInfo;
		}
		
		override public function get titleY():Number
		{
			return -getSceneMonsterInfo().template.getPicHeight();
		}
		
		override protected function initCharacter():void
		{
			var tid:int = getSceneMonsterInfo().templateId;
			var picpath:int = int(getSceneMonsterInfo().template.picPath);
//			if(int(tid / 1000) == 100)
//			{
//				_character = GlobalAPI.characterManager.createSceneNpcCharacter(NpcTemplateList.getNpc(picpath));
//			}
//			else
//			{
			_character = GlobalAPI.characterManager.createSceneMonsterCharacter(getSceneMonsterInfo().template);
//			}
			_character.addEventListener(Event.COMPLETE,characterCompleteHandler);
			_character.show(DirectType.getRandomDir());
//			if(getSceneMonsterInfo().template.picWidth == 380)
//				_character.move(-185,-230);
//			else _character.move(-235,-320);
			
			addChild(_character as DisplayObject);
			if(_info.getObjType() == MapElementType.BOSS)
			{
				createBossEffect();
			}
			
			nick.y = -120;
		}
		private function characterCompleteHandler(evt:Event):void
		{
//			nick.y = -_character.height - 20;
			nick.y = titleY - 20;
			if(bloodBar)
				bloodBar.move(-30,nick.y + 10);
			_character.removeEventListener(Event.COMPLETE,characterCompleteHandler);
			swapChildrenAt(getChildIndex(nick),numChildren - 1);
		}
		
		override protected function walkStartHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			super.walkStartHandler(evt);
			doWalkAction();
		}
		
		override public function doWalkAction():void
		{
			if(_character.currentAction && _character.currentAction.actionType != ActionType.WALK)
				_character.doActionType(ActionType.WALK);
		}
		
		public function shakeScene():void
		{
			_mediator.shakeScene();
		}
		
		override protected function walkComplete():void
		{
			super.walkComplete();
			_character.doActionType(ActionType.STAND);
		}
		
		override protected function getTotalHP():int
		{
			return getSceneMonsterInfo().totalHp;
		}
		
		override protected function getCurrentHP():int
		{
			return getSceneMonsterInfo().currentHp;
		}
		
		override public function showHpBar():void
		{
			if(bloodBar.parent == null)
			{
				addChild(bloodBar);
				nick.htmlText = "<font color='#f4872b'>" + getSceneMonsterInfo().template.name + "</font>";
				nick.y -= 15;
			}
		}
		
		override public function hideHpBar():void
		{
			if(bloodBar && bloodBar.parent)
			{
				bloodBar.parent.removeChild(bloodBar);
				nick.htmlText = "<font color='#FFFFFF'>" + getSceneMonsterInfo().template.name + "</font>";
				nick.y += 15;
			}
		}
		
		private function createBossEffect():void
		{
			if(_bossEffect == null)
			{
				_bossEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.BOSS_EFFECT));
			}
			_bossEffect.play(SourceClearType.NEVER);
			_bossEffect.move(0,0);
			addChildAt(_bossEffect,0);
		}
		
		private function clearBossEffect():void
		{
			if(_bossEffect)
			{
				_bossEffect.stop();
				if(_bossEffect.parent)_bossEffect.parent.removeChild(_bossEffect);
			}
		}
		
		override public function dispose():void
		{
			if(_character)
				_character.removeEventListener(Event.COMPLETE,characterCompleteHandler);
			
			if(_bossEffect)
			{
				_bossEffect.dispose();
				_bossEffect = null;
			}
			if(_timeoutIndex != 0)
			{
				clearTimeout(_timeoutIndex);
			}
			super.dispose();
			_mediator = null;
		}
	}
}