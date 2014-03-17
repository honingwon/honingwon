package sszt.activity.data
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.activity.data.itemViewInfo.ActiveItemInfo;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.core.data.activity.ActiveTemplateInfo;
	import sszt.core.data.activity.ActiveTemplateInfoList;
	
	public class ActivityInfo extends EventDispatcher
	{
		/**
		 * 活跃度模版列表
		 * */
		public var activeItemList:Dictionary = new Dictionary();
		public var activeMyNum:int = 0;
//		public var exp:int = 0;
//		public var bindCopper:int = 0;
		public var isGetGift:Boolean;                      //每日活跃度奖励
		public var giftList:Array = [];
		
		public var activeRewardsStateInfo:Dictionary = new Dictionary();//活跃度奖励领取状态信息
		
		public var bossList:Dictionary;
		
		
		public function ActivityInfo()
		{
			for each(var i:ActiveTemplateInfo in  ActiveTemplateInfoList.list)
			{
				activeItemList[i.id] = new ActiveItemInfo(i)
			}
		}
		
		public function updateActiveRewardsStateInfo(info:Dictionary):void
		{
			activeRewardsStateInfo = info;
			dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.ACTIVE_REWARDS_STATE_UPDATE));
		}
		
		public function updateActiveData():void
		{
			dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.ACTIVE_DATA_UPDATE));
		}
		
		public function getActiveItem(argId:int):ActiveItemInfo
		{
			var ret:ActiveItemInfo;
			for each(var activeItemInfo:ActiveItemInfo in activeItemList)
			{
				if(activeItemInfo.id == argId)
				{
					ret =  activeItemInfo;
					break;
				}
			}
			return ret;
		}
		
		public function getRewardsSuccess():void
		{
			dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.GET_REWARDS_SUCCESS));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		public function initialActiveItemList(argActiveTempalteItemList:Array):void
		{
			
		}
		
		public function clearAciveItemList():void
		{
			activeItemList.length = 0;
			dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.ACTIVE_ITEMLIST_CLEAR));
		}
		
		
		
		public function changeWelfState(value:Boolean):void
		{

		}
			
		public function changeState(id:int,state:Boolean):void
		{
//			for(var i:int = 0;i < giftList.length;i++)
//			{
//				if(id == giftList[i].id)
//				{
//					giftList[i].changeState(state);
//					break;
//				}
//			}
		}
		
		public function readData(xml:XML):void
		{
//			try
//			{
//				var xmlList:XMLList = xml.child("item");
//				for each(var el:XML in xmlList)
//				{
//					var giftItem:GiftItemInfo = new GiftItemInfo();
//					giftItem.readData(el);
//					giftList.push(giftItem);
//				}
//				dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.LOAD_COMPLETE));
//			}
//			catch(e:Error)
//			{
//				
//			}
		}
		
		public function updateBossList(list:Dictionary):void
		{
			bossList = list;
			dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.UPDATE_BOSS_INFO));
		}
	}
}