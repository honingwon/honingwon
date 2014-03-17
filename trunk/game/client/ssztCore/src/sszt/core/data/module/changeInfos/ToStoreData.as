package sszt.core.data.module.changeInfos
{
	public class ToStoreData
	{
		public var type:int;
		public var tabIndex:int;
		public var npcId:int;
		
		public function ToStoreData(type:int,tabIndex:int = 0,npcId:int=0)
		{
			this.type = type;
			this.tabIndex = tabIndex;
			this.npcId = npcId;
		}
	}
}