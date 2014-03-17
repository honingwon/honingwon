package sszt.pet.util
{
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.pet.data.PetAttrAttackType;
	import sszt.pet.data.PetStateType;

	public class PetUtil
	{
		public function PetUtil()
		{
		}
		
		/**
		 * 获取默认选中的宠物，出战宠物优先。
		 */
		public static function getSelectedPetDefault():PetItemInfo
		{
			var ret:PetItemInfo;
			var petInfoList:Array = GlobalData.petList.getList();
			if(petInfoList.length > 0)
			{
				for each(var petItemInfo:PetItemInfo in petInfoList)
				{
					if(petItemInfo.state == PetStateType.FIGHT)
					{
						ret = petItemInfo;
						break;
					}
				}
				if(!ret)
				{
					ret = petInfoList[0];
				}
			}
			return ret;
		}
		
		/**
		 * 获取宠物资质丹类型
		 */
		public static function getPetQualityPillType(petQualityLevel:int):int
		{
			var ret:int;
			if(petQualityLevel <=  20)
			{
				ret = CategoryType.PET_QUALITY_PILL1;
			}
			else if(petQualityLevel >= 21 && petQualityLevel <= 40)
			{
				ret = CategoryType.PET_QUALITY_PILL2;
			}
			else if(petQualityLevel >= 41 && petQualityLevel <= 60)
			{
				ret = CategoryType.PET_QUALITY_PILL3;
			}
			else if(petQualityLevel >= 61 && petQualityLevel <= 80)
			{
				ret = CategoryType.PET_QUALITY_PILL4;
			}
			else if(petQualityLevel >= 81 && petQualityLevel <= 100)
			{
				ret = CategoryType.PET_QUALITY_PILL5;
			}
			return ret;
		}
		
		/**
		 * 获取宠物成长丹类型
		 */
		public static function getPetGrowPillType(petGrowLevel:int):int
		{
			var ret:int;
			if(petGrowLevel <=  20)
			{
				ret = CategoryType.PET_GROW_PILL1;
			}
			else if(petGrowLevel >= 21 && petGrowLevel <= 40)
			{
				ret = CategoryType.PET_GROW_PILL2;
			}
			else if(petGrowLevel >= 41 && petGrowLevel <= 60)
			{
				ret = CategoryType.PET_GROW_PILL3;
			}
			else if(petGrowLevel >= 61 && petGrowLevel <= 80)
			{
				ret = CategoryType.PET_GROW_PILL4;
			}
			else if(petGrowLevel >= 81 && petGrowLevel <= 100)
			{
				ret = CategoryType.PET_GROW_PILL5;
			}
			return ret;
		}
		
		/**
		 * 获取宠物进阶丹类型
		 */
		public static function getPetStairPillType(petStairLevel:int):int
		{
			var ret:int;
			if(petStairLevel <=  1)
			{
				ret = CategoryType.PET_STAIRS_PILL1;
			}
			else if(petStairLevel >= 2 && petStairLevel <= 3)
			{
				ret = CategoryType.PET_STAIRS_PILL2;
			}
			else if(petStairLevel >= 4 && petStairLevel <= 5)
			{
				ret = CategoryType.PET_STAIRS_PILL3;
			}
			else if(petStairLevel >= 6 && petStairLevel <= 7)
			{
				ret = CategoryType.PET_STAIRS_PILL4;
			}
			else if(petStairLevel >= 8)
			{
				ret = CategoryType.PET_STAIRS_PILL5;
			}
			return ret;
		}
		
		public static function getPetAttrAttackTypeWord(type:int):String
		{
			var ret:String;
			switch(type)
			{
				case PetAttrAttackType.INNER_ATTACK :
					ret = LanguageManager.getWord('ssztl.pet.innerAttack');
					break;
				case PetAttrAttackType.OUTER_ATTACK :
					ret = LanguageManager.getWord('ssztl.pet.outerAttack');
					break;
				case PetAttrAttackType.FAR_ATTACK :
					ret = LanguageManager.getWord('ssztl.pet.farAttack');
					break;
			}
			return ret;
		}
	}
}