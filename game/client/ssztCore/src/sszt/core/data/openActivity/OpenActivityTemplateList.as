package sszt.core.data.openActivity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class OpenActivityTemplateList
	{
		
		public static var activityDic:Dictionary = new Dictionary();
		public static var activityArray:Array = [];
		public static var activityTypeOneArray:Array = [];
		public static var activityTypeTwoArray:Array = [];
		public static var activityTypeThreeArray:Array = [];
		public static var activityTypeFour1Array:Array = [];
		public static var activityTypeFour2Array:Array = [];
		public static var activityTypeFour3Array:Array = [];
		public static var activityTypeFour4Array:Array = [];
		public static var activityTypeFiveArray:Array = [];
		public static var activityTypeSixArray1:Array = [];
		public static var activityTypeSixArray2:Array = [];
		public static var activityTypeSixArray3:Array = [];
		public static var activityTypeSevenArray:Array = [];
		public static var activityTypeEightArray1:Array = [];
		public static var activityTypeEightArray2:Array = [];
		public static var activityTypeEightArray3:Array = [];
		public static var activityTypeEightArray4:Array = [];
		
		public static var activityTypeRecArray1:Array = [];
		public static var activityTypeRecArray2:Array = [];
		public static var activityTypeRecArray3:Array = [];
		public static var activityTypeRecArray4:Array = [];
		public static var activityTypeRecArray5:Array = [];
		public static var activityTypeRecArray6:Array = [];
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var activityInfo:OpenActivityTemplateListInfo = new OpenActivityTemplateListInfo();
				activityInfo.parseData(data);
				activityDic[activityInfo.id] = activityInfo;
				activityArray[i] = activityInfo;
				switch(activityInfo.group_id)
				{
					case 1:
						activityTypeOneArray.push(activityInfo);
						break;
					case 2:
						activityTypeTwoArray.push(activityInfo);
						break;
					case 3:
						activityTypeThreeArray.push(activityInfo);
						break;
					case 41:
						activityTypeFour1Array.push(activityInfo);
						break;
					case 42:
						activityTypeFour2Array.push(activityInfo);
						break;
					case 43:
						activityTypeFour3Array.push(activityInfo);
						break;
					case 44:
						activityTypeFour4Array.push(activityInfo);
						break;
					case 51:
						activityTypeSixArray1.push(activityInfo);
						break;
					case 52:
						activityTypeSixArray2.push(activityInfo);
						break;
					case 53:
						activityTypeSixArray3.push(activityInfo);
						break;
					case 6:
						activityTypeSevenArray.push(activityInfo);
						break;
					case 71:
						activityTypeEightArray1.push(activityInfo);
						break;
					case 72:
						activityTypeEightArray2.push(activityInfo);
						break;
					case 73:
						activityTypeEightArray3.push(activityInfo);
						break;
					case 74:
						activityTypeEightArray4.push(activityInfo);
						break;
					case 81:
						activityTypeRecArray1.push(activityInfo);
						break;
					case 82:
						activityTypeRecArray2.push(activityInfo);
						break;
					case 83:
						activityTypeRecArray3.push(activityInfo);
						break;
					case 84:
						activityTypeRecArray4.push(activityInfo);
						break;
					case 85:
						activityTypeRecArray5.push(activityInfo);
						break;
					case 86:
						activityTypeRecArray6.push(activityInfo);
						break;
				}
			}
		}
		
		public static function getActivity(id:int):OpenActivityTemplateListInfo
		{
			return activityDic[id];
		}
		
		public static function getActivityByIndex(index:int):OpenActivityTemplateListInfo
		{
			return activityArray[index];
		}
	}
}