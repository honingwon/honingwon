package sszt.core.data.module.changeInfos
{
	public class ToNpcStoreData
	{
		public var type:int;
		public var npcId:int;
		//默认选中格子，索引从0开始。
		public var defaultPlace:int;
		public var defaultCount:int;
		
		public function ToNpcStoreData(type:int, npcId:int, defaultPlace:int = 0, defaultCount:int = 99)
		{
			this.type = type;
			this.npcId = npcId;
			this.defaultPlace = defaultPlace;
			this.defaultCount = defaultCount;
		}
	}
}