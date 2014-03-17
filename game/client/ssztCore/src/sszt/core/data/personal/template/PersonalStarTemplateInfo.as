package sszt.core.data.personal.template
{
	import flash.utils.ByteArray;

	public class PersonalStarTemplateInfo
	{
		public var starId:int;
		public var starName:String;
		
		public function parseData(data:ByteArray):void
		{
			starId = data.readInt();
			starName = data.readUTF();
		}
	}
}