package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	
	public class FuseTemplate
	{
		public var item_template_id1:int;//熔炼装备1
		public var item_template_id2:int;//熔炼装备2
		public var fusion_num:int;//熔炼符数量
		public var fusion_template_id:int;//成品装备
		
		public function FuseTemplate()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			item_template_id1 = data.readInt();
			item_template_id2 = data.readInt();
			fusion_num = data.readInt();
			fusion_template_id = data.readInt();
		}
	}
}