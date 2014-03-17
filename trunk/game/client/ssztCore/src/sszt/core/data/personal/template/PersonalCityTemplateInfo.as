package sszt.core.data.personal.template
{
	import flash.utils.ByteArray;

	public class PersonalCityTemplateInfo
	{
		public var cityId:int;
		public var cityName:String;
		public var provinceId:int;
		
		public function parseData(data:ByteArray):void
		{
			cityId = data.readInt();
			cityName = data.readUTF();
			provinceId = data.readInt();
		}
	}
}