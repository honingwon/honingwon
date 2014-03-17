package sszt.core.data.map
{
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.ui.container.MAlert;

	public class MapTemplateList
	{
		public static const list:Dictionary = new Dictionary();
		
		public static function parseData(data:ByteArray):void
		{
			
			var len:int = data.readUnsignedInt();
			var areaLen:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				var mapItem:MapTemplateInfo = new MapTemplateInfo();
				mapItem.parseData(data);
				list[mapItem.mapId] = mapItem;
//				areaLen = data.readInt();
//				for(var j:int = 0; j < areaLen; j++)
//				{
//					data.readByte();
//					data.readShort();
//					data.readShort();
//					data.readShort();
//					data.readShort();
//				}
			}
		}
			
		
		public static function getTemplateByIndex(index:int):MapTemplateInfo
		{
			for each(var i:MapTemplateInfo in list)
			{
				if(i.mapIndex == index)
				{
					return i;
				}
			}
			
			return null;
		}
		
		public static function getMapTemplate(mapId:int):MapTemplateInfo
		{
			return list[mapId];
		}
		
		public static function getIsInVipMap():Boolean
		{
//			if(GlobalData.currentMapId == 1019 || GlobalData.currentMapId == 1020 || GlobalData.currentMapId == 1021)return true;
			return false;
		}
		
		public static function getIsPrison():Boolean
		{
			return GlobalData.currentMapId == 3003;
		}
		
		public static function getIsInSpaMap():Boolean
		{
			if(GlobalData.currentMapId == 7001)return true;
			return false;
		}
		public static function isQuestionMap(mapId:int = 0):Boolean
		{
			if(mapId == 0)
				mapId = GlobalData.currentMapId;
			return mapId == 2070;
		}		
		public static function isBossWarMap(argMapId:int):Boolean
		{
			var bossWarList:Array = [1051,1052,1053,1054,1055,1056,1057,1058,1059,1060];
			return bossWarList.indexOf(argMapId) != -1;
		}
		
		public static function isShenMoMap():Boolean
		{
			if(GlobalData.currentMapId == 5001)return true;
			return false;
		}
		
		public static function isClubWarMap():Boolean
		{
			if(GlobalData.currentMapId == 5002)return true;
			return false;
		}
		
		public static function isClubMap():Boolean
		{
			return GlobalData.currentMapId == 10000;
		}
		
		public static function isAcrossBossMap():Boolean
		{
			if(GlobalData.currentMapId == 9001)return true;
			return false;
		}
		
		public static function isPerWarMap():Boolean
		{
			if(GlobalData.currentMapId == 3023)return true;
			return false;
		}
		public static function isResourceWarMap():Boolean
		{
			return GlobalData.currentMapId == 9000001;
		}
		//天下第一pvp地图
		public static function isPVP1Map():Boolean
		{
			return GlobalData.currentMapId == 9000002;
		}
		
		public static function isWeddingMap():Boolean
		{
			return GlobalData.currentMapId == 10100001 || GlobalData.currentMapId == 10100002 ;
		}
		
		public static function isCrystalWar():Boolean
		{
			if(GlobalData.currentMapId == 5003)return true;
			return false;
		}
		public static function isMoneyDuplicate(MapId:int = 0):Boolean
		{
			if(MapId == 0)
				MapId = GlobalData.currentMapId;
			return MapId == 7200201;
		}
		public static function isNormalDuplicate():Boolean
		{
			return GlobalData.currentMapId > 1000000 && GlobalData.currentMapId < 2000000;
		}
		public static function isPassDuplicate(MapId:int = 0):Boolean
		{
			if(MapId == 0)
				MapId = GlobalData.currentMapId;
			return MapId > 4000000 && MapId < 5000000;
		}
		
		public static function isGuardDuplicate(MapId:int = 0):Boolean
		{
			if(MapId == 0)
				MapId = GlobalData.currentMapId;
			return MapId > 3000000 && MapId < 4000000;
		}
		
		public static function isGuildMap(MapId:int = 0):Boolean
		{
			if(MapId == 0)
				MapId = GlobalData.currentMapId;
			return MapId == 10000;
		}
		
		public static function isPvPMap(MapId:int = 0):Boolean
		{
			if(MapId == 0)
				MapId = GlobalData.currentMapId;
			return MapId == 1000000;
		}
		
		public static function isShenMoIsland():Boolean
		{
//			if(GlobalData.currentMapId >= 20061001 && GlobalData.currentMapId <= 20069901)return true;
			return false;
		}
		
		public static function isChallenge(MapId:int = 0):Boolean
		{
			if(MapId == 0)
				MapId = GlobalData.currentMapId;
			return MapId >= 8200801 && MapId <= 8200842;
		}
		
		public static function isClubCamp():Boolean
		{
			return GlobalData.currentMapId == 10000;
		}
		public static function isMarryMap():Boolean
		{
			return GlobalData.currentMapId == 10100001 || GlobalData.currentMapId == 10100002;
		}
		public static function isIsOrNot():Boolean
		{
			return GlobalData.currentMapId == 2070;
		}
			
		public static function isTraining():Boolean
		{
			return GlobalData.currentMapId == 2031;
		}
		
		public static function isMaya():Boolean
		{
			return GlobalData.currentMapId == 1100000;
		}
		
		/**
		 * 多人PVP 
		 * @return 
		 * 
		 */		
		public static function isMulPVP():Boolean
		{
			return GlobalData.currentMapId == 9000001;
		}
		
		public static function isBigBossWar():Boolean
		{
			return GlobalData.currentMapId == 9000003;
		}
		
		public static function isCityCraft():Boolean
		{
			return GlobalData.currentMapId == 9000004;
		}
		
		public static function isGuildPVP():Boolean
		{
			return GlobalData.currentMapId == 9000005;
		}
		
		public static function needClearOutBrost():Boolean
		{
			if(isShenMoIsland())return false;
//			if(isTraining())return false;
			return true;
		}
		
		public static function needClearPath():Boolean
		{
			if(getIsInVipMap())return true;
			if(getIsPrison())return true;
			if(getIsInSpaMap())return true;
			if(isShenMoMap())return true;
			if(isClubWarMap())return true;
			if(isClubMap())return true;
			if(isAcrossBossMap())return true;
			if(isPerWarMap())return true;
			if(isCrystalWar())return true;
			return false;
		}
		
		public static function getCanHangup():Boolean
		{
			if(isMulPVP())return false;
//			if(isClubWarMap())return false;
//			if(isShenMoMap())return false;
//			if(isAcrossBossMap())return false;
//			if(isPerWarMap())return false;
//			if(isCrystalWar())return false;
//			if(GlobalData.copyEnterCountList.isTowerCopy())return false;
			return true;
		}
		
		public static function getCanAutoCollect():Boolean
		{
			if(isMulPVP())return false;
			return true;
		}
	}
}