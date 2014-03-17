package sszt.pvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.pvp.PVPModule;
	
	public class PVPStartSocketHandler extends BaseSocketHandler
	{
		public function PVPStartSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{			
			return ProtocolType.PVP_START;
		}
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			var activeId:int = _data.readInt();
			var state:int = _data.readInt();
			if(GlobalData.pvpInfo.current_active_id == activeId)
			{
				GlobalData.pvpInfo.user_pvp_state = 2;
				pvpModule.pvp1Panel.dispose();
				GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.waittingForCopy"));
			}
			handComplete();
		}
		
		public function get pvpModule():PVPModule
		{
			return _handlerData as PVPModule;
		}
	}
}