package sszt.core.data.module.changeInfos
{
	public class ToMountsData
	{
		public var tabIndex:int;
		/**
		 * 0,配置坐骑主面板
		 * 1,配置坐骑升级面板
		 * 2,显示坐骑展示面板
		 */
		public var type:int;
		/**
		 * 坐骑ID
		 */
		public var itemId:Number;
		/**
		 * 展示坐骑 坐骑所属用户Id
		 */
		public var showMountUserId:Number;
		
		/**
		 * 打开面板
		 * 0:进阶, 1：进化，2：提升
		 */		
		public var showPanel:int;
		
		public var isClose:Boolean;
		
		public function ToMountsData(index:int = 0,type:int = 0,id:Number = 0,userId:Number = 0,argShowPanel:int= -1,argIsClose:Boolean= false)
		{
			tabIndex = index;
			this.type = type;
			this.itemId = id;
			this.showMountUserId = userId;
			this.showPanel = argShowPanel;
			this.isClose = argIsClose;
		}
	}
}