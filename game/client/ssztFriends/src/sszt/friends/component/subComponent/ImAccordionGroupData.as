package sszt.friends.component.subComponent
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.im.ImPlayerInfo;
	
	/**
	 * 好友每个分组的好友数据 
	 * @author chendong
	 * 
	 */	
	public class ImAccordionGroupData extends EventDispatcher
	{
		private var _data:Dictionary;
		private var _title:String;
		private var _gId:Number;
		
		public function ImAccordionGroupData(id:Number,title:String,data:Dictionary)
		{
			_gId = id;
			_title = title;
			_data = data;
		}
		
		public function getId():Number
		{
			return _gId;
		}
		
		public function getImAccordionGroupTitle():String
		{
			return _title;
		}
		
		public function getImAccordionGroupData():Dictionary
		{
			return _data;
		}
	}
}