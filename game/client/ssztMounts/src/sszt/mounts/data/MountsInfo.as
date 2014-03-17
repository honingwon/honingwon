/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-8 下午3:10:54 
 * 
 */ 
package sszt.mounts.data
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.mounts.data.itemInfo.MountsFeedItemInfo;
	import sszt.mounts.event.MountsEvent;

	public class MountsInfo extends EventDispatcher
	{
		public static const MOUNTS_STAIRS_MAX:int = 60;
		/**
		 * 坐骑技能书刷新数据
		 * */
		public var mountsRefreshSkillBooksInfo:MountsRefreshSkillBooksInfo;
		
		public static const PAGESIZE:int = 12;
		public var qualityVector:Array = [];
		
		public var feedItemList:Array = [];
		
		public var currentMounts:MountsItemInfo;
		
		public function initMountsRefreshSkillBooksInfo():void
		{
			if(!mountsRefreshSkillBooksInfo)
			{
				mountsRefreshSkillBooksInfo = new MountsRefreshSkillBooksInfo();
			}
		}
		
		public function clearMountsRefreshSkillBooksInfo():void
		{
			if(mountsRefreshSkillBooksInfo)
			{
				mountsRefreshSkillBooksInfo.dispose();
				mountsRefreshSkillBooksInfo = null;
			}
		}
		
		public function getMountsItemInfoFromQualityVector(itemId:Number):MountsFeedItemInfo
		{
			for each(var i:MountsFeedItemInfo in qualityVector)
			{
				if(i.bagItemInfo.itemId == itemId)
				{
					return i;
				}
			}
			return null;
		}
		
		public function addToQualityVector(argMountsItemInfo:MountsFeedItemInfo):void
		{
			qualityVector.push(argMountsItemInfo);
			dispatchEvent(new MountsEvent(MountsEvent.CELL_QUALITY_ADD,argMountsItemInfo.bagItemInfo.itemId));
		}
		
		
		public function clickHandler(argMountsItemInfo:MountsFeedItemInfo):void
		{
			dispatchEvent(new MountsEvent(MountsEvent.CELL_CLICK,argMountsItemInfo));
		}
		
		public function initialMountsVector(argCallBackFunction:Function):void
		{
			qualityVector = [];
			for each(var i:ItemInfo in GlobalData.bagInfo.getEquipByFunction(argCallBackFunction))
			{
				addToQualityVector(new MountsFeedItemInfo(i));
			}
		}
		
		public function removeFromQualityVector(itemId:Number):void
		{
			var tmpInfo:MountsFeedItemInfo = getMountsItemInfoFromQualityVector(itemId);
			for(var i:int = 0;i < tmpInfo.placeList.length;i++)
			{
				deleteToPlace(tmpInfo,tmpInfo.placeList[i]);
			}
			qualityVector.splice(qualityVector.indexOf(tmpInfo),1);
			dispatchEvent(new MountsEvent(MountsEvent.CELL_QUALITY_DELETE,itemId));
		}
		
		public function deleteToPlace(argMountsItemInfo:MountsFeedItemInfo,argPlace:int):void
		{
			argMountsItemInfo.removePlace(argPlace);
			
			dispatchEvent(new MountsEvent(MountsEvent.MOUNTS_CELL_UPDATE,{info:null,place:argPlace}));
		}
		
		public function getMountsItemInfo(itemId:Number):MountsFeedItemInfo
		{
			for each(var i:MountsFeedItemInfo in qualityVector)
			{
				if(i.bagItemInfo.itemId == itemId)
				{
					return i;
				}
			}
			return null;
		}
		
		public function updateBagToMounts(itemId:Number,argCallBackFunction:Function = null):void
		{
			var tmpMountsItemInfo:MountsFeedItemInfo = getMountsItemInfo(itemId);
			var tmpBagItemInfo:ItemInfo = GlobalData.bagInfo.getItemByItemId(itemId);
			if(tmpMountsItemInfo)
			{
				if(qualityVector.indexOf(tmpMountsItemInfo) != -1)
				{
					//删除
					if(!tmpBagItemInfo)
					{
						removeFromQualityVector(itemId);
						dispatchEvent(new MountsEvent(MountsEvent.CELL_QUALITY_UPDATE,itemId));
					}
					else
					{
						qualityVector[qualityVector.indexOf(tmpMountsItemInfo)].bagItemInfo = tmpBagItemInfo
						dispatchEvent(new MountsEvent(MountsEvent.CELL_QUALITY_UPDATE,itemId));
					}
				}
			}
			else
			{
				if(!tmpBagItemInfo)return;
				//增加
				if(argCallBackFunction(tmpBagItemInfo))
				{
					addToQualityVector(new MountsFeedItemInfo(tmpBagItemInfo));
				}
			}
		}
		
		
		public function setToFeedItems(argMountsItemInfo:MountsFeedItemInfo,argPlace:int):void
		{
			feedItemList.push(argMountsItemInfo);
			dispatchEvent(new MountsEvent(MountsEvent.MOUNTS_CELL_UPDATE,{info:argMountsItemInfo,place:argPlace}));
		}
		
		public function clearFeedItems():void
		{
			for each(var i:MountsFeedItemInfo in feedItemList)
			{
				if(i)
					i.bagItemInfo.lock = false;
			}
			feedItemList = [];
		}
		
		public function changeMounts(info:MountsItemInfo):void
		{
			currentMounts = info;
			dispatchEvent(new MountsEvent(MountsEvent.MOUNTS_ID_UPDATE,info));
		}
		
		
		
	}
}