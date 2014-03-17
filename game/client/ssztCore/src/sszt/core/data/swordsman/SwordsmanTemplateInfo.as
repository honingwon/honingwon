package sszt.core.data.swordsman
{
	import flash.utils.ByteArray;
	
	import sszt.core.utils.PackageUtil;

	public class SwordsmanTemplateInfo
	{
		/**江湖令品质1，2，3，4*/
		public var type:int;
		/**完成奖励铜币*/
		public var copper:int;
		/**完成奖励绑定铜币*/
		public var copper_bind:int;
		/**完成奖励经验*/
		public var exp:int;
		/**备用*/
		public var other:int;
		/**发布所需道具（发布一次消耗一个）*/	
		public var item_id:int;
		
		
		public function parseData(data:ByteArray):void
		{
			type = data.readInt();
			copper = data.readInt();
			copper_bind = data.readInt();
			exp = data.readInt();
			other = data.readInt();
			item_id = data.readInt();
		}
	}
}