package sszt.core.data.module.changeInfos
{
	public class ToPetData
	{
		public var tabIndex:int;
		/**
		 * 1,配置宠物主面板
		 * 2,显示宠物展示面板
		 */
		public var type:int;
		public var itemId:Number;
		/**
		 * 展示宠物 宠物所属用户Id
		 */
		public var showPetUserId:Number;
		
		/**
		 * 打开面板
		 * 0:进阶, 1：进化，2：提升
		 */		
		public var showPanel:int;
		public var isClose:Boolean;
		public function ToPetData(index:int = 0,type:int = 0,id:Number = 0, userId:Number = 0,argShowPanel:int= -1,argIsClose:Boolean=false)
		{
			tabIndex = index;
			this.type = type;
			this.itemId = id;
			this.showPetUserId = userId;
			this.showPanel = argShowPanel;
			this.isClose = argIsClose;
		}
	}
}