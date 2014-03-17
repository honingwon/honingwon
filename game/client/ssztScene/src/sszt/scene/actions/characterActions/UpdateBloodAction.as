package sszt.scene.actions.characterActions
{
	import sszt.constData.AttackTargetResultType;
	import sszt.core.action.BaseAction;
	import sszt.scene.components.movies.BloodMovies;
	import sszt.scene.data.fight.UpdateBloodActionInfo;
	import sszt.scene.data.pools.ScenePoolManager;
	
	public class UpdateBloodAction extends BaseCharacterAction
	{
		public function UpdateBloodAction(info:UpdateBloodActionInfo)
		{
			super(info,0);
			_life = 42;
		}
		
		override public function play():void
		{
			super.play();
			if(_character.scene)
			{
				if(getInfo().blood  > 0)
				{
					_character.bloodMovie([getInfo().blood,AttackTargetResultType.ADDBLOOD,getInfo().isSelf]);
					
				}
				else if(getInfo().blood < 0)
				{
					_character.bloodMovie([getInfo().blood,AttackTargetResultType.HIT,getInfo().isSelf]);
				}
			}
		}
		
		private function getInfo():UpdateBloodActionInfo
		{
			return _actionInfo as UpdateBloodActionInfo;
		}
	}
}