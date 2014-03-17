package sszt.core.data.target
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class TargetTemplateList
	{
		/**
		 * 按类型分类目标 
		 */
		public static var targetByType:Dictionary = new Dictionary();
		
		/**
		 * 按目标id分类 
		 */
		public static var targetById:Dictionary = new Dictionary();
		
		/**
		 * 按类型分目标内容
		 */
		public static var targetContentByType:Dictionary = new Dictionary();
		
		/**
		 * 类型1目标 
		 */
		public static var targetOneType:Array = [];
		/**
		 * 类型2目标 
		 */
		public static var targetTwoType:Array = [];
		/**
		 * 类型3目标 
		 */
		public static var targetThreeType:Array = [];
		/**
		 * 类型4目标 
		 */
		public static var targetFourType:Array = [];
		/**
		 * 类型5目标 
		 */
		public static var targetFiveType:Array = [];
		
		/**
		 * 类型1成就
		 */
		public static var achOneType:Array = [];
		/**
		 * 类型2成就 
		 */
		public static var achTwoType:Array = [];
		/**
		 * 类型3成就 
		 */
		public static var achThreeType:Array = [];
		/**
		 * 类型4成就 
		 */
		public static var achFourType:Array = [];
		/**
		 * 类型5成就 
		 */
		public static var achFiveType:Array = [];
		/**
		 * 类型6成就 
		 */
		public static var achSixType:Array = [];
		/**
		 * 类型7成就 
		 */
		public static var achSevenType:Array = [];
		/**
		 * 类型8成就 
		 */
		public static var achEightType:Array = [];
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:TargetTemplatInfo = new TargetTemplatInfo();
				info.parseData(data);
				targetById[info.target_id] = info;
				if(!targetContentByType[info.taclass])
				{
					targetContentByType[info.taclass] = info.content;
				}
				if(info.type == 0)
				{
					switch(info.taclass)
					{
						case 1:
							targetOneType.push(info);
							break;
						case 2:
							targetTwoType.push(info);
							break;
						case 3:
							targetThreeType.push(info);
							break;
						case 4:
							targetFourType.push(info);
							break;
						case 5:
							targetFiveType.push(info);
							break;
					}
				}
				else
				{
					switch(info.taclass)
					{
						case 1:
							achOneType.push(info);
							break;
						case 2:
							achTwoType.push(info);
							break;
						case 3:
							achThreeType.push(info);
							break;
						case 4:
							achFourType.push(info);
							break;
						case 5:
							achFiveType.push(info);
							break;
						case 6:
							achSixType.push(info);
							break;
						case 7:
							achSevenType.push(info);
							break;
						case 8:
							achEightType.push(info);
							break;
					}
				}
			}
		}
		
		public static function getTargetByTypeTemplate(type:int=-1):TargetTemplatInfo
		{
			return targetByType[type];
		}
		
		public static function getTargetByIdTemplate(id:int=-1):TargetTemplatInfo
		{
			return targetById[id];
		}
		
		public static function getTargetContentByType(taclass:int=-1):String
		{
			return targetContentByType[taclass];
		}
	}
}