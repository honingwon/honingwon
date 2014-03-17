package sszt.scene.data.duplicate
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.scene.events.ScenePvP1UpdateEvent;
	
	public class DuplicateNormalInfo extends EventDispatcher
	{
		public var duplicateName:String;
		public var leftTime:int;
		public var copyTemplicat:CopyTemplateItem;
		
		public function DuplicateNormalInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function setDuplicateInfo(copy:CopyTemplateItem):void
		{			
			copyTemplicat = copy;
			duplicateName = copy.name;
			leftTime = copy.countTime;
		}
		public function closeCountDown():void
		{
			dispatchEvent(new ScenePvP1UpdateEvent(ScenePvP1UpdateEvent.PVP1_CLOSE_COUNTDOWN));
		}
		public function stopCountDown():void
		{
			dispatchEvent(new ScenePvP1UpdateEvent(ScenePvP1UpdateEvent.PVP1_STOP_COUNTDOWN));
		}
		
		public function clearData():void
		{
			copyTemplicat = null;
			duplicateName = "";
			leftTime = 0;
		}
	}
}