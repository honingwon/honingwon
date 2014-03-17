package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;

	public class HoleInfo
	{
		public var holeflag:int;//打孔表标识：0为几率,1为金钱
//		public var enchaseVector:Vector.<int> = new Vector.<int>();
		public var enchaseVector:Array = [];
//		public var enchase1:int;//第一个孔的系数
//		public var enchase2:int;//第二个孔的系数	
//		public var enchase3:int;//第三个孔的系数
//		public var enchase4:int;//第四个孔的系数
//		public var enchase5:int;//第五个孔的系数
		
		public function parseData(argData:ByteArray):void
		{
			holeflag = argData.readInt();
			for(var i:int = 0;i < 5;i++)
			{
				enchaseVector.push(argData.readInt());
			}
//			enchase1 = argData.readInt();
//			enchase2 = argData.readInt();
//			enchase3 = argData.readInt();
//			enchase4 = argData.readInt();
//			enchase5 = argData.readInt();
		}
	}
}