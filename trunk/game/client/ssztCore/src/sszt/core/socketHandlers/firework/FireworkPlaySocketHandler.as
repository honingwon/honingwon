package sszt.core.socketHandlers.firework
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class FireworkPlaySocketHandler extends BaseSocketHandler
	{
		public function FireworkPlaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FIREWORK_PLAY;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var serverId:int = _data.readShort();
			var nick:String = _data.readString();
			var type:int = _data.readShort();
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.FIREWORK_PLAY,{id:id,serverId:serverId,nick:nick,type:type}));
			
			handComplete();
		}
	}
}