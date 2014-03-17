package sszt.core.data.skill
{
	import flash.utils.ByteArray;

	public class SkillTemplateDescriptInfo
	{
		public var id:int;
		public var script:String;
		
		public function SkillTemplateDescriptInfo():void
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			script = data.readUTF();
		}
	}
}