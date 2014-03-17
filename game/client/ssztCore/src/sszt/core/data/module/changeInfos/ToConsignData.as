package sszt.core.data.module.changeInfos
{
	public class ToConsignData
	{
		/**
		 * 打开窗口类型，1：主界面，2：快速寄售
		 */		
		public var type:int;
		public var place:int;
		public var index:int;
		
		public function ToConsignData(type:int,place:int = -1,index:int = 0)
		{
			this.type = type;
			this.place = place;
			this.index = index;
		}
	}
}