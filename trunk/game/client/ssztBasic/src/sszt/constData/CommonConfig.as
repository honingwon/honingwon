package sszt.constData
{
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	/**
	 * 公共配置数据
	 * @author Administrator
	 * 
	 */	
	public class CommonConfig
	{
		/**
		 * 协议包头长度
		 */		
		public static const PACKAGE_HEAD_SIZE:int = 5;
		/**
		 * 包压缩长度
		 */		
		public static const PACKAGE_COMRESS_LEN:int = 300;
		
		/**
		 * 协议包加密种子
		 */		
		public static var protocolSeer:int = -1;
		
		public static var PROTOCOLKEY:int = 0;
		
		/**
		 * 每帧毫秒数
		 */		
		public static var tick:int = 40;
		
		/**
		 * 游戏宽高
		 */		
		public static var GAME_WIDTH:int = 999;
		public static var GAME_HEIGHT:int = 579;
		public static var isFull:Boolean = false;
		public static function setGameSize(w:Number,h:Number):void
		{
			GAME_WIDTH = w;
			GAME_HEIGHT = h;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GAME_SIZE_CHANGE));
		}
//		public static const GAME_HEIGHT:int = 601;		
		/**
		 * 模态透明值
		 */		
		public static const MODE_ALPHA:Number = 0.5;
		/**
		 * 双击间隔
		 */		
		public static const DOUBLE_CLICK_TIME:int = 180;
		
		public static const WALK_STEP_DISTANCE:int = 6;
		/**
		 * 技能效果速度
		 */		
		public static const EFFECT_STEP_DISTANCE:int = 36;
		
		/**
		 * 怪物击退 
		 */		
		public static const MONSTER_BASK_STEP:int = 30;
		/**
		 * 公共CD时间
		 */		
		public static const COMMONCD:Number = 1200;
		
		/**
		 * 地图9宫大小
		 */		
		public static const MAP_9_GRID_WIDTH:int = 500;
		public static const MAP_9_GRID_HEIGHT:int = 300;
		
		
		/**
		 * 场景图切片大小
		 */		
		public static const SCENEMAP_TILEWIDTH:int = 300;
		public static const SCENEMAP_TILEHEIGHT:int = 300;
		/**
		 * 自动上马距离
		 */		
		public static const SETHOUSE_DISTANCE:int = 800;
		
		/**
		 * 点击地图间隔
		 */		
		public static const CLICK_INTERVAL:int = 500;
		/**
		 * 超过距离跟随
		 */		
		public static const PET_FOLLOW_MAXDISTANCE:int = 160;
		public static const PET_FOLLOW_DISTANCE:int = 80;
		/**
		 * 镖车距离跟随
		 */		
		public static const CAR_FOLLOW_MAXDISTANCE:int = 180;
		public static const CAR_FOLLOW_DISTANCE:int = 120;
		/**
		 * 队伍跟随距离
		 */		
		public static const TEAM_FOLLOW_MAXDISTANCE:int = 140;
		public static const TEAM_FOLLOW_DISTANCE:int = 100;
		/**
		 * 捡道具范围
		 */		
		public static const PICKUP_RADIUS:int = 150;
		
		/**
		 * NPC窗口距离
		 */		
		public static const NPC_PANEL_DISTANCE:int = 200;
		
		/**
		 * 地图走路单元格大小
		 */		
//		public static const GRID_SIZE:uint = 25;
		public static const GRID_SIZE:uint = 40;
		
		/**
		 * 收藏夹游戏名
		 */		
		public static var FAVORITENAME:String = "";
		
		
		
		/**
		 * 是否被踢
		 */		
		public static var beKick:Boolean = false;
		
		/**
		 * 是否调试版本
		 */		
		public static var ISDEBUG:Boolean;
		public static var DEBUGV:Number;
		/**
		 * 等待框资源
		 */		
		public static var WAITTINGBG:int;
		/**
		 * 使用缓存
		 */		
		public static var CACHELOCAL:Boolean;
		/**
		 * 允许客户端数0为不限制
		 */		
		public static var CLIENTNUM:int;
		/**
		 * 语言版本
		 */		
		public static var LANGUAGE:String = "";
		
		/**
		 * 窗口是否激活状态
		 */		
		public static var ISACTIVITY:Boolean = true;
		
		/**
		 * 默认字体
		 */		
		public static var DEFAULT_FONT:String;
		public static var DEFAULT_FONTSIZE:int;
		
		
		public static function initConfigData(config:XML,commonconfig:XML):void
		{
			FAVORITENAME = String(config.config.FAVORITENAME.@value);
			ISDEBUG = String(commonconfig.config.DEBUGING.@value) == "true";
//			ISDEBUG = false;
			DEBUGV = Number(commonconfig.config.DEBUGING.@cv);
			WAITTINGBG = int(commonconfig.config.WAITINGBG.@value);
			CACHELOCAL = String(commonconfig.config.CACHELOCAL.@value) == "true";
			CLIENTNUM = int(commonconfig.config.MULTINUM.@value);
			LANGUAGE = String(config.config.LANGUAGE.@value);
			if(LANGUAGE == "cn")LANGUAGE = "";
			DEFAULT_FONT = String(config.config.FONT.@value);
			DEFAULT_FONTSIZE = int(config.config.FONT.@size);
			PROTOCOLKEY = int(Math.random() * 255);
		}
	}
}