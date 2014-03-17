package sszt.scene.data.shenMoWar.menbersInfo
{
	import flash.display.Scene;
	import flash.events.EventDispatcher;
	
	import sszt.scene.events.SceneShenMoWarUpdateEvent;

	public class ShenMoWarMenbersInfo extends EventDispatcher
	{
		public var membersItemList:Array;
		public var currentPepNum:int;
		public var allPepNum:int;
		public var isSendGet:Boolean;
		public function ShenMoWarMenbersInfo()
		{
			membersItemList = [];
		}
		
		//增加
		public function addToList(argItemInfo:ShenMoWarMembersItemInfo):void
		{
			membersItemList.push(argItemInfo);
		}
		//删除
		public function removeFromList(argUserId:Number):void
		{
			var tmpInfo:ShenMoWarMembersItemInfo = getMemberItemInfo(argUserId);
			if(!tmpInfo)return;
			membersItemList.splice(membersItemList.indexOf(tmpInfo),1);
		}
		//更新
		public function updateList(argItemInfo:ShenMoWarMembersItemInfo):void
		{
			var tmpInfo:ShenMoWarMembersItemInfo = getMemberItemInfo(argItemInfo.userId);
			membersItemList[membersItemList.indexOf(tmpInfo)] = argItemInfo;
		}
		
		
		public function dealList(argList:Array):void
		{
			for each(var i:ShenMoWarMembersItemInfo in argList)
			{
				if(!getMemberItemInfo(i.userId))
				{
					addToList(i);
				}
				else
				{
					if(i.isOnline == 0)
					{
						removeFromList(i.userId);
					}
					else
					{
						updateList(i);
					}
				}
			}
			listSortOn();
		}
		
		public function update(argList:Array):void
		{
			dispatchEvent(new SceneShenMoWarUpdateEvent(SceneShenMoWarUpdateEvent.SHENMO_MENBERS_LIST_UPDATE,argList));
		}
		
		public function sendGet():void
		{
			isSendGet = true;
			dispatchEvent(new SceneShenMoWarUpdateEvent(SceneShenMoWarUpdateEvent.SHENMO_SEND_GET_AWARD));
		}
		
		public function listSortOn():void
		{
			membersItemList.sortOn(["attackPepNum"],[Array.NUMERIC|Array.DESCENDING]);
			for(var i:int = 0;i < membersItemList.length;i++)
			{
				membersItemList[i].rankingNum = i+1;
			}
		}
		
		/**根据页数去数据**/
		public function getMemberListByPage(argPage:int,argPageSize:int):Array
		{
			var index:int = (argPage-1) * argPageSize;
			return membersItemList.slice(index,index + argPageSize);
		}
		
		public function getMemberItemInfo(argUserId:Number):ShenMoWarMembersItemInfo
		{
			for each(var i:ShenMoWarMembersItemInfo in membersItemList)
			{
				if(i.userId == argUserId)
				{
					return i;
				}
			}
			return null;
		}
	}
}