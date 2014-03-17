package sszt.scene.actions.characterActions
{
	import sszt.core.action.BaseAction;
	import sszt.interfaces.character.ICharacter;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.data.BaseActionInfo;
	
	public class BaseCharacterAction extends BaseAction
	{
		protected var _character:BaseRole;
		protected var _actionInfo:BaseActionInfo;
		
		public function BaseCharacterAction(actionInfo:BaseActionInfo,level:int=0)
		{
			_actionInfo = actionInfo;
			super(level);
		}
		
		public function setCharacter(character:BaseRole):void
		{
			_character = character;
			doAction();
		}
	}
}