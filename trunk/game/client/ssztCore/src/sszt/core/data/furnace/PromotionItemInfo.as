package sszt.core.data.furnace
{
	import flash.utils.ByteArray;

	public class PromotionItemInfo
	{
		public var oldOrgTempId:int; //原始橙装ID
		public var materialList:Array = []; //材料数组
//		public var blackStoneTempId:int;	//黑曜石ID
//		public var blackStoneAmount:int;					//黑曜石数量
		public var targetOrgTempId:int;		//目标橙装ID
		public var copper:int;						//消耗铜币
//		public var successRate:int;				//成功率
		
		public function parseData(argData:ByteArray):void
		{
			oldOrgTempId = argData.readInt();
			copper = argData.readInt();
			var tString:String = argData.readUTF();
			var tmpStringList:Array = tString.split("|");
			
			for(var i:int = 0;i <tmpStringList.length;i++)
			{
				var tmpList:Array = tmpStringList[i].split(",");
				materialList.push({id:Number(tmpList[0]),value:Number(tmpList[1])});
			}			
			targetOrgTempId = argData.readInt();
			
		}
	}
}