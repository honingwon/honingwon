package sszt.core.data.veins
{
	import flash.utils.ByteArray;
	
	
	public class VeinsExtraTemplateList
	{
		private static var _list:Array = [];
		
		public function VeinsExtraTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var veinsExtra:VeinsExtraTemplateInfo = new VeinsExtraTemplateInfo(); 
				veinsExtra.parseData(data);
				_list.push(veinsExtra);
			}
		}
		public static function getVeinsExtraById(id:int):VeinsExtraTemplateInfo
		{
			for(var i:int = 0; i < _list.length; i++)
			{
				if (_list[i].id == id )
					return _list[i];
			}
			return null;
		}
		
		public static function getVeinsExtraList(level:int):Array
		{
			var list:Array = [];
			for each(var v:VeinsExtraTemplateInfo in _list)
			{
				if(v.needLevel <= level)
				{
					list.push(v);
				}
			}
			return list;
		}
	}
}