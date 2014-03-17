package sszt.core.data.monster
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;

	public class MonsterTemplateList
	{
		private static var _list:Dictionary = new Dictionary();
		public static var mapMonsterList:Dictionary = new Dictionary();
		
		public static var GUARD_MONSTER:Array = [202181,200391];
		
		public static function setup(data:ByteArray):void
		{
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF(),"");
//			}
//			else
//			{
//				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var item:MonsterTemplateInfo = new MonsterTemplateInfo();
					item.parseData(data);
					_list[item.monsterId] = item;
					if(mapMonsterList[item.sceneId] == null)
					{
//						mapMonsterList[item.sceneId] = new Vector.<MonsterTemplateInfo>();
						mapMonsterList[item.sceneId] = [];
					}
					mapMonsterList[item.sceneId].push(item);
				}
//			}
		}
		
		public static function getMonster(id:int):MonsterTemplateInfo
		{
			return _list[id];
		}
	}
}