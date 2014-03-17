package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class StoneMatchInfo
	{
		public var equipCategoryId:int;//装备分类编号
//		public var stoneList:Vector.<int> = new Vector.<int>();
		public var stoneList:Array = [];
		
		public function parseData(data:ByteArray):void
		{
			equipCategoryId = data.readInt();
			var tmpStringList:Array = data.readUTF().split(",");
			for(var i:int = 0;i <tmpStringList.length;i++)
			{
				stoneList.push(Number(tmpStringList[i]));
			}
		}
		
		public function isSuitableStone(type:int):Boolean
		{
			return stoneList.indexOf(type) != -1;
		}
	}
}