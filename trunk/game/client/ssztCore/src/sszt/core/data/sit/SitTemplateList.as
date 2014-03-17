package sszt.core.data.sit
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.data.sit.SitTemplateInfo;
	
	public class SitTemplateList
	{
		public static var Sits:Dictionary = new Dictionary();
		public static var groupSitNames:Dictionary = new Dictionary();
		
		public static function setup(data:ByteArray):void
		{
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var Sit:SitTemplateInfo = new SitTemplateInfo();
					Sit.parseData(data);
					Sits[Sit.level] = Sit;
				}
//			}
		}
		
		public static function getSit(id:int):SitTemplateInfo
		{
			return Sits[id];
		}
		
	}
}