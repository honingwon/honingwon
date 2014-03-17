package sszt.core.data.module.changeInfos
{
	public class ToBoxData
	{
		/**
		* 打开窗口类型，1：开箱子主界面，2：神魔开箱子仓库,3:副本开箱子主界面，4：寻源概况界面, 5:开箱子所得物品展示
		*/		
		public var type:int;
		public var place:int;
		public var list:Array;
		public var tabIndex:int;
		
		public function ToBoxData(type:int,place:int=-1,list:Array = null,argTabIndex:int= 1)
		{
			this.type = type;
			this.place = place;
			this.list = list;
			this.tabIndex = argTabIndex;
		}
	}
}