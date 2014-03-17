package sszt.scene.actions.characterActions
{
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.BaseActionInfo;
	
	public class PlayerHpBarUpdateAction extends BaseCharacterAction
	{
		private var _startTime:int;
		private var _player:BaseRole;
		
		public function PlayerHpBarUpdateAction(player:BaseRole)
		{
			_player = player;
			super(null);
		}
		
		override public function configure(...parameters):void
		{
			_startTime = getTimer();
			if(_player)
			{
				if(_player.getBaseRoleInfo().getIsFight())
				{
					_player.showHpBar();
				}
			}
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			if(getTimer() - _startTime >= 6000)
			{
				if(!_player.getBaseRoleInfo().getIsReady())
				{
					_player.getBaseRoleInfo().clearAttackState(true);
					_player.hideHpBar();
					GlobalAPI.tickManager.removeTick(this);
				}
			}
		}
		
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			_player  = null;
			super.dispose();
		}
	}
}