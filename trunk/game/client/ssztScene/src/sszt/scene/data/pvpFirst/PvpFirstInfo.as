package sszt.scene.data.pvpFirst
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.components.pvpFirst.PvpFirstResultPanel;
	import sszt.scene.events.ScenePvpFirstUpdateEvent;
	
	public class PvpFirstInfo extends EventDispatcher
	{
		public var leaveTime:int;
		public var firstName:String;
		
		public function PvpFirstInfo(target:IEventDispatcher=null)
		{
			super(target);
			leaveTime = 0;
			firstName = "";
		}
		public function showResultPanel(id1:int, id2:int):void
		{
			PvpFirstResultPanel.getInstance().show(id1, id2);
		}
		
		public function updatePvpFirstInfo(time:int, name:String):void
		{
			leaveTime = time;
			firstName = name;
			dispatchEvent(new ScenePvpFirstUpdateEvent(ScenePvpFirstUpdateEvent.PVP_FIRST_INFO_UPDATE));
		}
	}
}