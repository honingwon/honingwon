package sszt.core.data.titles
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class TitleInfo extends EventDispatcher
	{
		public var groupListDictionary:Dictionary = new Dictionary();
		public var allTitles:Dictionary = new Dictionary();
		
		public function TitleInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function addTitle(titleTemplateId:int):void
		{
			var tmpTitleTempalte:TitleTemplateInfo = TitleTemplateList.getTitle(titleTemplateId);
			if(!groupListDictionary[tmpTitleTempalte.type])
			{
//				groupListDictionary[tmpTitleTempalte.type] = new Vector.<TitleTemplateInfo>();
				groupListDictionary[tmpTitleTempalte.type] = [];
			}
			groupListDictionary[tmpTitleTempalte.type].push(tmpTitleTempalte);
			allTitles[tmpTitleTempalte.id] = tmpTitleTempalte;
		}
		
		public function removeTitle(titleTemplateId:int):void
		{
			var tmpTitle:TitleTemplateInfo = getTitle(titleTemplateId);
			if(tmpTitle)
			{
				if(groupListDictionary[tmpTitle.type])
				{
					/**删除两个容器里面的**/
					groupListDictionary[tmpTitle.type].splice(groupListDictionary[tmpTitle.type].indexOf(tmpTitle),1);
					delete allTitles[titleTemplateId];
					/**组里是否有元素，没有整组要删除**/
					if(groupListDictionary[tmpTitle.type].length == 0)
					{
						delete groupListDictionary[tmpTitle.type];
					}
				}
			}
		}
		
		public function getTitle(titleTemplateId:int):TitleTemplateInfo
		{
			return allTitles[titleTemplateId];
		}
	}
}