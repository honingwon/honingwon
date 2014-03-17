package sszt.core.data.item
{
	public class ItemFreeProperty
	{
		public static const UNLOCK:int  = 0;
		public static const LOCK:int = 1;
		public static const UNLOCK_REBUILD:int = 2;
		public static const LOCK_REBUILD:int = 3;
		
		public	 var index:int;
		public  var propertyId:int;
		public  var propertyValue:int;
		public  var lockState:int;
		
		public function ItemFreeProperty()
		{
			
		}
	}
}