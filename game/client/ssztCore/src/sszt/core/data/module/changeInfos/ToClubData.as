package sszt.core.data.module.changeInfos
{
	public class ToClubData
	{
		/**
		 * 打开哪个界面，1:创建帮会，2：帮会列表，3：帮会信息，4：帮会场景，5：宣战界面, 6:帮会商城 7：根据帮会ID，打开对应面板(帮会列表or帮会信息)
		 * 8:公会仓库
		 */		
		public var showType:int;
		public var clubId:Number;
		public var index:int;
		
		public function ToClubData(showType:int,clubId:Number,argIndex:int = 0)
		{
			this.showType = showType;
			this.clubId = clubId;
			this.index = argIndex;
		}
	}
}