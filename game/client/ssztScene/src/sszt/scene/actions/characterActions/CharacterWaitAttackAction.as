package sszt.scene.actions.characterActions
{
	import sszt.scene.data.BaseActionInfo;
	import sszt.scene.data.fight.AttackActionInfo;
	
	public class CharacterWaitAttackAction extends BaseCharacterAction
	{
		public function CharacterWaitAttackAction(info:AttackActionInfo)
		{
			super(info,0);
		}
		
		override public function play():void
		{
			super.play();
			doWaiting();
		}
		
		protected function doWaiting():void
		{
		}
	}
}