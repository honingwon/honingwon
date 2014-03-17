package sszt.core.data.pet
{
	import flash.utils.ByteArray;

	public class PetDialogTemplate
	{
		public var id:int;
		public var quality:int;
		public var message:String;
		
		public function PetDialogTemplate()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			quality = data.readInt();
			message = data.readUTF();
		}
	}
}