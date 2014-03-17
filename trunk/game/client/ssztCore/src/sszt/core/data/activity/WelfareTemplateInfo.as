package sszt.core.data.activity
{
	import flash.utils.ByteArray;

	public class WelfareTemplateInfo
	{
		public var id:int;
		public var title:String;
		public var descript:String;
		public var awards:Array;
		public var platType:int;     //平台类型
		public var type:int;         //礼包类型
		
		public function WelfareTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			title = data.readUTF();
			awards = data.readUTF().split(",");
			descript = data.readUTF();
			platType = data.readInt();
			type = data.readInt();
//			if(id == 10) type = 2;
		}
	}
}