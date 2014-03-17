package sszt.pet.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.pet.PetModule;
	
	public class PetSetSocketHandler extends BaseSocketHandler
	{	
		public static function add(petModule:PetModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new PetGetSkillBookListSocketHandler(petModule));
			GlobalAPI.socketManager.addSocketHandler(new PetRefreshSkillBooksSocketHandler(petModule));
			GlobalAPI.socketManager.addSocketHandler(new PetGetSkillBookItemSocketHandler(petModule));
			GlobalAPI.socketManager.addSocketHandler(new PetStatisUpdateSocketHandler(petModule));
			GlobalAPI.socketManager.addSocketHandler(new PetGrowUpdateSocketHandler(petModule));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_GET_SKILL_BOOK_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_SKILL_ITEM_REFRESH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_SKILL_ITEM_GET);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_STAIRS_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_GROW_UPDATE);
		}
	}
}