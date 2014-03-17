package sszt.scene.data.clubPointWar.scoreInfo
{
	import flash.events.EventDispatcher;
	
	import sszt.scene.events.SceneClubPointWarUpdateEvent;

	public class ClubPointWarScoreInfo extends EventDispatcher
	{
		public var itemInfoList:Array;
		public function ClubPointWarScoreInfo()
		{
		}
		
		public function update():void
		{
//			listSortOn(itemInfoList);
			dispatchEvent(new SceneClubPointWarUpdateEvent(SceneClubPointWarUpdateEvent.CLUB_SCORE_INFO_UPDATE));
		}
		
		public function listSortOn(argList:Array,argParm:String):void
		{
			argList.sortOn([argParm],[Array.NUMERIC|Array.DESCENDING]);
			for(var i:int = 0;i < argList.length;i++)
			{
				argList[i].rankNum = i+1;
			}
		}
		
		/**根据帮会名称搜索列表**/
		public function getListByClubName(argName:String):Array
		{
			if(!itemInfoList)return null;
			var tmpList:Array = [];
			if(argName == "")
			{
				tmpList = itemInfoList;
			}
			else
			{
				for(var i:int = 0;i < itemInfoList.length;i++)
				{
					if(itemInfoList[i].clubName == argName)
					{
						tmpList.push(itemInfoList[i]);
					}
				}
			}
			return tmpList;
		}
		
		//argSorOnType  (0 按击杀数  1按总积分  2按贡献)
		//argName == “”整份数据    argName
		public function getSortOnList(argSorOnType:int,argName:String = ""):Array
		{
			var tmpList:Array = getListByClubName(argName);
			if(!tmpList)return null;
			switch(argSorOnType)
			{
				case 0:
					listSortOn(tmpList,"killCount");
					break
				case 1:
					listSortOn(tmpList,"playerScore");
					break
				case 2:
					listSortOn(tmpList,"clubContribute");
					break;
			}
			return tmpList;
		}
		
		//从指定列表中根据玩家名搜索
		public function getInfo(argPlayerNick:String,argList:Array = null):ClubPointWarScoreItemInfo
		{
			var tmpList:Array;
			tmpList = (argList == null)?itemInfoList:argList;
			for(var i:int = 0;i < tmpList.length;i++)
			{
				if(tmpList[i].playerNick == argPlayerNick)
				{
					return tmpList[i];
				}
			}
			return null;
		}
	}
}