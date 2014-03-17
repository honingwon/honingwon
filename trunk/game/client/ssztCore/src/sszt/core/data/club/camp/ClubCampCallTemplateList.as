package sszt.core.data.club.camp
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.ClubCampCallType;

	public class ClubCampCallTemplateList
	{
		public static var arr:Array = new Array();
		public static var bossArr:Array = new Array();
		public static var collectionArr:Array = new Array();
		
		public static function setup(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var id:int = data.readInt();
				var type:int = data.readInt();
				var name:String = data.readUTF();
				var guild_level:int = data.readInt();
				var drop:Array = data.readUTF().split(',');
				var cost:int = data.readInt();
				if(type == ClubCampCallType.BOSS)
				{
					var boss:ClubBossTemplateInfo = new ClubBossTemplateInfo(id,type,guild_level,name,drop,cost);
					bossArr.push(boss);
					arr.push(boss);
				}
				else if(type == ClubCampCallType.COLLECTION)
				{
					var collection:ClubCollectionTemplateInfo = new ClubCollectionTemplateInfo(id,type,guild_level,name,drop,cost);
					collectionArr.push(collection);
					arr.push(collection);
				}
			}
		}
		
		public static function getBoss(id:int):ClubBossTemplateInfo
		{
			var  info:ClubBossTemplateInfo;
			var ret:ClubBossTemplateInfo;
			for each(info in bossArr)
			{
				if(info.bossId == id)
				{
					ret =  info;
					break;
				}
			}
			return ret;
		}
		
		public static function getCollection(id:int):ClubCollectionTemplateInfo
		{
			var  info:ClubCollectionTemplateInfo;
			var ret:ClubCollectionTemplateInfo;
			for each(info in collectionArr)
			{
				if(info.collectionId == id)
				{
					ret =  info;
					break;
				}
			}
			return ret;
		}
	}
}