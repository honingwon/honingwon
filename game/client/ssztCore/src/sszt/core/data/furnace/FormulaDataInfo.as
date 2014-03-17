package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	
	public class FormulaDataInfo
	{
		public var id:int;
		public var name:String;
		public var outputId:int;
		public var outputName:String;
		public var outputCount:int;
		public var seccussRate:int;
		public var costCopper:int;
//		public var needItemIds:Vector.<int>;
		public var needItemIds:Array;
//		public var needCounts:Vector.<int>;
		public var needCounts:Array;
		
		public function parseData(data:ByteArray):void
		{
//			needItemIds = new Vector.<int>(6);
			needItemIds = [];
//			needCounts = new Vector.<int>(6);
			needCounts = [];
			id = data.readInt();
			name = data.readUTF();
			outputId = data.readInt();
			outputName = data.readUTF();
			outputCount = data.readInt();
			seccussRate = data.readInt();
			costCopper = data.readInt();
			for(var i:int = 0; i < 6; i++)
			{
				var id:int = data.readInt();
				if(id > 0)
				{
					needItemIds[i] = id;
					needCounts[i] = data.readInt();
				}
				else
					data.readInt();				
			}
		}
		
		public function getTempalteInfo():ItemTemplateInfo
		{
			return ItemTemplateList.getTemplate(outputId);
		}
	}
}