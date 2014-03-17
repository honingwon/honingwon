package sszt.core.data.personal.template
{
	import flash.utils.ByteArray;

	public class PersonalProvinceTemplateInfo
	{
		public var provinceId:int;
		public var provinceName:String;
		
		public function parseData(data:ByteArray):void
		{
			provinceId = data.readInt();
			provinceName = data.readUTF();
		}
	}
}