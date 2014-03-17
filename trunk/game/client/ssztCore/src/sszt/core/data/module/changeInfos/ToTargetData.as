package sszt.core.data.module.changeInfos
{
	public class ToTargetData
	{
		public var tabIndex:int;
		public var typeIndex:int;
		
		public function ToTargetData(index:int = 0,argTypeIndex:int=0)
		{
			this.tabIndex = index;
			this.typeIndex = argTypeIndex;
		}
	}
}