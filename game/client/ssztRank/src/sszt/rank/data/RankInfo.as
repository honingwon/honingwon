package sszt.rank.data
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.rank.events.RankEvent;

	public class RankInfo extends EventDispatcher
	{
		public static const PAGE_SIZE:int = 10;
		
		public static const INDIVDUAL_RANK_TYPE_DIC:Dictionary = new Dictionary();
		
		/**
		 * 保存客户端树控件当前选中状态，只在树控件改变状态时赋值给此属性。
		 */
		public var currentType:int;
		/**
		 * 保存客户端分页控件页码，只在分页控件改变状态时赋值给此属性。
		 */
		public var currentPage:int = 1;
		
		public var currentCopyRankItemTotal:int;
		public var copyRankListDic:Dictionary = new Dictionary();
		
		private var _isRankInfoLoaded:Boolean;
		public var individualRankListDic:Dictionary = new Dictionary();
		public var otherRankListDic:Dictionary = new Dictionary();
		
		
		
		
		
		public var currentRankItemTotal:int;
		public var currentRankItemInfoList:Array;
		public var totalRecords:int;
		public var shenMoIslandList:Array = [];
		public var rankClassDic:Dictionary = new Dictionary();
		public var rankListDic:Dictionary = new Dictionary();
		
		public function set isRankInfoLoaded(value:Boolean):void
		{
			_isRankInfoLoaded = value;
			dispatchEvent(new RankEvent(RankEvent.RANK_INFO_LOADED));
		}
		
		public function get isRankInfoLoaded():Boolean
		{
			return _isRankInfoLoaded;
		}
		
		/**
		 * 更新指定类型副本排行数据
		 */
		public function updateCopyRankList(type:int, list:Array):void
		{
			copyRankListDic[type] = list;
			if(type == currentType)
			{
				dispatchEvent(new RankEvent(RankEvent.COPY_RANK_LIST_UPDATE));
			}
		}
		
		/**
		 * 根据当前页码获取一页的排行信息
		 * @param type 排行类型 0 副本 1 个人 2 其他
		 */
		public function getCurrRankInfo(type:int):Array
		{
			var all:Array;
			switch(type)
			{
				case 0 :
					all = copyRankListDic[currentType];
					break;
				case 1 :
					all = individualRankListDic[currentType];
					break;
				case 2 :
					all = otherRankListDic[currentType];
					break;
			}
			
			var len:int;
			var startIndex:int;
			var endIndex:int;
			
			if(!all || currentPage == 0) return [];
			
			len = all.length;
			
			if(len % PAGE_SIZE == 0)
			{
				if(int(len / PAGE_SIZE) < currentPage) return [];
			}
			else
			{
				if(Math.ceil(len / PAGE_SIZE) < currentPage) return [];
			}
				
			startIndex = (currentPage - 1) * PAGE_SIZE;
			
			if(len % PAGE_SIZE == 0)
			{
				endIndex =  startIndex + PAGE_SIZE;
			}
			else
			{
				if(len > PAGE_SIZE * currentPage)
				{
					endIndex =  startIndex + PAGE_SIZE;
				}
				else//len < PAGE_SIZE * page
				{
					endIndex = startIndex +  len % PAGE_SIZE;
				}
			}				
			return all.slice(startIndex,endIndex);
		}
		
		public function RankInfo()
		{
			INDIVDUAL_RANK_TYPE_DIC['1000'] = 1;
			INDIVDUAL_RANK_TYPE_DIC['1001'] = 2;
			INDIVDUAL_RANK_TYPE_DIC['1002'] = 3;
			INDIVDUAL_RANK_TYPE_DIC['1003'] = 4;
			
			INDIVDUAL_RANK_TYPE_DIC['2000'] = 5;
			INDIVDUAL_RANK_TYPE_DIC['2001'] = 6;
			INDIVDUAL_RANK_TYPE_DIC['2002'] = 7;
			INDIVDUAL_RANK_TYPE_DIC['2003'] = 8;
			
			INDIVDUAL_RANK_TYPE_DIC['3000'] = 9;
			INDIVDUAL_RANK_TYPE_DIC['3001'] = 10;
			INDIVDUAL_RANK_TYPE_DIC['3002'] = 11;
			INDIVDUAL_RANK_TYPE_DIC['3003'] = 12;
			
			INDIVDUAL_RANK_TYPE_DIC['4000'] = 13;
			INDIVDUAL_RANK_TYPE_DIC['4001'] = 14;
			INDIVDUAL_RANK_TYPE_DIC['4002'] = 15;
			INDIVDUAL_RANK_TYPE_DIC['4003'] = 16;
			
			INDIVDUAL_RANK_TYPE_DIC['5000'] = 17;
			INDIVDUAL_RANK_TYPE_DIC['5001'] = 18;
			INDIVDUAL_RANK_TYPE_DIC['5002'] = 19;
			INDIVDUAL_RANK_TYPE_DIC['5003'] = 20;
			
			INDIVDUAL_RANK_TYPE_DIC['6000'] = 21;
			INDIVDUAL_RANK_TYPE_DIC['6001'] = 22;
			INDIVDUAL_RANK_TYPE_DIC['6002'] = 23;
			INDIVDUAL_RANK_TYPE_DIC['6003'] = 24;
		}
		
//		public function update(type:int, total:int, list:Array, page:int):void
//		{
//			if(type != currentType || page != currentPage) return;
//			currentRankItemTotal = total;
//			currentRankItemInfoList = list;
//			dispatchEvent(new RankEvent(RankEvent.PAGE_UPDATE));
//		}
		
//		protected function setRankClassDic():void
//		{
//			rankClassDic[RankType.INDIVIDUAL_RANK] = IndividualRankItem;
//			rankClassDic[RankType.CLUB_RANK] = ClubRankItem;
//			rankClassDic[RankType.COPY_RANK] = CopyRankItem;
//			rankClassDic[RankType.EQUIP_RANK] = EquipRankItem;
//			rankClassDic[RankType.PET_RANK] = PetRankItem;
//		}
		
//		public function readRankData(key:String,xml:XML):void
//		{
//			var rankType:int = parseInt(key.substr(0,2));
//			var rankItemList:Array = [];
//			var rankItem:Object;
//			try
//			{
//				var xmlList:XMLList = xml.child("item");
//				for each(var el:XML in xmlList)
//				{
//					rankItem = new rankClassDic[rankType]();
//					rankItem.readData(el);
//					rankItemList.push(rankItem);
//				}
//				
//				rankListDic[key] = rankItemList;
//				dispatchEvent(new RankEvent(RankEvent.RANK_DATA_LOADED, key));
//			}
//			catch(e:Error)
//			{
//				
//			}
//		}
		
//		public function updateShenMoIsland(dataList:Array):void
//		{
//			shenMoIslandList = dataList;
//			setPage(shenMoIslandList.length,currentPage);
//			dispatchEvent(new RankEvent(RankEvent.SHENMOISLAND_UPDATE));
//		}

//		public function setPage(argTotoalRecords:int,argCurrentPage:int):void
//		{
//			currentPage = argCurrentPage;
//			totalRecords = argTotoalRecords;
//			
//			dispatchEvent(new RankEvent(RankEvent.PAGE_UPDATE));
//		}
		
		
//		public function setPageData(pageNum:int, rankKey:String ,isMyRank:Boolean = false):void
//		{
//			var pageData:Array = [];
//			var list:Array = rankListDic[rankKey] as Array;
//			var rankType:String;
//			
//			if(isMyRank)
//			{
//				var self:SelfPlayerInfo = GlobalData.selfPlayer;
//				var roleId:Number = GlobalData.selfPlayer.userId;
//				var item:IndividualRankItem;
//				var isInRank:Boolean = false;   //是否在榜单中
//				if(list == null)
//					return;
//				var selfId:Number = GlobalData.selfPlayer.userId
//				for(var i:int=0;i<list.length;i++)
//				{
//					item = list[i];
//					if(item.roleId == GlobalData.selfPlayer.userId)
//					{
//						pageNum = (i/PAGE_SIZE) + 1;
//						isInRank = true;
//						break;
//					}
//				}
//				if(!isInRank)
//				{
//					QuickTips.show(LanguageManager.getWord("ssztl.rank.notInRank"));
//					return;
//				}	
//			}
//			
////			if(PAGE_SIZE*(pageNum-1) >= list.length && pageNum != 1)
////			{
////				QuickTips.show("请输入正确的页数");
////				return;
////			}
////			else
////			{
////				setPage(list.length,pageNum);
////			}
//			
//			setPage(list.length,pageNum);
//			
//			rankType = rankKey.substr(0,3);
//			switch(rankType)
//			{
//				case RankType.INDIVIDUA_LEVEL.toString():
//					dispatchEvent(new RankEvent(RankEvent.LEVELRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.INDIVIDUA_MONEY.toString():
//					dispatchEvent(new RankEvent(RankEvent.MONEYRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.INDIVIDUA_STRIKE.toString():
//					dispatchEvent(new RankEvent(RankEvent.STRIKERANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.CLUB_LEVEL.toString():
//					dispatchEvent(new RankEvent(RankEvent.CLUBRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.COPY_CHIYUEKU.toString():
//					dispatchEvent(new RankEvent(RankEvent.MULTI_COPYRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.COPY_XIULUOCHANG.toString():
//					dispatchEvent(new RankEvent(RankEvent.SINGLE_COPYRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.EQUIP_WUQI.toString():
//				case RankType.EQUIP_FANGJU.toString():
//				case RankType.EQUIP_SHIPIN.toString():
//					dispatchEvent(new RankEvent(RankEvent.EQUIPRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.PET_LEVEL.toString():
//					dispatchEvent(new RankEvent(RankEvent.PETLEVELRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.PET_APTITUDE.toString():
//					dispatchEvent(new RankEvent(RankEvent.PETAPTITUDERANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//				case RankType.PET_GROW.toString():
//					dispatchEvent(new RankEvent(RankEvent.PETGROWRANKLIST_UPDATE,new RankType(rankKey,pageNum)));
//					break;
//			}
//		}
	}
}