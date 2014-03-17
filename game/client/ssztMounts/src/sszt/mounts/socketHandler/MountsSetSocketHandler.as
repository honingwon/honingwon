package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.mounts.MountsModule;
	
	public class MountsSetSocketHandler extends BaseSocketHandler
	{	
		public static function add(mountsModule:MountsModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new MountsReleaseSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsGrowUpdateSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsQualityUpdateSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsUpdateSkillSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsExpUpdateSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsStatisUpdateSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsAttUpdateSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsRefreshSkillBooksSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsGetSkillBookItemSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsGetSkillBookListSocketHandler(mountsModule));
			GlobalAPI.socketManager.addSocketHandler(new MountsRefinedSocketHandler(mountsModule));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_RELEASE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_GROW_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_QUALITY_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_SKILL_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_EXP_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_STAIRS_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_ATT_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_SKILL_ITEM_REFRESH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_SKILL_ITEM_GET);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_GET_SKILL_BOOK_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MOUNTS_REFINED);
		}
	}
}