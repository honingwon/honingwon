package sszt.rank.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.rank.RankModule;
	import sszt.rank.data.RankType;
	import sszt.rank.data.item.CopyRankItem;
	
	public class DuplicateRankSocketHanders extends BaseSocketHandler
	{
		public function DuplicateRankSocketHanders(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			//副本id  50
			var type:int = _data.readInt();
			var total:int = _data.readInt();
			var i:int;
			var copyRankInfo:CopyRankItem;
			var copyRankInfoList:Array = [];
			for(i = 0; i < total; i++)
			{
				copyRankInfo = new CopyRankItem();
				copyRankInfo.readData(_data);
				copyRankInfoList.push(copyRankInfo);
			}
			
			switch(type)
			{
				case RankType.COPY_TYPE1 :
					;
				case RankType.COPY_TYPE3 :
					copyRankInfoList.reverse();
					break;
				case RankType.COPY_TYPE2 :
					;
				case RankType.COPY_TYPE4 :
					copyRankInfoList.sort(sortOnPassIdAndTimeused);
					addPlaceField();
					break;
				default :
			}
			
			rankModule.rankInfos.updateCopyRankList(type, copyRankInfoList);
			
			//添加【排名】字段
			function addPlaceField():void
			{
				for(i = 0; i < total; i++)
				{
					copyRankInfo = copyRankInfoList[i]
					copyRankInfo.place = i + 1
				}
			}
			
			//守护副本排序函数，闯关数大的靠前，闯关数相同的时间短的靠前
			function sortOnPassIdAndTimeused(a:CopyRankItem, b:CopyRankItem):Number
			{
				if(a.passId > b.passId)
				{
					return -1
				}
				else if(a.passId < b.passId)
				{
					return 1;
				}
				else
				{
					if(a.timeUsed < b.timeUsed)
					{
						return -1;
					}
					else if(a.timeUsed > b.timeUsed)
					{
						return 1;
					}
					else
					{
						return 0;
					}
				}
			}
				
		}
		
		override public function getCode():int
		{
			return ProtocolType.DUPLICATE_TOP_LIST;
		}
		
		private function get rankModule():RankModule
		{
			return _handlerData as RankModule;
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.DUPLICATE_TOP_LIST);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}