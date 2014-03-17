package sszt.core.data.module.changeInfos
{
	public class ToFurnaceData
	{
		/**0强化1洗练2分解3合成4打孔5镶嵌6摘取7装备融合**/
		public var selectIndex:int;
		public var itemId:Number;
		public function ToFurnaceData(argIndex:int,argItemId:Number)
		{
			selectIndex = argIndex;
			itemId = argItemId;
		}
	}
}