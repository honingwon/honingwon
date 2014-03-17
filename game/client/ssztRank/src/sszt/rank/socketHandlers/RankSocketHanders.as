package sszt.rank.socketHandlers
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.rank.RankModule;
	import sszt.rank.data.RankInfo;
	import sszt.rank.data.RankItemInfo;
	import sszt.rank.data.RankType;
	import sszt.rank.data.item.IndividualRankItem;
	import sszt.rank.data.item.OtherRankItem;
	
	public class RankSocketHanders extends BaseSocketHandler
	{
		public function RankSocketHanders(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.RANK;
		}
		
		override public function handlePackage():void
		{
//			var type:int = _data.readInt();		
//			var page:int = _data.readInt();
//			var total:int = _data.readInt();
//			var len:int = _data.readInt();
//			var i:int;
//			var rankInfo:RankItemInfo;
//			var rankInfoList:Array = [];
//			for(i = 0; i < len; i++)
//			{
//				rankInfo = new RankItemInfo();
//				rankInfo.place = getPlace(i, page);
//				rankInfo.userId = _data.readNumber();
//				rankInfo.userName = _data.readUTF();
//				rankInfo.vip = _data.readShort();
//				rankInfo.vipTime = _data.readInt();
//				rankInfo.sex = _data.readByte();
//				rankInfo.career = _data.readByte();
//				var value:int = _data.readInt();
//				var category:int = RankType.getTypeCategory(type);
//				switch(category)
//				{
//					case RankType.TOP_TYPE_LEVEL :
//						rankInfo.level = value;
//						break;
//					case RankType.TOP_TYPE_FIGHT :
//						rankInfo.fight = value;
//						break;
//					case RankType.TOP_TYPE_VEINS :
//						rankInfo.veins = value;
//						break;
//					case RankType.TOP_TYPE_GENGU :
//						rankInfo.gengu = value;
//						break;
//					case RankType.TOP_TYPE_COPPER :
//						rankInfo.copper = value;
//						break;
//					case RankType.TOP_TYPE_ACHIEVE :
//						rankInfo.achieve = value;
//						break;
//				}
//				rankInfo.guildName = _data.readUTF();
//				rankInfoList.push(rankInfo);
//			}
//			if(len > 0)
//			{
//				rankModule.rankInfos.update(type, total, rankInfoList, page);
//			}
			var i:int;
			var len:int;
			
			var type:int = _data.readByte();
			len = _data.readShort();
			var individualRankItem:IndividualRankItem;
			for(i = 0; i < len; i++)
			{
				individualRankItem = new IndividualRankItem();
				individualRankItem.readData(_data);
				
				if(!individualRankListDic[individualRankItem.type])
					individualRankListDic[individualRankItem.type] = new Array();
				
				(individualRankListDic[individualRankItem.type] as Array).push(individualRankItem);
			}
			
			var otherRankItem:OtherRankItem;
			type = _data.readByte();
			len = _data.readShort();
			for(i = 0; i < len; i++)
			{
				otherRankItem = new OtherRankItem();
				otherRankItem.readData(_data);
				
				if(!otherRankListDic[otherRankItem.type])
					otherRankListDic[otherRankItem.type] = new Array();
				
				(otherRankListDic[otherRankItem.type] as Array).push(otherRankItem);
			}
			var list:Array;
			for each(list in individualRankListDic)
			{
				for(i = 0; i < list.length; i++)
				{
					individualRankItem = list[i];
					individualRankItem.place = i + 1;
				}
			}
			for each(list in otherRankListDic)
			{
				for(i = 0; i < list.length; i++)
				{
					otherRankItem = list[i];
					otherRankItem.place = i + 1;
				}
			}
			
			if(!rankModule.rankInfos.isRankInfoLoaded)
				rankModule.rankInfos.isRankInfoLoaded = true;
		}
		
		private function getPlace(index:int, page:int):int
		{
			return (page - 1) * RankInfo.PAGE_SIZE + (index + 1);
		}
		
		private function get individualRankListDic():Dictionary
		{
			return rankModule.rankInfos.individualRankListDic;
		}
		
		private function get otherRankListDic():Dictionary
		{
			return rankModule.rankInfos.otherRankListDic;
		}
		
		private function get rankModule():RankModule
		{
			return _handlerData as RankModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.RANK);
//			pkg.writeInt(type);
//			pkg.writeInt(page);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}