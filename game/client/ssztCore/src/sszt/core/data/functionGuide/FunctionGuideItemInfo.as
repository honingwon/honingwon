package sszt.core.data.functionGuide
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.LayerInfo;
	
	public class FunctionGuideItemInfo extends LayerInfo
	{
		/**所需等级**/
		public var level:int;
		/**标题**/
		public var title:String;
		/**描述**/
		public var descript:String;
		/**宣传画地址**/
		public var propagandisticPicPath:String;
		
		public var place:int;
		
		public function FunctionGuideItemInfo()
		{
			super();
		}
		
		public function loadData(data:ByteArray):void
		{
			templateId = data.readInt();
			title = data.readUTF();
			level = data.readInt();
			picPath = iconPath = data.readUTF();
			propagandisticPicPath = data.readUTF();
			descript = data.readUTF();
		}
	}
}