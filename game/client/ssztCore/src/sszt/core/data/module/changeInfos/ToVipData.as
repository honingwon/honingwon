package sszt.core.data.module.changeInfos
{
	public class ToVipData
	{
		/**
		 * 类型,0：只显示主窗口，1：只显示购买面板
		 */
		public var type:int;
		
		public function ToVipData(type:int)
		{
			this.type = type;
		}
	}
}