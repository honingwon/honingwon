package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class PetQualificationExpTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public static var PET_QUALITY_LEVEL_MAX:int = 100;
		
		public function PetQualificationExpTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:PetQualificationExpTemplate = new PetQualificationExpTemplate();
				info.parseData(data);
				if(!infoList[info.level])
				{
					infoList[info.level] = info;
				}
			}
		}
		
		public static function getQualificationExp(qualificationLevel:int):PetQualificationExpTemplate
		{
			return infoList[qualificationLevel];
		}
		
		//获取升到下一级所需经验
		public static function getQualificationUpgradeExp(currentQualityLevel:int):int
		{
			return getQualificationExp(currentQualityLevel + 1).exp
		}

		//升到下一级所需经验已获取数量
		public static function getQualificationUpgradeExpGained(currentQualificationLevel:int, qualificationExpTotal:int):int
		{
			return qualificationExpTotal - getQualificationExp(currentQualificationLevel).totalExp;
		}
	}
}