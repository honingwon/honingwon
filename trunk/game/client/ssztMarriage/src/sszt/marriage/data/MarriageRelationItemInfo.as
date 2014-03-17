package sszt.marriage.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 婚姻关系的角色信息
	 * */
	public class MarriageRelationItemInfo extends EventDispatcher
	{
		public var userId:Number;
		public var nick:String;
		/**
		 * 1老公  2老婆  3小妾
		 * */
		public var type:int;
		public var career:int;
		public var sex:int;
//		public var groomName:String;
//		public var brideName:String;
		//		public var state:int;
		//		public var marryId:Number;

		public function MarriageRelationItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
	}
}