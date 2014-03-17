package sszt.mounts.data
{
	import flash.events.EventDispatcher;
	
	import sszt.mounts.event.MountsEvent;

	public class MountsRefreshSkillBooksInfo extends EventDispatcher
	{
		/**
		 * 类型：ItemInfo
		 * */
		public var booksList:Array;
		public var lucyValue:int;
		public var gotbooksPlace:int;
		
		public function MountsRefreshSkillBooksInfo()
		{
		}
		
		public function update(lucyValue:int, booksList:Array):void
		{
			this.lucyValue = lucyValue;
			this.booksList = booksList;
			dispatchEvent(new MountsEvent(MountsEvent.GET_SKILL_BOOK_LIST));
		}
		
		public function updateLucyValue(value:int):void
		{
			this.lucyValue = value;
		}
		
		public function getSkillBookSuccessed():void
		{
			dispatchEvent(new MountsEvent(MountsEvent.GET_SKILL_BOOK_SUCCESSED));
		}
		
		public function dispose():void
		{
		}
	}
}