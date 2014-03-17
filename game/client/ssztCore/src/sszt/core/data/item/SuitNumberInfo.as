package sszt.core.data.item
{
	import flash.utils.ByteArray;

	public class SuitNumberInfo
	{
		public var suitId:int;
		public var suitName:String;
		public var clothId:int;       //衣服
		public var armetId:int;       //头饰
		public var cuffId:int;        //护腕
		public var shoesId:int;       //鞋子
		public var caestusId:int;     //腰带
		public var necklaceId:int;    //项链
		
		public var itemNum:int;		//物品数量
		
		public function SuitNumberInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			suitId = data.readInt();
			suitName = data.readUTF();
			clothId = data.readInt();
			armetId = data.readInt();
			cuffId = data.readInt();
			shoesId = data.readInt();
			caestusId = data.readInt();
			necklaceId = data.readInt();
			if (clothId > 0) itemNum++;
			if (armetId > 0) itemNum++;
			if (cuffId > 0) itemNum++;
			if (shoesId > 0) itemNum++;
			if (caestusId > 0) itemNum++;
			if (necklaceId > 0) itemNum++;
		}
	}
}