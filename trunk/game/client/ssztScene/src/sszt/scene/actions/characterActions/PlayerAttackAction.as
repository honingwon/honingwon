package sszt.scene.actions.characterActions
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import sszt.constData.ActionType;
	import sszt.constData.DirectType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.core.data.characterActionInfos.SceneMonsterActionInfos;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.utils.Geometry;
	import sszt.core.utils.RotateUtils;
	import sszt.core.view.effects.BaseCountEffect;
	import sszt.core.view.effects.BaseCountEffectPool;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.effects.BaseLoadEffectPool;
	import sszt.core.view.effects.BaseLoadMoveEffect;
	import sszt.core.view.effects.BaseLoadMoveEffectPool;
	import sszt.core.view.effects.IEffect;
	import sszt.interfaces.character.ICharacter;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.fight.AttackActionInfo;
	
	public class PlayerAttackAction extends CharacterAttackAction
	{
		private var _effectPackage:Sprite;
		private var _attackEffect:BaseLoadEffect;
//		private var _attackEffect:BaseLoadEffectPool;
		private var _completeEffect:IEffect;
		private var _actionEffect:BaseLoadEffect;
//		private var _actionEffect:BaseLoadEffectPool;
		
		public function PlayerAttackAction(info:AttackActionInfo)
		{
			super(info);
			_life = 15;
		}
		
		override public function doAction():void
		{
			super.doAction();
			
			if(_character && _character.scene )
			{
				var action:AttackActionInfo = getAttackActionInfo();
				var selfPoint:Point = new Point(_character.sceneX,_character.sceneY);
				var target:Point = new Point(action.targetX,action.targetY);
				if(!selfPoint.equals(target))
				{
					var dir:int = DirectType.checkDir(selfPoint,target);
					_character.updateDir(dir);
				}
				
				if(_skill)
				{
					if(_skill.isAttack())
						_character.getCharacter().doActionType(ActionType.ATTACK);
				}
				if(!SharedObjectManager.hideSkillEffect.value)
				{
					//风位
					if(_skill.getActionEffect()[0] > 0)
					{
						var actionMovieInfo:MovieTemplateInfo = MovieTemplateList.getMovie(_skill.getActionEffect()[0]);
						if(actionMovieInfo)
						{
							//								_actionEffect = CommonEffectPoolManager.baseLoaderEffectManager.getObj([actionMovieInfo]) as BaseLoadEffectPool;
							_actionEffect = new BaseLoadEffect(actionMovieInfo);
							var vy:int = _character.sceneY;
							if(getPlayer().getScenePlayerInfo().isMount)
							{
								vy = _character.sceneY - 50;
							}
							_actionEffect.move(_character.sceneX,vy);
							getPlayer().scene.addEffect(_actionEffect);
							_actionEffect.play(SourceClearType.TIME,180000,4);
						}
					}
				}
			}
		}
		
		
		override public function doAttack():void
		{
			if(_character && _character.scene )
			{
				var action:AttackActionInfo = getAttackActionInfo();
				var selfPoint:Point = new Point(_character.sceneX,_character.sceneY);
				var target:Point = new Point(action.targetX,action.targetY);
				
				if(_skill)
				{
					var movieInfo:MovieTemplateInfo = MovieTemplateList.getMovie(_skill.getAttackEffect(action.level)[0]);
					
					if(movieInfo)
					{
						if(movieInfo.isMove)
						{
							if(movieInfo.picPath == "-1" || movieInfo.picPath == "0" || SharedObjectManager.hideSkillEffect.value)
							{
								attackEffectHandler(null);
							}
							else
							{
								var vy:int = _character.sceneY;
								if(getPlayer().getScenePlayerInfo().isMount)
								{
									vy = _character.sceneY - 50;
								}
								_attackEffect = new BaseLoadMoveEffect(movieInfo,Point.distance(new Point(_character.sceneX, _character.sceneY - 50),new Point(action.targetX,action.targetY - 50)));
//								_attackEffect = CommonEffectPoolManager.baseLoadMoveEffectManager.getObj([movieInfo,Point.distance(new Point(_character.sceneX,_character.sceneY - 50),new Point(action.targetX,action.targetY - 50))]) as BaseLoadMoveEffectPool;
								_effectPackage = new Sprite();
								_effectPackage.x = selfPoint.x;
								_effectPackage.y = selfPoint.y - 50 ;
								_effectPackage.addChild(_attackEffect);
								_effectPackage.mouseChildren = _effectPackage.mouseEnabled = false;
								var angle:int = Geometry.getDegrees(selfPoint,target);
								
								RotateUtils.setRotation(_effectPackage,new Point(_character.sceneX, _character.sceneY - 50),angle);
								_attackEffect.addEventListener(Event.COMPLETE,attackEffectHandler);
//								_life = movieInfo.frames.length;
								getPlayer().scene.addEffect(_effectPackage);
								_attackEffect.play(SourceClearType.TIME,180000,4);
							}
						}
						else
						{
							initCompleteEffect(movieInfo,action);
						}
					}
					
					
					//自己放技能
					if(_character.getBaseRoleInfo().getObjId() == GlobalData.selfPlayer.userId)
					{
						if(_skill.isShake)
							(_character as SelfScenePlayer).shakeScene1();
						SoundManager.instance.playSound(SoundManager.getAttackSound());
					}
				}
			}
		}
		
		/**
		 * 完成后开始后续动画
		 * @param evt
		 * 
		 */		
		private function attackEffectHandler(evt:Event):void
		{
			if(_attackEffect)
				_attackEffect.removeEventListener(Event.COMPLETE,attackEffectHandler);
			var action:AttackActionInfo = getAttackActionInfo();
			var skill:SkillTemplateInfo = SkillTemplateList.getSkill(action.skill);
			if(skill)
			{
				var movieInfo:MovieTemplateInfo = MovieTemplateList.getMovie(skill.getAttackEffect(action.level)[0]);
				if(movieInfo)
				{
					var completeMovieInfo:MovieTemplateInfo = MovieTemplateList.getMovie(movieInfo.completeEffect);
					if(completeMovieInfo)
					{
						initCompleteEffect(completeMovieInfo,action);
					}
				}
			}
		}
		/**
		 * 播放完成效果（直接播，或者光效完成后播）
		 * @param movie
		 * 
		 */		
		private function initCompleteEffect(movie:MovieTemplateInfo,action:AttackActionInfo):void
		{
			if(!SharedObjectManager.hideSkillEffect.value)
			{
				if(movie)
				{
					if(movie.count == 1)
					{
						_completeEffect = new BaseLoadEffect(movie);
						_completeEffect.move(action.targetX,action.targetY);
						_completeEffect.play(SourceClearType.TIME,180000,4);
						if(_character && _character.scene)
							_character.scene.addEffect(_completeEffect as DisplayObject);
					}
					else
					{
						if(_character && _character.scene)
						{
							_completeEffect = new BaseCountEffect(movie,action.targetX,action.targetY,_character.scene.addEffect);
							_completeEffect.play(SourceClearType.TIME,180000,4);
						}
					}
					_life = movie.frames.length;
				}
			}
		}
		
		private function getAttackActionInfo():AttackActionInfo
		{
			return _actionInfo as AttackActionInfo;
		}
		
		private function getPlayer():BaseScenePlayer
		{
			return _character as BaseScenePlayer;
		}
		
		override public function dispose():void
		{
			if(_character.isMoving)
			{
				_character.getCharacter().doActionType(ActionType.WALK);
			}
			if(_attackEffect)
			{
//				_attackEffect.dispose();
				_attackEffect.removeEventListener(Event.COMPLETE,attackEffectHandler);
				_attackEffect = null;
			}
			if(_completeEffect)
			{
//				_completeEffect.dispose();
				_completeEffect = null;
			}
			if(_effectPackage && _effectPackage.parent)
			{
				_effectPackage.parent.removeChild(_effectPackage);
			}
			if(_actionEffect)
			{
//				_actionEffect.collect();
//				_actionEffect.dispose();
				_actionEffect = null;
			}
			super.dispose();
		}
	}
}