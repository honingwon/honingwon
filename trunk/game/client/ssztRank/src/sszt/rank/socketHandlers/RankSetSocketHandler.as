package sszt.rank.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.rank.RankModule;
	
	public class RankSetSocketHandler extends BaseSocketHandler
	{
		public function RankSetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function addHandlers(rankModule:RankModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new ShenMoIslandRankQueryHandler(rankModule));
			GlobalAPI.socketManager.addSocketHandler(new RankSocketHanders(rankModule));
			GlobalAPI.socketManager.addSocketHandler(new DuplicateRankSocketHanders(rankModule));
			
		}
		
		public static function removeHandlers():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_ISLAND_RANK);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.RANK);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.DUPLICATE_TOP_LIST);
			
		}
	}
}