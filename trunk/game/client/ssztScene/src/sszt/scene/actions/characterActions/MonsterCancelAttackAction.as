package sszt.scene.actions.characterActions
{
	import sszt.scene.data.fight.CancelAttackActionInfo;
	
	public class MonsterCancelAttackAction extends CharacterCancelAttackAction
	{
		public function MonsterCancelAttackAction(info:CancelAttackActionInfo)
		{
			super(info);
		}
		
		override protected function doCancel():void
		{
		}
	}
}