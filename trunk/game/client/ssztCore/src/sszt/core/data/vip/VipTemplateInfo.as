package sszt.core.data.vip
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.item.ItemTemplateList;

	public class VipTemplateInfo
	{
		public var id:int;
		public var name:String;
		public var date:int;
		public var yuanBao:int;
		public var money:int;
		public var buffs:String;
		public var shoesCount:int;
		public var bugleCount:int;
		public var expRate:int;
		public var strengthRate:int;
		public var holeRate:int;
		public var lifeExpRate:int;
		public var mountsStairRate:int;
		public var petStairRate:int;
		public var titleId:int;
		public var items:Array = new Array();
		public var itemsCount:Array = new Array();
		
		public function VipTemplateInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
			date = data.readInt();
			yuanBao = data.readInt();
			money = data.readInt();
			buffs = data.readUTF();
			shoesCount = data.readInt();
			bugleCount = data.readInt();
			expRate = data.readInt();
			strengthRate = data.readInt();
			holeRate = data.readInt();
			lifeExpRate = data.readInt();
			mountsStairRate = data.readInt();
			petStairRate = data.readInt();
			titleId = data.readInt();
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