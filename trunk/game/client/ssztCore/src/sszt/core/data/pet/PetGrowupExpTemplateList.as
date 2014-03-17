package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class PetGrowupExpTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public static var PET_GROW_UP_LEVEL_MAX:int = 100;
		
		public function PetGrowupExpTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:PetGrowupExpTemplate = new PetGrowupExpTemplate();
				info.parseData(data);
				if(!infoList[info.level])
				{
					infoList[info.level] = info;
				}
			}
		}
			
		public static function getGrowUpExp(growLevel:int):PetGrowupExpTemplate
		{
			return infoList[growLevel];
		}
		
		public static function getGrowUpgradeExp(currentGrowLevel:int):int
		{
			return getGrowUpExp(currentGrowLevel + 1).exp
		}
		
		public static function getGrowUpgradeExpGained(currentGrowLevel:int, growUpExpTotal:int):int
		{
			return growUpExpTotal - getGrowUpExp(currentGrowLevel).totalExp;
		}
	}
}