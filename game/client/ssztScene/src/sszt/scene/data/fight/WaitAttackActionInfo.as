package sszt.scene.data.fight
{
	import sszt.scene.data.BaseActionInfo;
	
	public class WaitAttackActionInfo extends BaseActionInfo
	{
		public var skillId:int;
		public var skillLevel:int;
		
		public function WaitAttackActionInfo(skillId:int,skillLevel:int)
		{
			this.skillId = skillId;
			this.skillLevel = skillLevel;
			super();
		}
	}
}