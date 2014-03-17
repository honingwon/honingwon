package sszt.scene.actions.characterActions
{
	import sszt.constData.ActionType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.scene.data.fight.CancelAttackActionInfo;
	
	public class PlayerCancelAttackAction extends CharacterCancelAttackAction
	{
		public function PlayerCancelAttackAction(info:CancelAttackActionInfo)
		{
			super(info);
		}
		
		override protected function doCancel():void
		{
			_character.getCharacter().doActionType(ActionType.STAND);
			skip();
		}
		
		override public function skip():void
		{
			super.skip();
			dispose();
		}
	}
}