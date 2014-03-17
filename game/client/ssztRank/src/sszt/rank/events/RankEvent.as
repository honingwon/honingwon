package sszt.rank.events
{
	import flash.events.Event;
	
	public class RankEvent extends Event
	{
		public static const COPY_RANK_LIST_UPDATE:String = "copyRankListUpdate";	
		public static const RANK_INFO_LOADED:String = 'rankInfoLoaded';
		
		
		
		public static const PAGE_UPDATE:String = "pageUpdate";		
		public static const MONEYRANKLIST_UPDATE:String = "moneyRankListUpdate";
		public static const LEVELRANKLIST_UPDATE:String = "levelRankListUpdate";
		public static const STRIKERANKLIST_UPDATE:String = "strikeRankListUpdate";
		public static const CLUBRANKLIST_UPDATE:String = "clubRankListUpdate";
//		public static const COPYRANKLIST_UPDATE:String = "copyRankListUpdate";
		public static const MULTI_COPYRANKLIST_UPDATE:String = "multiCopyRankListUpdate";
//		public static const SINGLE_COPYRANKLIST_UPDATE:String = "singleCopyRankListUpdate";
		public static const EQUIPRANKLIST_UPDATE:String = "equipRankListUpdate";
		public static const PETLEVELRANKLIST_UPDATE:String = "petLevelRankListUpdate";
		public static const PETAPTITUDERANKLIST_UPDATE:String = "petAptitudeRankListUpdate";
		public static const PETGROWRANKLIST_UPDATE:String = "petGrowRankListUpdate";
		
		public static const RANK_DATA_LOADED:String = "rankDataLoaded";
		
		public static const SHENMOISLAND_UPDATE:String = "shenMoIslandUpdate";
		
		public var data:Object;
		
		public function RankEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = obj;
		}
	}
}