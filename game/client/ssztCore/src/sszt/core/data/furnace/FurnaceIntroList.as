package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;

	public class FurnaceIntroList
	{
		private static var _introList:Dictionary = new Dictionary();
		public function FurnaceIntroList()
		{
		}
		
		public static function setup(data:ByteArray):void
		{
			if(!data.readBoolean())
			{
				MAlert.show(data.readUTF());
				return;
			}
			data.readUTF();
			var len:int = data.readInt();
			for(var i:int=0;i<len;i++)
			{
				var introInfo:FurnaceIntroInfo = new FurnaceIntroInfo();
				introInfo.parseData(data);
				_introList[introInfo.index] = introInfo;
			}
		}
		
		public static function getIntroInfo(index:int):FurnaceIntroInfo
		{
			return _introList[index];
		}
	}
}