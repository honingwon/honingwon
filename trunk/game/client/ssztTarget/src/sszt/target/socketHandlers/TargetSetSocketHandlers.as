package sszt.target.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.target.TargetModule;
	
	public class TargetSetSocketHandlers extends BaseSocketHandler
	{
		public function TargetSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(templateModule:TargetModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new AchievementUpdateNumSocketHandler(templateModule));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.UPDATE_ACHIEVEMENT);
		}
	}
}