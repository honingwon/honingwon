package sszt.core.data.shenMoGuide
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;

	public class GuideInfoList
	{
		public static  var infoList:Array = [];
		public function GuideInfoList()
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
			for(var i:int = 0; i < len; i++)
			{
				var info:GuideItemInfo = new GuideItemInfo();
				info.parseData(data);
				infoList.push(info);
			}
		}
	}
}