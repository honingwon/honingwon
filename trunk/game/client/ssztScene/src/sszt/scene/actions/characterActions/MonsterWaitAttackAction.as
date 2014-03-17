package sszt.scene.actions.characterActions
{
	import sszt.scene.data.fight.AttackActionInfo;
	
	public class MonsterWaitAttackAction extends CharacterWaitAttackAction
	{
		public function MonsterWaitAttackAction(info:AttackActionInfo)
		{
			super(info);
		}
		
		override protected function doWaiting():void
		{
		}
	}
}