package sszt.challenge.components
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.challenge.ChallengeInfo;
	import sszt.core.data.challenge.ChallengeTemplateList;
	import sszt.core.data.challenge.ChallengeTemplateListInfo;

	public class ChallengeUtils
	{
		
		/**
		 * 获得当前层 
		 * @return 
		 * 
		 */		
		public  static function getCurrentLayer():int
		{
			var currentLayer:int = 0;
			var layerStarArray:Array = GlobalData.challInfo.challInfo; 
			var currentMarkIndex:int = 0;
			for(var i:int; i<layerStarArray.length;i++)
			{
				if(layerStarArray[i] <=0)
				{
					currentMarkIndex = i;
					break;
				}
			}
			var k:int=0;
			var endIndex:int =0;
			for(var j:int=0; j<layerStarArray.length;j+=ChallengeInfo.MARK_LAYER_NUM)
			{
				endIndex = j + ChallengeInfo.MARK_LAYER_NUM;
				if(currentMarkIndex >= j && currentMarkIndex < endIndex)
				{
					currentLayer = k;
					break;
				}
				++k;
			}
			return currentLayer;
		}
		
		/**
		 *  获得当前关卡评星等级
		 * @param currentLayer 当前层
		 * @param currMark 当前关卡
		 * @return 
		 * 
		 */		
		public static function getCurrentMarkStar(currentLayer:int,currMark:int):int
		{
			var starIndex:int = currentLayer * ChallengeInfo.MARK_LAYER_NUM + currMark;
			var tempChallInfo:Array = GlobalData.challInfo.challInfo;
			return tempChallInfo[starIndex];
		}
		
		
		/**
		 * 判断当前关卡的前置关卡是否通过   
		 * @param currentLayer 当前层
		 * @param currMark 当前关卡
		 * @param isCurrMark true,判断当前关口;false,判断前置关卡
		 * * @return 
		 */		
		public static function getCurrMarkPreOpen(currentLayer:int,currMark:int,isCurrMark:Boolean=false):Boolean
		{
			var currStarIndex:int = currentLayer * ChallengeInfo.MARK_LAYER_NUM + currMark;
			var preStarIndex:int = currStarIndex;
			if(!isCurrMark)
			{
				preStarIndex = currStarIndex - 1
			}
			var tempChallInfo:Array = GlobalData.challInfo.challInfo;
			var retureBoolean:Boolean = false;
			if(tempChallInfo[preStarIndex] && tempChallInfo[preStarIndex] > 0)
			{
				retureBoolean = true;
			}
			else
			{
				retureBoolean = false;
			}
			
			return retureBoolean;
		}
		
		/**
		 * 获得当前层,最后开启的关卡
		 * @param currlayer 当前层  0-5层
		 * @return 
		 * 
		 */
		public static function getCurrentLayerLastMark(currlayer:int):int
		{
			var currentLayer:int = currlayer;
			var lastMark:int = 0;
			var layerStarArray:Array = GlobalData.challInfo.getLayerStar(currentLayer);
			for(var i:int=0;i<layerStarArray.length;i++)
			{
				if(layerStarArray[i] <= 0)
				{
					lastMark = i;
					break;
				}
			}
			return lastMark;
		}
		
		/**
		 *  根据当前层获得该层的关卡 
		 * @param Ceng 当前层
		 * @return 
		 * 
		 */		
		public static function getMarkArrayByCeng(Ceng:int):Array
		{
			var newCeng:int = Ceng + 1;
			var markArray:Array;
			switch(newCeng)
			{
				case 1:
					markArray = ChallengeTemplateList.challTypeOneArray;
					break;
				case 2:
					markArray = ChallengeTemplateList.challTypeTwoArray;
					break;
				case 3:
					markArray = ChallengeTemplateList.challTypeThreeArray;
					break;
				case 4:
					markArray = ChallengeTemplateList.challTypeFourArray;
					break;
				case 5:
					markArray = ChallengeTemplateList.challTypeFiveArray;
					break;
				case 6:
					markArray = ChallengeTemplateList.challTypeSixArray;
					break;
				case 7:
					markArray = ChallengeTemplateList.challTypeSevenArray;
					break;
			}
			return markArray;
		}
		
		public static function getChallengeTemplateInfoBy(challengeId:int):ChallengeTemplateListInfo
		{
			challengeId += 1;
			return ChallengeTemplateList.challDic[challengeId];
		}
		
		/**
		 * 判断当前层的前置层的关卡是否已经全部通过 
		 * @param currlayer 0-5
		 * @return 
		 */		
		public static function preLayerOver(currlayer:int):Boolean
		{
			var tempBoole:Boolean = true;
			var prelayer:int = currlayer - 1;
			var starArray:Array = GlobalData.challInfo.getLayerStar(prelayer);
			for(var i:int=0;i<starArray.length;i++)
			{
				if(starArray[i] <= 0)
				{
					tempBoole = false;
					break;
				}
			}
			return tempBoole;
		}
	}
}