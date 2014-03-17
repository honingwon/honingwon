package sszt.swordsman.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.swordsman.UserInfoSocketHandler;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.swordsman.SwordsmanModule;
	
	/**
	 * 查看发布江湖令任务 
	 * @author chendong
	 * 
	 */	
	public class TokenPubliskListSocketHandler extends BaseSocketHandler
	{
		public function TokenPubliskListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TOKEN_PUBLISH_LIST;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var list:Array = [];
			list.push(_data.readInt());
			list.push(_data.readInt());
			list.push(_data.readInt());
			list.push(_data.readInt());
			GlobalData.tokenInfo.updateTokenNum(list);
			ModuleEventDispatcher.dispatchModuleEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.TO_SHOW_RELEASE_SOWRDMAN_NUM));
			UserInfoSocketHandler.send(); // 
		}
		
		public function get swordsmanModule():SwordsmanModule
		{
			return _handlerData as SwordsmanModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TOKEN_PUBLISH_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}