package sszt.scene.actions.characterActions
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mhsm.ui.BarAsset3;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.DirectType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.scene.data.fight.AttackActionInfo;
	import sszt.scene.socketHandlers.TargetAttackWaitingSocketHandler;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.ui.BarAsset7;
	
	public class PlayerWaitAttackAction extends CharacterWaitAttackAction
	{
		private var _waitingEffect:BaseLoadEffect;
		private var _startTime:Number;
		private var _totalTime:Number;
		private var _progressBar:ProgressBar;
		
		public function PlayerWaitAttackAction(info:AttackActionInfo)
		{
			super(info);
		}
		
		override protected function doWaiting():void
		{
			if(_character && _character.scene)
			{
				var action:AttackActionInfo = getAttackActionInfo();
				var selfPoint:Point = new Point(_character.sceneX,_character.sceneY);
				var target:Point = new Point(action.targetX,action.targetY);
				if(!selfPoint.equals(target))
				{
					var dir:int = DirectType.checkDir(selfPoint,target);
					_character.updateDir(dir);
				}
				
				_waitingEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.INTONATE));
				_waitingEffect.move(_character.sceneX,_character.sceneY);
				_waitingEffect.play();
//				_character.scene.addEffect(_waitingEffect);
				_character.scene.addToMap(_waitingEffect);
				
				_character.getBaseRoleInfo().state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
				
				var skill:SkillTemplateInfo = SkillTemplateList.getSkill(action.skill);
				
				if(_progressBar == null && action.actorId == GlobalData.selfPlayer.userId)
				{
					var progressBg:MovieClip = new BarAsset3();
					progressBg.width = 240;
					progressBg.height = 20;
					progressBg.x = -16;
					progressBg.y = -5;
					_progressBar = new ProgressBar(new BarAsset7(),0,100,210,10,false,false,progressBg);
					_progressBar.setCurrentValue(0);
					_progressBar.move(410,470);
					_progressBar.move(CommonConfig.GAME_WIDTH / 2 - 90,CommonConfig.GAME_HEIGHT / 2 + 90);
					
					_totalTime = skill.getPrepareTime(action.level);
					_startTime = getTimer();
				}
			}
		}
		
		private function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			if(!_character.getBaseRoleInfo().getIsReady())
			{
				skip();
//				TargetAttackWaitingSocketHandler.send();
			}
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			super.update(times,dt);
			if(getAttackActionInfo().actorId == GlobalData.selfPlayer.userId)
			{
				var passTime:Number = getTimer() - _startTime;
				if(passTime < _totalTime)
				{
					if(!_progressBar.parent)GlobalAPI.layerManager.getTipLayer().addChild(_progressBar);
					_progressBar.setCurrentValue(int((passTime / _totalTime) * 100));
				}
			}
		}
		
		override public function skip():void
		{
			super.skip();
			dispose();
		}
		
		public function getAttackActionInfo():AttackActionInfo
		{
			return _actionInfo as AttackActionInfo;
		}
		
		override public function dispose():void
		{
			if(_character && _character.getBaseRoleInfo())
			{
				_character.getBaseRoleInfo().state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
			}
			if(_waitingEffect)
			{
				_waitingEffect.dispose();
				_waitingEffect = null;
			}
			if(_progressBar)
			{
				if(_progressBar.parent)_progressBar.parent.removeChild(_progressBar);
				_progressBar.dispose();
				_progressBar = null;
			}
			super.dispose();
		}
	}
}