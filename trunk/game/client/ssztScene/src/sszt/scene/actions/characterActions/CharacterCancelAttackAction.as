package sszt.scene.actions.characterActions
{
	import sszt.scene.data.BaseActionInfo;
	import sszt.scene.data.fight.CancelAttackActionInfo;
	
	public class CharacterCancelAttackAction extends BaseCharacterAction
	{
		public function CharacterCancelAttackAction(info:CancelAttackActionInfo)
		{
			super(info, 0);
		}
		
		override public function play():void
		{
			super.play();
			doCancel();
		}
		
		protected function doCancel():void
		{
		}
	}
}