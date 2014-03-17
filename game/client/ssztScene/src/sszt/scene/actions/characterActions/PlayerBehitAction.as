package sszt.scene.actions.characterActions
{
	import sszt.constData.ActionType;
	import sszt.constData.AttackTargetResultType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.effects.BaseLoadEffectPool;
	import sszt.scene.components.movies.BloodMovies;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.data.fight.AttackActionInfo;
	import sszt.scene.data.pools.ScenePoolManager;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneMediator;
	
	public class PlayerBehitAction extends CharacterBeHitAction
	{
//		private var _beattackEffect:BaseEffect;
//		private var _behitEffect:BaseLoadEffectPool;
		private var _behitEffect:BaseLoadEffect;
		
		public function PlayerBehitAction(info:AttackActionInfo)
		{
			_life = 15;
			super(info);
		}
		
		override protected function doBeHit():void
		{
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
//							_behitEffect = CommonEffectPoolManager.baseLoaderEffectManager.getObj([movieInfo]) as BaseLoadEffectPool;
							_behitEffect = new BaseLoadEffect(movieInfo);
							_behitEffect.move(_character.sceneX,_character.sceneY);
							_behitEffect.play(SourceClearType.TIME,300000,4);
							_character.scene.addEffect(_behitEffect);
						}
					}
				}
				var scenePlayerInfo:BaseScenePlayerInfo = (_character as BaseScenePlayer).getScenePlayerInfo();
				if(scenePlayerInfo)
				{
					if(scenePlayerInfo.getIsDead())
					{
						_character.getCharacter().doActionType(ActionType.DEAD);
					}
					else if(scenePlayerInfo.getIsDizzy())
					{
						_character.getCharacter().doActionType(ActionType.DIZZY);
					}
					else if(!scenePlayerInfo.info.getMounts())
					{
						if(scenePlayerInfo.currentHp <= 0)
						{
							_character.getCharacter().doActionType(ActionType.DEAD);
						}
						else
						{
//							if(_skill.isAttack())
//								_character.getCharacter().doActionType(ActionType.BEHIT);
						}
					}
				}
				var hp:int;
				if(action.actorId == GlobalData.selfPlayer.userId && MapElementType.isPlayer(action.actorType))
				{
					for each (hp in action.dhp)
					{
						_character.bloodMovie([hp,action.attackResultType,false]);
					}
				}
				else if(action.targetId == GlobalData.selfPlayer.userId && MapElementType.isPlayer(action.targetType))
				{
					for each (hp in action.dhp)
					{
						_character.bloodMovie([hp,action.attackResultType,true]);
					}
				}
				
				if(scenePlayerInfo.currentHp <= 0)
				{
					for each (hp in action.dhp)
					{
						_character.bloodMovie([hp,action.attackResultType,false]);
					}
//					blood2.move(_character.sceneX,_character.sceneY - 30);
//					_character.scene.addEffect(blood2);
				}
				if(action.dhp.length ==0)
				{
					_character.bloodMovie([0,action.attackResultType,false]);
				}
			}
		}
		
		override public function dispose():void
		{
			if(_character.isMoving)
			{
				_character.getCharacter().doActionType(ActionType.WALK);
			}
			if(_behitEffect)
			{
				_behitEffect = null;
			}
			super.dispose();
		}
	}
}