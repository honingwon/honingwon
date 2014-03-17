package sszt.core.data.swordsman
{
	import flash.events.EventDispatcher;
	
	import sszt.events.SwordsmanMediaEvents;
	import sszt.module.ModuleEventDispatcher;

	public class TokenInfo extends EventDispatcher
	{
		/**
		 * 发布各个江湖令数量数组  0:绿，1：蓝，2：紫，3：橙 
		 */
		public var tokenNum:Array;
		
		/**
		 * 你已领取江湖令数量数组   0:绿，1：蓝，2：紫，3：橙 
		 */
		public var acceptArray:Array
		
		/**
		 * 你已发布江湖令数量数组   0:绿，1：蓝，2：紫，3：橙 
		 */
		public var publishArray:Array
		
		/**
		 * 你已发布且被领取江湖令数量数组   0:绿，1：蓝，2：紫，3：橙 
		 */
		public var tokenPublishArray:Array
		
		public function TokenInfo()
		{
			tokenNum = [];
			
			acceptArray = [];
			
			publishArray = [];
			
			tokenPublishArray = [];
		}
		
		/**
		 * 发布各个江湖令数量数组 0:绿，1：蓝，2：紫，3：橙 
		 * @param list
		 * 
		 */
		public function updateTokenNum(list:Array):void
		{
			tokenNum = list;
//			ModuleEventDispatcher.dispatchModuleEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.UPDATE_TOKEN_NUM));
		}
		
		/**
		 * 你已领取江湖令数量数组 0:绿，1：蓝，2：紫，3：橙 
		 * @param list
		 * 
		 */
		public function updateAcceptArray(list:Array):void
		{
			acceptArray = list;
			
			dispatchEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.UPDATE_ACCEPT));
		}
		
		/**
		 * 你已发布江湖令数量数组 0:绿，1：蓝，2：紫，3：橙 
		 * @param list
		 * 
		 */
		public function updatePublishArray(list:Array):void
		{
			publishArray = list;
			
			dispatchEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.UPDATE_PUBLISH));
		}
		
		/**
		 * 你已发布且被领取江湖令数量数组 0:绿，1：蓝，2：紫，3：橙 
		 * @param list
		 * 
		 */
		public function updateTokenPublishArray(list:Array):void
		{
			tokenPublishArray = list;
			
			dispatchEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.UPDATE_TOKEN_PUBLISH));
		}
	}
}