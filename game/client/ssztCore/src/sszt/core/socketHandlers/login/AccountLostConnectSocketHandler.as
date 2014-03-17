package sszt.core.socketHandlers.login
{
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class AccountLostConnectSocketHandler extends BaseSocketHandler
	{
		public function AccountLostConnectSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACCOUNT_LOST_CONNECT;
		}
		
		override public function handlePackage():void
		{
			CommonConfig.beKick = true;
			GlobalData.lostConnectResult = _data.readByte();
//			MAlert.show(_data.readString(),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null,closeHandler,"center",-1,false);
//			handComplete();
//			
//			function closeHandler(evt:CloseEvent):void
//			{
//				JSUtils.gotoPage(GlobalAPI.pathManager.getSelectServerPath(),true);
//			}
		}
	}
}