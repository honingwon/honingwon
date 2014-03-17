package sszt.scene.data.personalWar.menber
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.ScenePerWarUpdateEvent;
	
	public class PerWarMembersInfo extends EventDispatcher
	{
		public var membersItemList:Array;
		public var currentPepNum:int;
		public var allPepNum:int;
		public var isSendGet:Boolean;
		public function PerWarMembersInfo()
		{
			membersItemList = [];
		}
		
		//增加
		public function addToList(argItemInfo:PerWarMembersItemInfo):void
		{
			membersItemList.push(argItemInfo);
		}
		//删除
		public function removeFromList(argUserId:Number):void
		{
			var tmpInfo:PerWarMembersItemInfo = getMemberItemInfo(argUserId);
			if(!tmpInfo)return;
			membersItemList.splice(membersItemList.indexOf(tmpInfo),1);
		}
		//更新
		public function updateList(argItemInfo:PerWarMembersItemInfo):void
		{
			var tmpInfo:PerWarMembersItemInfo = getMemberItemInfo(argItemInfo.userId);
			membersItemList[membersItemList.indexOf(tmpInfo)] = argItemInfo;
		}
		
		
		public function dealList(argList:Array):void
		{
			for each(var i:PerWarMembersItemInfo in argList)
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
			dispatchEvent(new ScenePerWarUpdateEvent(ScenePerWarUpdateEvent.PERWAR_MENBERS_LIST_UPDATE,argList));
		}
		
		public function listSortOn():void
		{
			membersItemList.sortOn(["score"],[Array.NUMERIC|Array.DESCENDING]);
			for(var i:int = 0;i < membersItemList.length;i++)
			{
				membersItemList[i].rankingNum = i+1;
			}
		}
		
		public function sendGet():void
		{
			isSendGet = true;
			dispatchEvent(new ScenePerWarUpdateEvent(ScenePerWarUpdateEvent.PERWAR_SEND_GET_AWARD));
		}
		
		/**根据页数去数据**/
		public function getMemberListByPage(argPage:int,argPageSize:int):Array
		{
			var index:int = (argPage-1) * argPageSize;
			return membersItemList.slice(index,index + argPageSize);
		}
		
		public function getMemberItemInfo(argUserId:Number):PerWarMembersItemInfo
		{
			for each(var i:PerWarMembersItemInfo in membersItemList)
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