package sszt.rank.data
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.rank.data.item.ClubRankItem;
	import sszt.rank.data.item.CopyRankItem;
	import sszt.rank.data.item.EquipRankItem;
	import sszt.rank.data.item.IndividualRankItem;
	import sszt.rank.events.RankEvent;

	public class RankInfos extends EventDispatcher
	{
		public static const PAGE_SIZE:int = 10;
		public var currentPage:int;
		public var totalRecords:int;
		
		public var rankListDic:Dictionary = new Dictionary();
		public var rankClassDic:Dictionary = new Dictionary();
		
		public var shenMoIslandList:Array = [];
		
		public function RankInfos()
		{
			setRankClassDic();
		}
		
		protected function setRankClassDic():void
		{
			rankClassDic[RankType.INDIVIDUAL_RANK] = IndividualRankItem;
//			rankClassDic[RankType.CLUB_RANK] = ClubRankItem;
			rankClassDic[RankType.COPY_RANK] = CopyRankItem;
			rankClassDic[RankType.EQUIP_RANK] = EquipRankItem;
//			rankClassDic[RankType.PET_RANK] = PetRankItem;
		}
		
		public function readRankData(key:String,xml:XML):void
		{
			var rankType:int = parseInt(key.substr(0,2));
			var rankItemList:Array = [];
			var rankItem:Object;
			try
			{
				var xmlList:XMLList = xml.child("item");
				for each(var el:XML in xmlList)
				{
					rankItem = new rankClassDic[rankType]();
					rankItem.readData(el);
					rankItemList.push(rankItem);
				}
				
				rankListDic[key] = rankItemList;
				dispatchEvent(new RankEvent(RankEvent.RANK_DATA_LOADED, key));
			}
			catch(e:Error)
			{
				
			}
		}
		
		public function updateShenMoIsland(dataList:Array):void
		{
			shenMoIslandList = dataList;
			setPage(shenMoIslandList.length,currentPage);
			dispatchEvent(new RankEvent(RankEvent.SHENMOISLAND_UPDATE));
		}

		public function setPage(argTotoalRecords:int,argCurrentPage:int):void
		{
			currentPage = argCurrentPage;
			totalRecords = argTotoalRecords;
			
			dispatchEvent(new RankEvent(RankEvent.PAGE_UPDATE));
		}
		
		
		public function setPageData(pageNum:int, rankKey:String ,isMyRank:Boolean = false):void
		{
			var pageData:Array = [];
			var list:Array = rankListDic[rankKey] as Array;
			var rankType:String;
			
			if(isMyRank)
			{
				var self:SelfPlayerInfo = GlobalData.selfPlayer;
				var roleId:Number = GlobalData.selfPlayer.userId;
				var item:IndividualRankItem;
				var isInRank:Boolean = false;   //是否在榜单中
				if(list == null)
					return;
				var selfId:Number = GlobalData.selfPlayer.userId
				for(var i:int=0;i<list.length;i++)
				{
					item = list[i];
					if(item.roleId == GlobalData.selfPlayer.userId)
					{
						pageNum = (i/PAGE_SIZE) + 1;
						isInRank = true;
						break;
					}
				}
				if(!isInRank)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.rank.notInRank"));
					return;
				}	
			}
			
//			if(PAGE_SIZE*(pageNum-1) >= list.length && pageNum != 1)
//			{
//				QuickTips.show("请输入正确的页数");
//				return;
//			}
//			else
//			{
//				setPage(list.length,pageNum);
//			}
			
			setPage(list.length,pageNum);
			
			rankType = rankKey.substr(0,3);
			switch(rankType)
			{
				case RankType.INDIVIDUA_LEVEL.toString():
					dispatchEvent(new RankEvent(RankEvent.LEVELRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
				case RankType.INDIVIDUA_MONEY.toString():
					dispatchEvent(new RankEvent(RankEvent.MONEYRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
				case RankType.INDIVIDUA_STRIKE.toString():
					dispatchEvent(new RankEvent(RankEvent.STRIKERANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
//				case RankType.CLUB_LEVEL.toString():
					dispatchEvent(new RankEvent(RankEvent.CLUBRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
//				case RankType.COPY_CHIYUEKU.toString():
//					dispatchEvent(new RankEvent(RankEvent.MULTI_COPYRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.COPY_XIULUOCHANG.toString():
//					dispatchEvent(new RankEvent(RankEvent.SINGLE_COPYRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
				case RankType.EQUIP_WUQI.toString():
				case RankType.EQUIP_FANGJU.toString():
				case RankType.EQUIP_SHIPIN.toString():
					dispatchEvent(new RankEvent(RankEvent.EQUIPRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
				case RankType.PET_LEVEL.toString():
					dispatchEvent(new RankEvent(RankEvent.PETLEVELRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
				case RankType.PET_APTITUDE.toString():
					dispatchEvent(new RankEvent(RankEvent.PETAPTITUDERANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
				case RankType.PET_GROW.toString():
					dispatchEvent(new RankEvent(RankEvent.PETGROWRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
					break;
			}
		}
	}
}