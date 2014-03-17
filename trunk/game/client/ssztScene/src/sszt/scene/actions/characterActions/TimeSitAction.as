package sszt.scene.actions.characterActions
{
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.BaseActionInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneMediator;
	
	public class TimeSitAction extends BaseCharacterAction
	{
		private var _mediator:SceneMediator;
		private var _startTime:Number;
		private var _player:SelfScenePlayer;
		
		private var _flag:int = 0;
		
		public function TimeSitAction(mediator:SceneMediator,player:SelfScenePlayer)
		{
			_mediator = mediator;
			_player = player;
			super(null,0);
		}
		
		override public function configure(...parameters):void
		{
			_startTime = getTimer();
			_flag = 0;
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			if(_player.isSit() || !_mediator.sceneInfo.playerList.self.getIsCommon())
			{
				GlobalAPI.tickManager.removeTick(this);
				return;
			}
			var n:Number = getTimer();
			
			if (n - _startTime > 30000 && _flag == 0)
			{
				if (GlobalData.selfPlayer.level < 35){
					_mediator.sceneModule.facade.sendNotification(SceneMediatorEvent.TIME_SIT_TASK_WARN);
				} 
				else {
					if (GlobalData.selfPlayer.level < 38){
						if (GlobalData.copyEnterCountList.isInCopy){
							_mediator.setHangup(true);
						}
					}
				}
				_flag = 1;
			}
			
			if(n - _startTime > 60 * 1000)
			{
				_mediator.selfSit(true);
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			GlobalAPI.tickManager.removeTick(this);
			_mediator = null;
			_player = null;
		}
	}
}