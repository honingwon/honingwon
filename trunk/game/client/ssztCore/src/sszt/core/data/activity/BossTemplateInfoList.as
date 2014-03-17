package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.BossType;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;
	
	public class BossTemplateInfoList
	{
		public static var list:Dictionary = new Dictionary();
		/**
		 * 世界boss地图列表
		 * */
		public static var worldBossMapList:Array = [];
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:BossTemplateInfo = new BossTemplateInfo();
				info.parseData(data);
				list[info.id] = info;
				
				if(info.type == BossType.CONSTANT)
				{
					worldBossMapList.push(info.mapId);
				}
			}
		}
		
		public static function getBoss(id:int):BossTemplateInfo
		{
			return list[id];
		}
		
		public static function isWorldBossMap(mapId:int):Boolean
		{
			var ret:Boolean;
			for(var i:int = 0; i < worldBossMapList.length; i++)
			{
				if(mapId == worldBossMapList[i])
				{
					ret = true;
					break;
				}
			}
			return ret;
		}
	}
}