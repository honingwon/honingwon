package sszt.core.data.challenge
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ChallengeTemplateList
	{
		
		public static var challDic:Dictionary = new Dictionary();
		public static var challArray:Array = [];
		public static var challTypeOneArray:Array = [];
		public static var challTypeTwoArray:Array = [];
		public static var challTypeThreeArray:Array = [];
		public static var challTypeFourArray:Array = [];
		public static var challTypeFiveArray:Array = [];
		public static var challTypeSixArray:Array = [];
		public static var challTypeSevenArray:Array = [];
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var challInfo:ChallengeTemplateListInfo = new ChallengeTemplateListInfo();
				challInfo.parseData(data);
				challDic[challInfo.challengeId] = challInfo;
				challArray[i] = challInfo;
				
				switch(challInfo.storey)
				{
					case 1:
						challTypeOneArray.push(challInfo);
						break;
					case 2:
						challTypeTwoArray.push(challInfo);
						break;
					case 3:
						challTypeThreeArray.push(challInfo);
						break;
					case 4:
						challTypeFourArray.push(challInfo);
						break;
					case 5:
						challTypeFiveArray.push(challInfo);
						break;
					case 6:
						challTypeSixArray.push(challInfo);
						break;
					case 7:
						challTypeSevenArray.push(challInfo);
						break;
				}
			}
		}
		
		public static function getChall(id:int):ChallengeTemplateListInfo
		{
			return challDic[id];
		}
		
		public static function getChallByIndex(index:int):ChallengeTemplateListInfo
		{
			return challArray[index];
		}
	}
}