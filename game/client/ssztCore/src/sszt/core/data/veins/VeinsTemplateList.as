package sszt.core.data.veins
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.ui.container.MAlert;

	public class VeinsTemplateList
	{
		private static var _list:Dictionary = new Dictionary();
		private static var _maxVeinLevel:int;
		
		public static function parseData(data:ByteArray):void
		{
			_maxVeinLevel = 0;
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var veins:VeinsTemplateInfo = new VeinsTemplateInfo();
				veins.parseData(data);
				_list[veins.templateId] = veins;
				if (_maxVeinLevel < veins.totalLevel)
					_maxVeinLevel = veins.totalLevel;
				
			}
		}
		public static function getMaxLeve():int
		{
			return _maxVeinLevel;
		}
		public static function getVeinsById(id:int):VeinsTemplateInfo
		{
			return _list[id];
		}
		
		public static function getVeins(type:int, lv:int):VeinsTemplateInfo
		{
			if(_maxVeinLevel < lv)
			{
				return new VeinsTemplateInfo();
			}
			else
			{
				var id:int = type * 10000 + lv;
				return _list[id];
			}
		}
		
	}
}