package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.marriage.MarriageModule;

	public class MarriageSetSocketHandler
	{
		public static function add(module:MarriageModule):void
		{
			
			GlobalAPI.socketManager.addSocketHandler(new MarryRequestSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new WeddingGetGiftSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new WeddingGiftListUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new WeddingPresentGiftSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new WeddingPresentCandiesSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new WeddingCeremonySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new WeddingLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MarryEchoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new WeddingEndSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MarriageRelationListSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MarriageRelationChangeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new DivorceSocketHandler(module));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MARRY_REQUEST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WEDDING_GET_CASH_GIFT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WEDDING_SEE_GIFT_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WEDDING_GIVE_GIFT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WEDDING_SEND_CANDY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.START_WEDDING);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.WEDDING_QUIT_HALL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MARRY_ECHO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.END_WEDDING);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MARRY_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MARRY_CHANGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.DIVORCE);
		}
	}
}