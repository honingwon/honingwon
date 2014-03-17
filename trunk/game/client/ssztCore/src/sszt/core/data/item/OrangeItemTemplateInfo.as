package sszt.core.data.item
{
	import flash.utils.ByteArray;

	public class OrangeItemTemplateInfo
	{
		public var purpleTempId:int; //紫装ID
		public var materialList:Array = [];
//		public var amethystTempId:int;	//紫水晶ID
//		public var amount:int;					//消耗紫水晶数量
		public var orangeTempId:int;		//橙装ID
		public var copper:int;						//消耗铜币
//		public var successRate:int;				//成功率
		
		public function OrangeItemTemplateInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			purpleTempId = data.readInt();
			copper = data.readInt();
			var tmpStringList:Array = data.readUTF().split("|");			
			for(var i:int = 0;i <tmpStringList.length;i++)
			{
				var tmpList:Array = tmpStringList[i].split(",");
				materialList.push({id:Number(tmpList[0]),value:Number(tmpList[1])});
			}			
			orangeTempId = data.readInt();
		}
	}
}