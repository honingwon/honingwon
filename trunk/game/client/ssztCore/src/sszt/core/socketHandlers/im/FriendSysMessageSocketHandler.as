package sszt.core.socketHandlers.im
{
	import sszt.core.data.ProtocolType;
	import sszt.core.data.im.ImSysMessageType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class FriendSysMessageSocketHandler extends BaseSocketHandler
	{
		public function FriendSysMessageSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_SYS_MESSAGE;
		}
		
		override public function handlePackage():void
		{
			var type:int = _data.readByte();
			var message:String = ImSysMessageType.getMessageByType(type);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
			
			handComplete();
		}
	}
}