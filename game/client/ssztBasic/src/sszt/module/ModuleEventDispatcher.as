package sszt.module
{
	import flash.events.EventDispatcher;
	
	import sszt.events.CellEvent;
	import sszt.events.ChatModuleEvent;
	import sszt.events.ClubModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.EnthralModuleEvent;
	import sszt.events.FriendModuleEvent;
	import sszt.events.MailModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.NavigationModuleEvent;
	import sszt.events.PetModuleEvent;
	import sszt.events.PetPVPModuleEvent;
	import sszt.events.QuizModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.StoreModuleEvent;
	import sszt.events.TaskModuleEvent;
	
	public class ModuleEventDispatcher
	{
		/**
		 * 模块事件
		 */		
		private static const _moduleDispatch:EventDispatcher = new EventDispatcher();
		public static function addModuleEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_moduleDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeModuleEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_moduleDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchModuleEvent(event:ModuleEvent):void
		{
			_moduleDispatch.dispatchEvent(event);
		}
		
		/**
		 * 共用模块事件
		 */		
		private static const _commonModuleDispatch:EventDispatcher = new EventDispatcher();
		public static function addCommonModuleEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_commonModuleDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeCommonModuleEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_commonModuleDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchCommonModuleEvent(event:CommonModuleEvent):void
		{
			_commonModuleDispatch.dispatchEvent(event);
		}
		 
		/**
		 * 格子事件
		 */		
		private static const _cellDispatch:EventDispatcher = new EventDispatcher();
		public static function addCellEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_cellDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeCellEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_cellDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchCellEvent(event:CellEvent):void
		{
			_cellDispatch.dispatchEvent(event);
		}
		
		/**
		 * 导航事件
		 */		
		private static const _navigationDispatch:EventDispatcher = new EventDispatcher();
		public static function addNavigationEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_navigationDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeNavigationEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_navigationDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchNavigationEvent(event:NavigationModuleEvent):void
		{
			_navigationDispatch.dispatchEvent(event);
		}
		
		/**
		 * 场景事件
		 */		
		private static const _sceneDispatch:EventDispatcher = new EventDispatcher();
		public static function addSceneEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_sceneDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeSceneEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_sceneDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchSceneEvent(event:SceneModuleEvent):void
		{
			_sceneDispatch.dispatchEvent(event);
		}
		
		/**
		 * 任务事件
		 */		
		private static const _taskDispatch:EventDispatcher = new EventDispatcher();
		public static function addTaskEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_taskDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeTaskEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_taskDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchTaskEvent(event:TaskModuleEvent):void
		{
			_taskDispatch.dispatchEvent(event);
		}
		
		/**
		 * IM事件
		 */		
		private static const _friendDispatch:EventDispatcher = new EventDispatcher();
		public static function addFriendEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_friendDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeFriendEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_friendDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchFriendEvent(event:FriendModuleEvent):void
		{
			_friendDispatch.dispatchEvent(event);
		}
		/**
		 *MAIL事件 
		 */		
		private static const _maiDispatch:EventDispatcher = new EventDispatcher();
		public static function addMailEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_maiDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeMailEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_maiDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchMailEvent(event:MailModuleEvent):void
		{
			_maiDispatch.dispatchEvent(event);
		}
		
		/**
		 * 帮会事件
		 */		
		private static const _clubDispatch:EventDispatcher = new EventDispatcher();
		public static function addClubEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_clubDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeClubEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_clubDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchClubEvent(event:ClubModuleEvent):void
		{
			_clubDispatch.dispatchEvent(event);
		}
		/**
		 * 聊天事件
		 */		
		private static const _chatDispatch:EventDispatcher = new EventDispatcher();
		public static function addChatEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_chatDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeChatEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_chatDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchChatEvent(event:ChatModuleEvent):void
		{
			_chatDispatch.dispatchEvent(event);
		}
		/**
		 *防沉迷事件 
		 */
		private static const _enthralDispatch:EventDispatcher = new EventDispatcher();
		public static function addEnthralEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_enthralDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeEnthralEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_enthralDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchEnthralEvent(event:EnthralModuleEvent):void
		{
			_enthralDispatch.dispatchEvent(event);
		}
		
		/**
		 *宠物事件 
		 */
		private static const _petDispatch:EventDispatcher = new EventDispatcher();
		public static function addPetEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_petDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removePetEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_petDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchPetEvent(event:PetModuleEvent):void
		{
			_petDispatch.dispatchEvent(event);
		}
		
		/**
		 *答题活动事件 
		 */
		private static const _quizDispatch:EventDispatcher = new EventDispatcher();
		public static function addQuizEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_quizDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeQuizEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_quizDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchQuizEvent(event:QuizModuleEvent):void
		{
			_quizDispatch.dispatchEvent(event);
		}
		
		
		/**
		 *答题活动事件 
		 */
		private static const _petpvpDispatch:EventDispatcher = new EventDispatcher();
		public static function addPetPVPEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_petpvpDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removePetPVPEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_petpvpDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchPetPVPEvent(event:PetPVPModuleEvent):void
		{
			_petpvpDispatch.dispatchEvent(event);
		}
		
		/**
		 * 商城模板 
		 */		
		private static const _storeDispatch:EventDispatcher = new EventDispatcher();
		public static function addStoreEventListener(type:String,listener:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			_storeDispatch.addEventListener(type,listener,useCaptrue,priority,useWeakReference);
		}
		public static function removeStoreEventListener(type:String,listener:Function,useCaptrue:Boolean = false):void
		{
			_storeDispatch.removeEventListener(type,listener,useCaptrue);
		}
		public static function dispatchStoreEvent(event:StoreModuleEvent):void
		{
			_storeDispatch.dispatchEvent(event);
		}
		
	}
}