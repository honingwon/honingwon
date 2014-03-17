package sszt.core.data.store
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.constData.VipType;
	import sszt.core.data.GlobalData;
	import sszt.events.StoreModuleEvent;
	import sszt.events.WelfareEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class MysteryShopInfo extends EventDispatcher
	{	
		public var mysteryShopItems:Dictionary;
		
		/**
		 * 最后更新时间 
		 */		
		public var lastUpdate:Number;
		
		public var vipTimes:int;
		
		/**
		 * 神秘商店习到高品质物品发送聊天信息
		 */
		public var mysteryShopMsgInfo:MysteryShopMessageInfo = new MysteryShopMessageInfo();
		
		
		public function MysteryShopInfo()
		{
			mysteryShopItems = new Dictionary;
		}
		public function update(list:Dictionary,dispatch:Boolean=false):void
		{
			mysteryShopItems = list;
			if(dispatch)
			{
				ModuleEventDispatcher.dispatchStoreEvent(new StoreModuleEvent(StoreModuleEvent.MYSTERY_SHOPINFO_UPDATE,mysteryShopItems));
			}
		}
		
		public function vipTimesUpdate(value:int):void
		{
			if (VipType.getVipType(GlobalData.selfPlayer.vipType) == VipType.BESTVIP)
			{
				vipTimes = 3 - value;
			}
			else
			{
				vipTimes = 1 - value;
			}
			if	(vipTimes < 0) vipTimes = 0;
			ModuleEventDispatcher.dispatchStoreEvent(new StoreModuleEvent(StoreModuleEvent.MYSTERY_VIPTIME_UPDATE,vipTimes));
		}
		
		public function refreshUpdate(value:Number):void
		{
			lastUpdate = value;
			ModuleEventDispatcher.dispatchStoreEvent(new StoreModuleEvent(StoreModuleEvent.MYSTERY_REFRESH_UPDATE,lastUpdate));
		}
		
		public function getItem(place:int):MysteryShopItemInfo
		{
			if(mysteryShopItems[place] != null)
			{
				return mysteryShopItems[place];
			}
			return null;
		}
	}
}