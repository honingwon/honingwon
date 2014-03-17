package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class ActiveRewardsTemplateInfo
	{
		public var id:int;
		public var needActive:int;
		public var exp:int;
		public var bindCopper:int;
		public var bindYuanbao:int;
		public var items:Array = new Array();
		public var itemsCount:Array = new Array();
		
		public function ActiveRewardsTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			needActive = data.readInt();
			exp = data.readInt();
			bindCopper = data.readInt();
			bindYuanbao = data.readInt();
			var itemsStr:String = data.readUTF();
			if(itemsStr != '')
			{
				var itemInfoList:Array = itemsStr.split("|" );
				for(var i:int = 0; i < itemInfoList.length; i++)
				{
					var itemInfo:Array = itemInfoList[i].split(",");
					items.push(itemInfo[0]);
					itemsCount.push(itemInfo[1]);
				}
			}
		}
	}
}