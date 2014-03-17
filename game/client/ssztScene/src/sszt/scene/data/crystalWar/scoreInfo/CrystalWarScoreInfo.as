package sszt.scene.data.crystalWar.scoreInfo
{
	import flash.events.EventDispatcher;
	
	import sszt.scene.events.SceneCrystalWarUpdateEvent;
	

	public class CrystalWarScoreInfo extends EventDispatcher
	{
		public var itemInfoList:Array;
		public function CrystalWarScoreInfo()
		{
		}
		
		public function update():void
		{
//			listSortOn(itemInfoList);
			dispatchEvent(new SceneCrystalWarUpdateEvent(SceneCrystalWarUpdateEvent.CRYSTAL_SCORE_INFO_UPDATE));
		}
		
		public function listSortOn(argList:Array,argParm:String):void
		{
			argList.sortOn([argParm],[Array.NUMERIC|Array.DESCENDING]);
			for(var i:int = 0;i < argList.length;i++)
			{
				argList[i].rankNum = i+1;
			}
		}
		
		/**根据阵营名称搜索列表**/
		public function getListByCampName(argName:String):Array
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
					if(itemInfoList[i].campName == argName)
					{
						tmpList.push(itemInfoList[i]);
					}
				}
			}
			return tmpList;
		}
		
		//argSorOnType  (0 按击杀数  1按总积分
		//argName == “”整份数据    argName
		public function getSortOnList(argSorOnType:int,argName:String = ""):Array
		{
			var tmpList:Array = getListByCampName(argName);
			if(!tmpList)return null;
			switch(argSorOnType)
			{
				case 0:
					listSortOn(tmpList,"killCount");
					break
				case 1:
					listSortOn(tmpList,"playerScore");
					break
			}
			return tmpList;
		}
		
		//从指定列表中根据玩家名搜索
		public function getInfo(argPlayerNick:String,argList:Array = null):CrystalWarScoreItemInfo
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