package sszt.pet.data
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.pet.PetItemInfo;
	import sszt.pet.event.PetEvent;
	
	public class PetsInfo extends EventDispatcher
	{
		public static const PET_QUALITY_MAX:int = 100;
		public static const PET_GROW_MAX:int = 100;
		public static const PET_STAIRS_MAX:int = 12;
		public static const PET_AMOUNT_MAX:int = 12;
		public static const PET_SKILL_CELL_NUM_MAX:int = 12;
		
		/**
		 * 宠物技能书刷新数据
		 * */
		public var petRefreshSkillBooksInfo:PetRefreshSkillBooksInfo;
		
		public var currentPetItemInfo:PetItemInfo;
 
		public function PetsInfo()
		{
			super();
		}
		
		public function switchPetTo(petTo:PetItemInfo):void
		{
			currentPetItemInfo = petTo;
			dispatchEvent(new PetEvent(PetEvent.PET_SWITCH));
		}
		
		public function initPetRefreshSkillBooksInfo():void
		{
			if(!petRefreshSkillBooksInfo)
			{
				petRefreshSkillBooksInfo = new PetRefreshSkillBooksInfo();
			}
		}
		
		public function clearPetRefreshSkillBooksInfo():void
		{
			if(petRefreshSkillBooksInfo)
			{
				petRefreshSkillBooksInfo.dispose();
				petRefreshSkillBooksInfo = null;
			}
		}
	}
}