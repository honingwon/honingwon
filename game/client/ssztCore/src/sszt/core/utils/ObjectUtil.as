package sszt.core.utils
{
	import flash.utils.ByteArray;

	public class ObjectUtil
	{
		public static function contains(obj:Object,member:Object):Boolean
		{
			for(var prop:String in obj)
			{
				if(obj[prop] == member)return true;
			}
			return false;
		}
		
		/**
		 * 类型变为object,且不能强制转换类型(用处不大)
		 * @param obj
		 * @return 
		 * 
		 */		
		public static function clone(obj:Object):Object
		{
			var t:ByteArray = new ByteArray();
			t.writeObject(obj);
			t.position = 0;
			return t.readObject();
		}
		
		public static function isEmpty(obj:*):Boolean
		{
			if(obj == undefined)return true;
			if(obj is Number)return isNaN(obj);
			if(obj is Array || obj is String)return obj.length == 0;
			if(obj is Object)
			{
				for(var prop:String in obj)return false;
				return true;
			}
			return false;
		}
	}
}
