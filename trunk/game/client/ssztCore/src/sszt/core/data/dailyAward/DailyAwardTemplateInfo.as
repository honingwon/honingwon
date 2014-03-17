package sszt.core.data.dailyAward
{
	import flash.utils.ByteArray;

	public class DailyAwardTemplateInfo
	{
		public var awardId:int;
		public var needSeconds:int;
		public var copper:int;
		public var bindCopper:int;
		public var yuanbao:int;
		public var bindYuanbao:int;
		public var itemIdList:Array = new Array();
		public var itemCountList:Array = new Array();
		
		public function DailyAwardTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			awardId = data.readInt();
			needSeconds = data.readInt();
			copper = data.readInt();
			bindCopper = data.readInt();
			yuanbao = data.readInt();
			bindYuanbao = data.readInt();
			var itemsStr:String = data.readUTF();
			if(itemsStr != '')
			{
				var itemInfoList:Array = itemsStr.split("|" );
				for(var i:int = 0; i < itemInfoList.length; i++)
				{
					var itemInfo:Array = itemInfoList[i].split(",");
					itemIdList.push(itemInfo[0]);
					itemCountList.push(itemInfo[1]);
				}
			}
		}
	}
}