package sszt.core.data.titles
{
	import flash.utils.ByteArray;

	public class TitleTemplateInfo
	{
		public var id:int;
		public var name:String;
		public var type:int;
		public var quality:int;
		/**
		 * 附加效果
		 */		
		public var effects:String;
		public var descript:String;
		
		public var pic:String;
		
		public function TitleTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
			type = data.readInt();
			quality = data.readInt();
			effects = data.readUTF();
			descript = data.readUTF();
			pic = data.readUTF();
		}
	}
}