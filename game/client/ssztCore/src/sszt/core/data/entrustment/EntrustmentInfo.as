package sszt.core.data.entrustment
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 委托系统信息
	 * */
	public class EntrustmentInfo extends EventDispatcher
	{
		private var _isInEntrusting:Boolean;
		private var _currentEntrustment:EntrustmentItemInfo;
		
		public function EntrustmentInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function set isInEntrusting(value:Boolean):void
		{
			_isInEntrusting = value;
			dispatchEvent(new EntrustmentInfoEvent(EntrustmentInfoEvent.IS_IN_ENTRUSTING));
		}
		
		public function get isInEntrusting():Boolean
		{
			return _isInEntrusting;
		}
		
		public function set currentEntrustment(value:EntrustmentItemInfo):void
		{
			_currentEntrustment = value;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ENTRUSTMENT_ATTENTION));
		}
		
		public function get currentEntrustment():EntrustmentItemInfo
		{
			return _currentEntrustment;
		}
	}
}