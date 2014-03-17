package sszt.core.utils
{
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;

	public class MapSearch
	{
		private static var _results:Array;
		private static var _startScene:int;
		private static var _endScene:int;
		
//		public static function find(startScene:int,endScene:int):Vector.<int>
		public static function find(startScene:int,endScene:int):Array
		{
			_results = new Array();
			if(DoorTemplateList.sceneDoorList[startScene] && DoorTemplateList.sceneDoorList[endScene])
			{
				_startScene = startScene;
				_endScene = endScene;
//				var hadSearchedList:Vector.<int> = new Vector.<int>();
				var hadSearchedList:Array = [];
				doFind(DoorTemplateList.sceneDoorList[_startScene],hadSearchedList,hadSearchedList.slice(0));
				if(_results.length > 0)
				{
					_results.sortOn(["length"],[Array.NUMERIC]);
					return _results[0];
				}
			}
			return null;
		}
		
//		private static function doFind(sceneList:Vector.<DoorTemplateInfo>,hadSearchedList:Vector.<int>,result:Vector.<int>):void
		private static function doFind(sceneList:Array,hadSearchedList:Array,result:Array):void
		{
			for each(var door:DoorTemplateInfo in sceneList)
			{
//				var tmpResult:Vector.<int> = result.slice();
				var tmpResult:Array = result.slice();
				var nextId:int = door.nextMapId;
				if(hadSearchedList.indexOf(nextId) == -1)
				{
					if(nextId == _endScene)
					{
						tmpResult.push(door.templateId);
						_results.push(tmpResult);
						break;
					}
					else
					{
//						var tmp:Vector.<int> = hadSearchedList.slice();
						var tmp:Array = hadSearchedList.slice();
						for each(var brotherDoor:DoorTemplateInfo in sceneList)
						{
							tmp.push(brotherDoor.nextMapId);
						}
//						var tmpR:Vector.<int> = result.slice();
						var tmpR:Array = result.slice();
						tmpR.push(door.templateId);
						doFind(DoorTemplateList.sceneDoorList[nextId],tmp,tmpR);
					}
				}
				tmpResult = null;
			}
			hadSearchedList = null;
			result = null;
		}
	}
}