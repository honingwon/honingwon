package sszt.marriage.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.constData.MarryRelationType;
	import sszt.marriage.event.MarriageRelationEvent;
	
	public class MarriageRelationList extends EventDispatcher
	{
		private var _list:Array;
		
		public function MarriageRelationList(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update(list:Array):void
		{
			_list = list;
			if(_list.length > 1)_list.sortOn(['type'],[Array.NUMERIC]);
			dispatchEvent(new MarriageRelationEvent(MarriageRelationEvent.UPDATE));
		}
		
//		public function divorce(userId:Number):void
//		{
//			//删除数据项
//			var item:MarriageRelationItemInfo = getRelationById(userId);
//			var index:int = _list.indexOf(item);
//			_list.splice(index,1);
//			_list.sortOn(['type'],[Array.NUMERIC]);
//			dispatchEvent(new MarriageRelationEvent(MarriageRelationEvent.UPDATE));
//		}
		
//		public function changeRelation(id:Number):void
//		{
//			//修改妻为妾
//			var wife:MarriageRelationItemInfo = getRelationByType(MarryRelationType.WIFE);
//			wife.type = MarryRelationType.CONCUBINE;
//			//修改妾为妻子
//			var concubine:MarriageRelationItemInfo = getRelationById(id);
//			concubine.type = MarryRelationType.WIFE;
//			_list.sortOn(['type'],[Array.NUMERIC]);
//			dispatchEvent(new MarriageRelationEvent(MarriageRelationEvent.UPDATE));
//		}
		
		public function getRelationByType(type:int):MarriageRelationItemInfo
		{
			var ret:MarriageRelationItemInfo;
			var item:MarriageRelationItemInfo;
			for each(item in _list)
			{
				if(type == item.type)
				{
					ret = item;
					break;
				}
			}
			return ret;
		}
		
		public function getRelationById(userId:Number):MarriageRelationItemInfo
		{
			var ret:MarriageRelationItemInfo;
			var item:MarriageRelationItemInfo;
			for each(item in _list)
			{
				if(userId == item.userId)
				{
					ret = item;
					break;
				}
			}
			return ret;
		}
		
		public function get list():Array
		{
			return _list;
		}
	}
}