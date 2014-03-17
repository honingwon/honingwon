package sszt.furnace.data
{
	public class FurnaceTipsType
	{
		public static const SUCCESS:int = 0;
		/**装备不符**/
		public static const EQUIP:int = 1;
		/**没装备**/
		public static const NOEQUIP:int = 2;
		/**镶嵌已满**/
		public static const ENCHASEFULL:int = 3;
		/**一次只能放一个石头**/
		public static const STONE1:int = 6;
		/**不能镶嵌同一类型的宝石**/
		public static const STONE2:int = 10;
		/**石头**/
		public static const	 STONE:int = 7;
		/**没有石头**/
		public static const NOSTONE:int = 8;
		/**孔数已满**/
		public static const HOLEFULL:int = 9;
		
		public static const PROTECTBAG:int =4;
		
		public static const LUCKYBAG:int = 5;

	}
}