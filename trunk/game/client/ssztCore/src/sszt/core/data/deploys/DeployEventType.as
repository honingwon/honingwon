package sszt.core.data.deploys
{
	/**
	 * 每种事件类型对应一个deployHandler
	 * @author Administrator
	 * 
	 */	
	public class DeployEventType
	{
		/**
		 * 引导
		 */		
		public static const LEAD:uint = 1;
		/**
		 * 弹窗
		 */		
		public static const POPUP:uint = 2;
		/**
		 * 寻路
		 */		
		public static const WALK:uint = 3;
		/**
		 * 进副本
		 */		
		public static const COPY:uint = 4;
		/**
		 * 模块事件
		 */		
		public static const MODULE_EVENT:uint = 5;
		/**
		 * 引导tip
		 */		
		public static const GUIDE_TIP:uint = 6;
		/**
		 * 任务
		 */		
		public static const TASK:uint = 7;
		/**
		 * 执行下两个部署
		 */		
		public static const GO_NEXT_TWO:uint = 8;
		/**
		 * 链接
		 */		
		public static const LINK:uint = 9;
		
		/**
		 * 表情
		 */		
		public static const FACE:uint = 100;
		/**
		 * 物品tip
		 */		
		public static const ITEMTIP:uint = 101;
		/**
		 * 人物菜单
		 */		
		public static const PLAYER_MENU:uint = 102;
		/**
		 * 任务NPC
		 */		
		public static const TASK_NPC:uint = 103;
		/**
		 * 任务怪物
		 */		
		public static const TASK_MONSTER:uint = 104;
		/**
		 * 任务tips
		 */		
		public static const TASK_TIP:uint = 105;
		/**
		 * 任务传送
		 */		
		public static const TASK_TRANSFER:uint = 106;
		/**
		 * 采集任务 
		 */		
		public static const TASK_COLLECT:uint = 107;
		
		/**
		 * 物品模版tip
		 */
		public static const ITEM_TEMPLATE_TIP:uint = 108;
		
		/**
		 * 技能按钮闪动
		 */
		public static const SKILL_ICON:uint = 109;
		
		/**
		 * 快速购买
		 */
		public static const QUICK_BUY:uint = 110;
		/**
		 * 展示宠物tips 
		 */
		public static const SHOW_PET:uint = 111;
		/**
		 * 坐骑展示 
		 */
		public static const SHOW_MOUNT:uint = 112;
		
		public static const TEXT_COLOR:uint = 113;
		
		/**
		 * 自动使用物品 
		 */		
		public static const GET_AND_USE:uint = 118;
		/**
		 * 传送任务 
		 */		
		public static const TRANSFER_TASK:uint = 120;
		
		
		/**
		 * 自动完成任务 
		 */		
		public static const AUTO_TASK:uint = 124;
		
		/**
		 * 进入多人pvp地图
		 * */
		public static const ENTER_MULTI_PVP_MAP:uint = 125;
		
		/**
		 * 立即完成任务
		 * */
		public static const QUICK_COMPLETE_TASK:uint = 126;
		
		/**
		 * 宠物战斗
		 * */
		public static const PET_PVP_CHALLENGE:uint = 127;
	}
}