package sszt.scene.data.collects
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.collect.CollectTemplateInfo;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfo;
	
	public class CollectItemInfo extends BaseSceneObjInfo
	{
		public var id:int;
		public var templateId:int;
		private var _template:CollectTemplateInfo;
		
		private var state:int;
		
		public function CollectItemInfo()
		{
		}
		
		override public function getObjId():Number
		{
			return id;
		}
		
		override public function getObjType():int
		{
			return MapElementType.COLLECT_PROP;
		}
		
		public function getTemplate():CollectTemplateInfo
		{
			if(_template == null)
			{
				_template = CollectTemplateList.list[templateId];
			}
			return _template;
		}
		
		public function getQuality():int
		{
			return getTemplate().quality;
		}
		
		override public function getName():String
		{
			return getTemplate().name;
		}
		
		public function canCollect():Boolean
		{
			if(GlobalData.selfPlayer.level < getTemplate().minLevel || GlobalData.selfPlayer.level > getTemplate().maxLevel)
				return false;
			//判断任务
			return true;
		}
	}
}