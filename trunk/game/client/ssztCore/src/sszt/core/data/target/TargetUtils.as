package sszt.core.data.target
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;

	/**
	 * 目标成就使用类 
	 * @author chendong
	 * 
	 */	
	public class TargetUtils
	{
		/**
		 * 目标分类总数 
		 */		
		public static var TARGET_TYPE_NUM:int = 5;
		public static var TARGET_TYPE:int = 0;
		/**
		 * 成就分类总素 
		 */		
		public static var ACH_TYPE_NUM:int = 8;
		public static var ACH_TYPE:int = 1;
		
		/**
		 * 1等级
		 */
		private static var _OneLevel:int = 1;
		/**
		 * 30等级
		 */
		private static var _ThirtyLevel:int = 30;
		/**
		 * 31等级
		 */
		private static var _ThirtyOneLevel:int = 31;
		/**
		 * 50等级
		 */
		private static var _FiftyLevel:int = 50;
		/**
		 * 51等级
		 */
		private static var _FiftyOneLevel:int = 51;
		/**
		 * 60等级
		 */
		private static var _SixtyLevel:int = 60;
		/**
		 * 61等级
		 */
		private static var _SixtyOneLevel:int = 61;
		/**
		 * 70等级
		 */
		private static var _SeventyLevel:int = 70;
		/**
		 * 71等级
		 */
		private static var _SeventyOneLevel:int = 71;
		/**
		 * 80等级
		 */
		private static var _EightyLevel:int = 80;
		
		/**
		 * 
		 * 在各个目标分类中都不存在完成且未领取的目标，则默认选择当前玩家等级
		 * @return 
		 * 
		 */
		public static function getTarType():int
		{
			var tarbIndex:int = 0;
			if(GlobalData.selfPlayer.level >= _OneLevel && GlobalData.selfPlayer.level <= _ThirtyLevel)
			{
				tarbIndex = 0;
			}
			else if(GlobalData.selfPlayer.level >= _ThirtyOneLevel && GlobalData.selfPlayer.level <= _FiftyLevel)
			{
				tarbIndex = 1;
			}
			else if(GlobalData.selfPlayer.level >= _FiftyOneLevel && GlobalData.selfPlayer.level <= _SixtyLevel)
			{
				tarbIndex = 2;
			}
			else if(GlobalData.selfPlayer.level >= _SixtyOneLevel && GlobalData.selfPlayer.level <= _SeventyLevel)
			{
				tarbIndex = 3;
			}
			else if(GlobalData.selfPlayer.level >= _SeventyOneLevel)
			{
				tarbIndex = 4; 
			}
			return tarbIndex;
		}
		
		/**
		 * 选择当前等级的目标类型
		 * @param playerLevel 玩家等级
		 * 
		 */
		private function selectCurrentType(playerLevel:int):int
		{
			var currentType:int = -1;
			if(playerLevel <= _ThirtyLevel)
			{
				currentType = 0;
			}
			else if(playerLevel >= _ThirtyOneLevel && playerLevel <= _FiftyLevel)
			{
				currentType = 1;
			}
			else if(playerLevel >= _FiftyOneLevel && playerLevel <= _SixtyLevel)
			{
				currentType = 2;
			}
			else if(playerLevel >= _SixtyOneLevel && playerLevel <= _SeventyLevel)
			{
				currentType = 3;
			}
			else
			{
				currentType = 4;
			}
			return currentType;
		}
		
		/**
		 * 获得当前目标类型,完成未领取的数量
		 * @param currentType 目标类型
		 * @return 
		 * 
		 */
		public static function getTargetCompleteNum(currentType:int):int
		{
			var targetArray:Array = [];
			var targetInfo:TargetTemplatInfo;
			var targetTemplateArray:Array = getTargetTemplateData(currentType);
			var num:int = 0;
			var targetData:TargetData = null;
			if(getTabEnabled(currentType))
			{
				//完成未领取
				for each (targetInfo in targetTemplateArray)
				{
					targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
					if(targetData && targetData.isFinish && !targetData.isReceive)
					{
						num++;
					}
				}
			}
			return num;
		}
		
		/**
		 *  
		 * 获得当前目标类型,完成并领取的数量
		 * @param currentType 目标类型
		 * @return 
		 * 
		 */
		public static function getTargetCompletedNum(currentType:int):int
		{
			var targetArray:Array = [];
			var targetInfo:TargetTemplatInfo;
			var targetTemplateArray:Array = getTargetTemplateData(currentType);
			var num:int = 0;
			var targetData:TargetData = null;
			//完成未领取
			for each (targetInfo in targetTemplateArray)
			{
				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
				if(targetData && targetData.isFinish && targetData.isReceive)
				{
					num++;
				}
			}
			return num;
		}
		
		/**
		 * 当前目标类型总数
		 * @param currentType 目标类型
		 * @return  
		 * 
		 */
		public static function getTargetTotalNum(currentType:int):int
		{
			var targetArray:Array = [];
			var targetInfo:TargetTemplatInfo;
			var targetTemplateArray:Array = getTargetTemplateData(currentType);
			var num:int = targetTemplateArray.length;
			return num;
		}
		
		/**
		 * 更具目标类型获得目标模板数据
		 * @param currentType 目标类型
		 * @return 
		 * 
		 */
		public static function getTargetTemplateData(currentType:int):Array
		{
			var templateData:Array = [];
			switch(currentType)
			{
				case 0:
					templateData = TargetTemplateList.targetOneType;
					break;
				case 1:
					templateData = TargetTemplateList.targetTwoType;
					break;
				case 2:
					templateData = TargetTemplateList.targetThreeType;
					break;
				case 3:
					templateData = TargetTemplateList.targetFourType;
					break;
				case 4:
					templateData = TargetTemplateList.targetFiveType;
					break;
			}
			return templateData;
		}
		
		/**
		 * 获得当前成就类型,完成未领取的数量
		 * @param currentType 目标类型
		 * @return 
		 * 
		 */
		public static function getAchCompleteNum(currentType:int):int
		{
			var achInfo:TargetTemplatInfo;
			var achTemplateArray:Array = getAchTemplateData(currentType);
			var num:int = 0;
			var targetData:TargetData = null;
			//完成未领取
			for each (achInfo in achTemplateArray)
			{
				targetData = GlobalData.targetInfo.achByIdDic[achInfo.target_id];
				if(targetData && targetData.isFinish && !targetData.isReceive)
				{
					num++;
				}
			}
			return num;
		}
		
		/**
		 * 更具目标类型获得目标模板数据
		 * @param currentType 目标类型
		 * @return 
		 * 
		 */
		public static function getAchTemplateData(currentType:int):Array
		{
			var templateData:Array = [];
			switch(currentType)
			{
				case 1:
					templateData = TargetTemplateList.achOneType;
					break;
				case 2:
					templateData = TargetTemplateList.achTwoType;
					break;
				case 3:
					templateData = TargetTemplateList.achThreeType;
					break;
				case 4:
					templateData = TargetTemplateList.achFourType;
					break;
				case 5:
					templateData = TargetTemplateList.achFiveType;
					break;
				case 6:
					templateData = TargetTemplateList.achSixType;
					break;
				case 7:
					templateData = TargetTemplateList.achSevenType;
					break;
				case 8:
					templateData = TargetTemplateList.achEightType;
					break;
			}
			return templateData;
		}
		
		/**
		 * 当前成就类型的总成就输
		 * @param currentType 当前成就类型
		 * @return 
		 * 
		 */
		public static function getAchTypeNum(currentType:int):int
		{
			var achTypeNum:int = 0;
			switch(currentType)
			{
				case 1:
					achTypeNum = TargetTemplateList.achOneType.length;
					break;
				case 2:
					achTypeNum = TargetTemplateList.achTwoType.length;
					break;
				case 3:
					achTypeNum = TargetTemplateList.achThreeType.length;
					break;
				case 4:
					achTypeNum = TargetTemplateList.achFourType.length;
					break;
				case 5:
					achTypeNum = TargetTemplateList.achFiveType.length;
					break;
				case 6:
					achTypeNum = TargetTemplateList.achSixType.length;
					break;
				case 7:
					achTypeNum = TargetTemplateList.achSevenType.length;
					break;
				case 8:
					achTypeNum = TargetTemplateList.achEightType.length;
					break;
			}
			return achTypeNum;
		}
		
		/**
		 * 根据等级判断该type是否可用
		 * @param type 目标类型
		 * @return 
		 * 
		 */
		public static function getTabEnabled(type:int):Boolean
		{
			var tabEnabled:Boolean = false;
			switch(type)
			{
				case 0:
					if(GlobalData.selfPlayer.level >= _OneLevel)
					{
						tabEnabled = true;
					}
					break;
				case 1:
					if(GlobalData.selfPlayer.level >= _ThirtyOneLevel)
					{
						tabEnabled = true;
					}
					break;
				case 2:
					if(GlobalData.selfPlayer.level >= _FiftyOneLevel)
					{
						tabEnabled = true;
					}
					break;
				case 3:
					if(GlobalData.selfPlayer.level >= _SixtyOneLevel)
					{
						tabEnabled = true;
					}
					break;
				case 4:
					if(GlobalData.selfPlayer.level >= _SeventyOneLevel)
					{
						tabEnabled = true;
					}
					break;
			}
			return tabEnabled;
		}
		
		public static function getTargetArray(currentType:int):Array
		{
			var targetArray:Array = [];
			var targetInfo:TargetTemplatInfo;
			var targetTemplateArray:Array = TargetUtils.getTargetTemplateData(currentType);
			var targetData:TargetData = null;
			//完成未领取
			for each (targetInfo in targetTemplateArray)
			{
				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
				if(targetData && targetData.isFinish && !targetData.isReceive)
				{
					targetArray.push(targetInfo);
				}
			}
			
			//在完成过程当中
			for each (targetInfo in targetTemplateArray)
			{
				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
				if(targetData && !targetData.isFinish && !targetData.isReceive)
				{
					targetArray.push(targetInfo);
				}
			}
			
			//未完成未领取
			for each (targetInfo in targetTemplateArray)
			{
				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
				if(!targetData)
				{
					targetArray.push(targetInfo);
				}
			}
			
			//完成已领取
			for each (targetInfo in targetTemplateArray)
			{
				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
				if(targetData && targetData.isFinish && targetData.isReceive)
				{
					targetArray.push(targetInfo);
				}
			}
			return targetArray;
		}
	}
}