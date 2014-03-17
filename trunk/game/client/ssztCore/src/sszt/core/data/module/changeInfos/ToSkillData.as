package sszt.core.data.module.changeInfos
{
	public class ToSkillData
	{
		public var index:int;
		public var forciblyOpen:Boolean;
		public function ToSkillData(index:int = -1,forciblyOpen:Boolean = false)
		{
			this.index = index;
			this.forciblyOpen = forciblyOpen;
		}
	}
}