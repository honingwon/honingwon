package sszt.core.data
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.SubCodeSocketHandlerManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.offlineRemind.OfflineRemindView;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SocketEvent;
	import sszt.interfaces.character.ICharacterManager;
	import sszt.interfaces.checks.IChecker;
	import sszt.interfaces.decode.IDecode;
	import sszt.interfaces.drag.IDragManager;
	import sszt.interfaces.font.IFontManager;
	import sszt.interfaces.keyboard.IKeyboardApi;
	import sszt.interfaces.layer.ILayerManager;
	import sszt.interfaces.loader.ICacheApi;
	import sszt.interfaces.loader.ILoaderApi;
	import sszt.interfaces.loader.IWaitLoading;
	import sszt.interfaces.module.IModuleManager;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.path.IPathManager;
	import sszt.interfaces.socket.ISocketManager;
	import sszt.interfaces.tick.ITickManager;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	/**
	 * 全局api接口
	 * @author Administrator
	 * 
	 */	
	public class GlobalAPI
	{
		/**
		 * 资源路径
		 */
		public static var pathManager:IPathManager;
		/**
		 * 解码API
		 */		
		public static var decodeApi:IDecode;
		/**
		 * 层次api
		 */		
		public static var layerManager:ILayerManager;
		/**
		 * 模块api
		 */		
		public static var moduleManager:IModuleManager;
		/**
		 * 加载包api 实际为LoaderManager
		 */		
		public static var loaderAPI:ILoaderApi;
		/**
		 * socket通讯包api
		 * (login,gateway)
		 */		
		public static var socketManager:ISocketManager;
		/**
		 * 拖动API
		 */		
		public static var dragManager:IDragManager;
		/**
		 * 动画包装API
		 */		
		public static var movieManagerApi:IMovieManager;
		/**
		 * 缓存api
		 */		
		public static var cacheManager:ICacheApi;
		/**
		 * 人物包API
		 */		
		public static var characterManager:ICharacterManager;
		/**
		 * 帧循环器
		 */		
		public static var tickManager:ITickManager;
		
		/**
		 * 字体管理器 
		 */		
		public static var fontManager:IFontManager;
		/**
		 * 检测
		 */		
		public static var checker1:IChecker;
		/**
		 * 键盘事件Api
		 */		
		public static var keyboardApi:IKeyboardApi;
		/**
		 * 加速次数
		 */		
		private static var _overCount:int = 0;
		
		/**
		 * 初始化dragManager,moduleManager,socketManager,characterManager
		 * 外部先初始化waitingLoading再调用此方法
		 * @param sp
		 * 
		 */		
		public static function setup(sp:Sprite):void
		{
			if(GlobalData.domain.hasDefinition("sszt.drag.DragManager"))
			{
				var dragcl:Class = GlobalData.domain.getDefinition("sszt.drag.DragManager") as Class;
				dragManager = new dragcl() as IDragManager;
				dragManager.setup(sp);
			}
			if(GlobalData.domain.hasDefinition("sszt.module.ModuleManager"))
			{
				var moduleCl:Class = GlobalData.domain.getDefinition("sszt.module.ModuleManager") as Class;
				moduleManager = new moduleCl() as IModuleManager;
				moduleManager.setup(layerManager,pathManager,loaderAPI,waitingLoading);
			}
			if(GlobalData.domain.hasDefinition("sszt.socket.SocketManager"))
			{
				var socketCl:Class = GlobalData.domain.getDefinition("sszt.socket.SocketManager") as Class;
				socketManager = new socketCl(GlobalData.bgpIp,GlobalData.bgpPort,GlobalData.PLAT) as ISocketManager;
				socketManager.addEventListener(SocketEvent.SOCKET_CLOSE,socketCloseHandler);
				socketManager.addEventListener(SocketEvent.CONNECT_FAIL,socketConnectFailHandler);
			}
			if(GlobalData.domain.hasDefinition("sszt.tick.TickManager"))
			{
				var tickCl:Class = GlobalData.domain.getDefinition("sszt.tick.TickManager") as Class;
				tickManager = new tickCl(layerManager) as ITickManager;
			}
			if(GlobalData.domain.hasDefinition("sszt.character.CharacterManager"))
			{
				var charCl:Class = GlobalData.domain.getDefinition("sszt.character.CharacterManager") as Class;
				characterManager = new charCl() as ICharacterManager;
				characterManager.setup(loaderAPI,pathManager,tickManager);
			}
			if(GlobalData.domain.hasDefinition("sszt.keyboard.KeyboardManager"))
			{
				var keyboardCl:Class = GlobalData.domain.getDefinition("sszt.keyboard.KeyboardManager") as Class;
				keyboardApi = new keyboardCl(layerManager.getPopLayer().stage) as IKeyboardApi;
			}
			if(GlobalData.domain.hasDefinition("sszt.checks.Checker1"))
			{
				var checker1Cl:Class = GlobalData.domain.getDefinition("sszt.checks.Checker1") as Class;
				checker1 = new checker1Cl() as IChecker;
			}
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.FRAMETIME_OVER,frameTimeOverHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.KEYSPRITE,keySpriteHandler);
		}
		private static function keySpriteHandler(evt:CommonModuleEvent):void
		{
			var n:int = Math.random() * 60000 + 10000;
			var t:Timer = new Timer(n,1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			t.start();
			function timerCompleteHandler(evt:TimerEvent):void
			{
				t.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
				socketManager.close();
				MAlert.show(LanguageManager.getWord("ssztl.common.roundError"),LanguageManager.getWord("ssztl.common.pomptAlertTitle"),MAlert.OK,null,closeHandler);
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					JSUtils.setCloseState(false);
					JSUtils.gotoPage(GlobalAPI.pathManager.getSelectServerPath(),true);
				}
			}
		}
		private static function frameTimeOverHandler(evt:CommonModuleEvent):void
		{
			_overCount++;
			if(_overCount >= 5)
			{
				socketManager.close();
				MAlert.show(LanguageManager.getWord("ssztl.common.netError"),LanguageManager.getWord("ssztl.common.pomptAlertTitle"),MAlert.OK,null,closeHandler);
				function closeHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						JSUtils.setCloseState(false);
						JSUtils.gotoPage(GlobalAPI.pathManager.getSelectServerPath(),true);
//						JSUtils.gotoPage(GlobalAPI.pathManager.getLoginPath(),true);
					}
				}
			}
		}
		
		private static function socketCloseHandler(evt:SocketEvent):void
		{
			OfflineRemindView.show();
//			if(!CommonConfig.beKick)
//			{
//				MAlert.show(LanguageManager.getWord("ssztl.common.gameServerBreak"),LanguageManager.getWord("ssztl.common.pomptAlertTitle"),MAlert.OK,null,closeHandler);
//			}
//			function closeHandler(e:CloseEvent):void
//			{
//				if(e.detail == MAlert.OK)
//				{
//					JSUtils.setCloseState(false);
//					JSUtils.gotoPage(GlobalAPI.pathManager.getSelectServerPath(),true);
//				}
//			}
		}
		
		private static function socketConnectFailHandler(evt:SocketEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.common.connectServerFail"),LanguageManager.getWord("ssztl.common.pomptAlertTitle"),MAlert.OK);
			waitingLoading.hide();
		}
		
		public static var waitingLoading:IWaitLoading;
		public static function initWaitingApi(value:IWaitLoading):void
		{
			waitingLoading = value;
		}
	}
}