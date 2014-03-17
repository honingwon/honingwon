package sszt.core.data.sit
{
	import flash.utils.ByteArray;

	public class SitTemplateInfo
	{
		public var level:int;
		public var single_exp:int;
		public var normal_double_exp:int;
		public var special_double_exp:int;
		public var single_lifeexp:int;
		public var normal_double_lifeexp:int;
		public var special_double_lifeexp:int;
		
		public function SitTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			level = data.readInt();
			single_exp = data.readInt();
			normal_double_exp = data.readInt();
			special_double_exp = data.readInt();
			single_lifeexp = data.readInt();
			normal_double_lifeexp = data.readInt();
			special_double_lifeexp = data.readInt();
		}
	}
}