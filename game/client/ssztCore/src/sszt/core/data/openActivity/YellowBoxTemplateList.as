package sszt.core.data.openActivity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class YellowBoxTemplateList
	{
		
		public static var yellowBoxDic:Dictionary = new Dictionary();
		public static var yellowBoxArray:Array = [];
		public static var yellowBoxTypeOneArray:Array = [];
		public static var yellowBoxTypeTwoArray:Array = [];
		public static var yellowBoxTypeThreeArray:Array = [];
		public static var yellowBoxTypeFourArray:Array = [];
		public static var yellowBoxTypeFiveArray:Array = [];
		public static var yellowBoxTypeSixArray:Array = [];
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var yellowBoxInfo:YellowBoxTemplateListInfo = new YellowBoxTemplateListInfo();
				yellowBoxInfo.parseData(data);
				yellowBoxDic[yellowBoxInfo.id] = yellowBoxInfo;
				yellowBoxArray[i] = yellowBoxInfo;
				switch(yellowBoxInfo.types)
				{
					case 0:
						yellowBoxTypeOneArray.push(yellowBoxInfo);
						break;
					case 1:
						yellowBoxTypeTwoArray.push(yellowBoxInfo);
						break;
					case 2:
						yellowBoxTypeThreeArray.push(yellowBoxInfo);
						break;
					case 3:
						yellowBoxTypeFourArray.push(yellowBoxInfo);
						break;
					case 4:
						yellowBoxTypeFiveArray.push(yellowBoxInfo);
						break;
					case 5:
						yellowBoxTypeSixArray.push(yellowBoxInfo);
						break;
				}
			}
		}
		
		public static function getYellowBox(id:int):YellowBoxTemplateListInfo
		{
			return yellowBoxDic[id];
		}
		
		public static function getYellowBoxByIndex(index:int):YellowBoxTemplateListInfo
		{
			return yellowBoxArray[index];
		}
	}
}