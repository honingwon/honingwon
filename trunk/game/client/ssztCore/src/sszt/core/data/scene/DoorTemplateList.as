package sszt.core.data.scene
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.utils.MapSearch;
	import sszt.ui.container.MAlert;

	public class DoorTemplateList
	{
		private static const _doorList:Dictionary = new Dictionary();
		
		public static const sceneDoorList:Dictionary = new Dictionary();
		
		public static function setup(data1:ByteArray):void
		{
//			if(data1.readBoolean())
//			{
//				data1.readUTF();
//			}
//			else
//			{
//				MAlert.show(data1.readUTF());
//				return;
//			}
			var len:int = data1.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var door:DoorTemplateInfo = new DoorTemplateInfo();
				door.parseData(data1);
				_doorList[door.templateId] = door;
//				if(sceneDoorList[door.mapId] == null)sceneDoorList[door.mapId] = new Vector.<DoorTemplateInfo>();
				if(sceneDoorList[door.mapId] == null)sceneDoorList[door.mapId] = [];
				sceneDoorList[door.mapId].push(door);
			}
		}
		
		public static function getDoorTemplate(id:int):DoorTemplateInfo
		{
			return _doorList[id];
		}
		
		public static function getDoorByNextMapId(nextMapId:int):Array
		{
			var ret:Array =[];
			for each(var i:DoorTemplateInfo in _doorList)
			{
				if(i.nextMapId == nextMapId)
				{
					ret.push(i);
				}
			}
			return ret;
		}
	}
}