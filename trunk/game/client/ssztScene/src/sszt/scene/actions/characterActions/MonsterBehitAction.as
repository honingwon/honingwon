package sszt.scene.actions.characterActions
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.ActionType;
	import sszt.constData.AttackTargetResultType;
	import sszt.constData.DirectType;
	import sszt.constData.SourceClearType;
	import sszt.core.action.BaseAction;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.characterActionInfos.SceneMonsterActionInfos;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.utils.Geometry;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.effects.BaseLoadEffectPool;
	import sszt.core.view.effects.BaseLoadMoveEffect;
	import sszt.scene.components.movies.BloodMovies;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.fight.AttackActionInfo;
	import sszt.scene.data.pools.ScenePoolManager;
		
	public class MonsterBehitAction extends CharacterBeHitAction
	{
		private var _behitEffect:BaseLoadEffect;
		private var _deadEffect:BaseLoadEffect;
//		private var _behitEffect:BaseLoadEffectPool;
//		private var _deadEffect:BaseLoadEffectPool;
		private var _isDead:Boolean = false;
		private var _removeFrames:int = 25;
		
		private var _deathFrames:int = 0;
		
		private var _canPlaydeath:uint = 0;
		
		
		public function MonsterBehitAction(info:AttackActionInfo)
		{
			_life = 25;
			super(info);
//			_deadTime = new Timer(1000,1);
		}
		
		override public function get canPlay():Boolean
		{
			return _playDelay <= 0;
		}
			
		
		override protected function doBeHit():void
		{
			super.doBeHit();
			
			if(_character && _character.scene)
			{
				var action:AttackActionInfo = getAttackInfo();
				
				if(!SharedObjectManager.hideSkillEffect.value)
				{
					if(_skill)
					{
						var movieInfo:MovieTemplateInfo = MovieTemplateList.getMovie(_skill.getBeAttackEffect(action.level)[0]);
						if(movieInfo)
						{
							_behitEffect = new BaseLoadEffect(movieInfo);
							_behitEffect.move(_character.sceneX,_character.sceneY);
							_behitEffect.play(SourceClearType.TIME,300000,4);
							_character.scene.addEffect(_behitEffect);
						}
					}
				}
				if(_character.getBaseRoleInfo().currentHp <= 0)
				{
					_character.getCharacter().doActionType(ActionType.DEAD);
					_isDead  = true;
					_life = _removeFrames;
				}
				
				if( (GlobalData.petList.getFightPet() && GlobalData.petList.getFightPet().id == action.actorId  && MapElementType.isPet(action.actorType))||
					(action.actorId == GlobalData.selfPlayer.userId && MapElementType.isPlayer(action.actorType)) || 
					(action.targetId == GlobalData.selfPlayer.userId && MapElementType.isPlayer(action.targetType)))
				{
					
					for each (var hp:int in action.dhp)
					{
						_character.bloodMovie([hp,action.attackResultType,false]);
					}
					if(action.dhp.length ==0)
					{
						_character.bloodMovie([0,action.attackResultType,false]);
					}
				}
			}
		}
		
//		protected function delayDeath():void{
//			_character.getBaseRoleInfo().walkComplete();
//			var angle:int = Geometry.getRadian( new Point(GlobalData.selfScenePlayer.sceneX,GlobalData.selfScenePlayer.sceneY),
//				new Point(_character.sceneX,_character.sceneY) );
//			var backAction:BaseCharacterAction = new MonsterBackAction(_actionInfo, angle,1);
//			_character.getBaseRoleInfo().addAction(backAction);
//			_character.getCharacter().doActionType(ActionType.DEAD);
//		}
		
		private function playDeadEffect():void
		{			
			if(!SharedObjectManager.hideSkillEffect.value)
			{
				if(_character && _character.scene)
				{
//					hitAway();
					_deadEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.DEAD_EFFECT));
					_deadEffect.move(_character.sceneX,_character.sceneY);
					_character.scene.addEffect(_deadEffect);
					_deadEffect.play(SourceClearType.TIME,300000,4);
				}
			}
		}
		
		private function hitAway():void
		{
			var dx:int,dy:int;
			switch(_character.dir)
			{
				case DirectType.BOTTOM:
					dy=-160;
					break;
				case DirectType.TOP:
					dy = 160;
					break;
				case DirectType.LEFT:
					dx = 160;
					break;
				case DirectType.RIGHT:
					dx = -160;
					break;
				case DirectType.RIGHT_BOTTOM:
					dx = -80;dy=-80;
					break;
				case DirectType.RIGHT_TOP:
					dx = -80;dy=80;
					break;
				case DirectType.LEFT_BOTTOM:
					dx = 80;dy=-80;
					break;
				case DirectType.LEFT_TOP:
					dx = 80;dy=80;
					break;		
			}
//			_character.walkComplete();
			_character.scene.move(_character,new Point(_character.sceneX+dx,_character.sceneY+dy));
		}
		
		public function dieHandler():void{
			if(_character && _character.scene)
			{
				(_character.scene.mapData as SceneInfo).monsterList.removeSceneMonster(_character.getBaseRoleInfo().getObjId());
				isFinished = true;
			}
		}
		
		
		override public function update(times:int,dt:Number=0.04):void
		{
			super.update(times,dt);	
			
			if(_isDead)
				_deathFrames = _deathFrames + times;
			
			if(_isDead && _canPlaydeath == 0)
			{
				playDeadEffect();
				_canPlaydeath = 1;
			}
			if(_canPlaydeath == 1 && _deathFrames >= 15)
			{
				_character.alpha -= 0.2 * times;
			}
			
			if( _character.alpha <= 0 || _deathFrames >= 20)
			{
				_canPlaydeath = 2;
				_character.alpha = 0;
				dieHandler();
			}
			
			
		}
		
		
		
		
		override public function dispose():void
		{
//			clearTimeout(_playdeathTimer);
//			clearTimeout(_lifeTimer);
			if(_character && _character.isMoving)
			{
				_character.getCharacter().doActionType(ActionType.WALK);
			}
			if(_canPlaydeath != 2 && _character && _character.getBaseRoleInfo() && _character.getBaseRoleInfo().currentHp <= 0)
			{
				dieHandler();
			}
			
//			if(_character && _character.scene && _character.getBaseRoleInfo().state.getDead())
//			{
//				(_character.scene.mapData as SceneInfo).monsterList.removeSceneMonster(_character.getBaseRoleInfo().getObjId());
//			}
			_character = null;
			if(_behitEffect)
			{
				_behitEffect = null;
			}
			if(_deadEffect)
			{
				_deadEffect = null;
			}
			super.dispose();
		}
	}
}