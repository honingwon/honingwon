package sszt.scene.data.duplicate
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.copy.CopyTemplateItem;
	
	public class DuplicateMayaInfo extends EventDispatcher
	{
		public var duplicateName:String;
		public var leftTime:int;
		public var copyTemplicat:CopyTemplateItem;
		
		public function DuplicateMayaInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function setDuplicateInfo(copy:CopyTemplateItem):void
		{			
			copyTemplicat = copy;
			duplicateName = copy.name;
			leftTime = copy.countTime;
		}
		
		public function clearData():void
		{
			copyTemplicat = null;
			duplicateName = "";
			leftTime = 0;
		}
	}
}