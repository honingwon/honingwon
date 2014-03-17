package sszt.events
{
	import flash.events.Event;
	/**
	 * 共用模块事件
	 * @author Administrator
	 * 
	 */	
	public class CommonModuleEvent extends Event
	{
		/**
		 * 时间日期更新(新一天)
		 */		
		public static const DATETIME_UPDATE:String = "dateTimeUpdate";
		/**
		 * 显示物品tip
		 */		
		public static const SHOW_ITEMTIP:String = "showItemTip";
		/**
		 *显示宠物tip 
		 */
		public static const SHOW_PET_TIP:String = "showPetTip";
		/**
		 *展示坐骑 
		 */
		public static const SHOW_MOUNT:String = "showMount";
		/**
		 * 获取物品信息成功
		 */		
		public static const LOAD_ITEMINFO_COMPLETE:String = "loadItemInfoComplete";
		/**
		 * 
		 */
		public static const LOAD_PETINFO_COMPLETE:String = "loadPetInfoComplete";
		/**
		 * 更新物品冷却时间
		 * 1HP
		 * 2MP
		 */		
		public static const UPDATE_ITEM_CD:String = "updateItemCD";
		/**
		 * 获得焦点
		 */		
		public static const ACTIVATE:String = "activate";
		/**
		 * 失去焦点
		 */		
		public static const DEACTIVATE:String = "deactivate";
		/**
		 * 设置引导tip
		 */		
		public static const SET_GUIDETIP:String = "setGuideTip"; 
		/**
		 * 执行下一个脚本
		 */		
		public static const GOTO_NEXT_DEPLOY:String = "gotoNextDeploy";
		/**
		 * 场景大小更新
		 */		
		public static const GAME_SIZE_CHANGE:String = "gameSizeChange";
		/**
		 * 拖动结束
		 */		
		public static const DRAG_COMPLETE:String = "dragComplete";
		/**
		 *音效开关时间 
		 */
		public static const VOICE_CHANGE:String = "voiceChange";
		/**
		 * 升级
		 */		
		public static const UPGRADE:String = "upgrade";
		/**
		 * 获得第一只宠物
		 */		
		public static const GET_FIRST_PET:String = "getFirstPet";
		/**
		 * 副本中任务引导提示
		 */	
		public static const DUPLICATE_TASK_PROMPT:String = "duplicateTaskPrompt";  
		
		public static const GUILD_SKILL_UPGRADE_TIMERS:String = "guildSkillUpgradeTimers";
		/**
		 *技能刷新 
		 */		
		public static const SKILL_REFRESH:String = "skillRefresh";
		/**
		 *穴位升级 
		 */		
		public static const VEINS_UPGRADE:String = "veinsUpgrade";
		/**
		 *宠物斗坛日志 
		 */		
		public static const PET_PVP_LOG:String = "petPVPLog";
		/**
		 *邮件刷新 
		 */		
		public static const MAIL_REFRESH:String = "mailRefresh";
		
		/**
		 * 开箱子开出物品更新
		 */
		public static const GAIN_ITEM_UPDATE:String = "gainItemUpdate";
		/**
		 * 加速挂
		 */		
		public static const FRAMETIME_OVER:String = "frameTimeOver";
		/**
		 * 按键精灵
		 */		
		public static const KEYSPRITE:String = "keySprite";
		
		/**
		 * 上下左右按键
		 */		
		public static const LEFT_PRESS:String = "leftPress";
		public static const RIGHT_PRESS:String = "rightPress";
		public static const UP_PRESS:String = "upPress";
		public static const DOWN_PRESS:String = "DownPress";
		
		/**
		 * 场景图标加载完成
		 */		
		public static const SCENE_ASSET_COMPLETE:String = "sceneAssetComplete";
		/**
		 * 人物图标资源加载完成
		 */		
		public static const PLAYERICON_ASSET_COMPLETE:String = "playerIconAssetComplete";
		/**
		 * 放烟花
		 */		
		public static const FIREWORK_PLAY:String = "firworkPlay";
		/**
		 * 放玫瑰
		 */		
		public static const ROSE_PLAY:String = "rosePlay";
		
		/**
		 * 排行榜
		 */
		public static const RANK_ITEM_CHANGE:String = "rankItemChange";
		/**
		 * 关闭背包
		 */		
		public static const CLOSE_BAG:String = "closeBag";
		/**
		 * 更新副本信息
		 */		
		public static const UPDATE_COPY_INFO:String = "updateCopyInfo";
		
		/**
		 * 显示药品提示icon
		 */		
		public static const SHOW_MEDICINES_ICON:String = "showMedicinesIcon";
		
		/**
		 * 清空售卖列表 
		 */
		public static const CLEAR_SELL_CELL:String = "clearSellCell";
		
		/**
		 * 同步时间 
		 */
		public static const SYNCH_TIME:String= "synchronousTime";
		
		/**
		 * 功勋更新
		 */
		public static const UPDATE_EXPLOIT:String= "updateExploit";
		
		/**
		 * 标题素材更新 
		 */		
		public static const TITLE_ASSET_COMPLETE:String = "titleAssetComplete";
		/**
		 * NPC素材更新 
		 */		
		public static const NPCTITLE_ASSET_COMPLETE:String = "npcTitleAssetComplete";
		
		
		/**
		 * 角色信息更新
		 */		
		public static const ROLEINFO_UPDATE:String = "roleInfoUpdate";
		
		/**
		 * 显示vip体验卡倒计时
		 * */
		public static const SHOW_ONE_HOUR_VIP_COUNTDOW:String = 'showOneHourVipCountdown';
		/**
		 * 隐藏vip体验卡倒计时
		 * */
		public static const HIDE_ONE_HOUR_VIP_COUNTDOW:String = 'hideOneHourVipCountdown';
		/**
		 * 退出退伍
		 * */
		public static const TEAM_LEAVE:String ='teamLeave';
		
		/**
		 * 开服时间已获得
		 * */
		public static const RELEASE_TIME_GOT:String ='releaseTimeGot';
		
		
		
		public static const COMMON_ASSET_COMPLETE:String ='commonAssetComplete';
		
		public static const ADD_FACE:String = "addFace";
		
		
//		/**
//		 * 首个称号 
//		 */		
//		public static const FIRST_ROLE_TITLE:String = 'firstRoleTitle';
		
		public var data:Object;
		
		public function CommonModuleEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}