package sszt.rank.socketHandlers
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.rank.RankModule;
	import sszt.rank.data.item.ShenMoIslandRankItem;
	
	public class ShenMoIslandRankQueryHandler extends BaseSocketHandler
	{
		public function ShenMoIslandRankQueryHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SHENMO_ISLAND_RANK;
		}
		
		override public function handlePackage():void
		{
			var dic:Dictionary = new Dictionary();
			var dataList:Array = [];
			var length:int = _data.readInt();
			rankModule.rankInfos.shenMoIslandList = [];
			for(var i:int=0; i<length; i++)
			{
				var stage:int = _data.readInt();
				var player:String = _data.readString();
				var passTime:int = _data.readInt();
				if(dic[stage])
				{
					dic[stage].playersStr += "," + player
				}
				else
				{
					var item:ShenMoIslandRankItem = new ShenMoIslandRankItem();
					item.stage = stage;
					item.playersStr = player;
					item.passTime = passTime;
					dic[stage] = item;
				}
			}
			for each(item in dic)
			{
				dataList.push(item);
			}
			dataList.sortOn(["stage"],[Array.NUMERIC | Array.DESCENDING]);
//			rankModule.rankInfos.updateShenMoIsland(dataList);
			handComplete();
		}
		
		public static function sendQuery():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SHENMO_ISLAND_RANK);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get rankModule():RankModule
		{
			return _handlerData as RankModule;
		}
	}
}