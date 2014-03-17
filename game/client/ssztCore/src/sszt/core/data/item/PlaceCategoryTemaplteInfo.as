package sszt.core.data.item
{
	import flash.utils.ByteArray;

	public class PlaceCategoryTemaplteInfo
	{
		public var categoryId:int;//装备类型
		public var name:String;//装备名称
		public var place:int;//装备位置
		
		public function PlaceCategoryTemaplteInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			categoryId = data.readInt();
			name = data.readUTF();
			place = data.readInt();
		}
	}
}