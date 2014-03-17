package sszt.welfare.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.welfare.WelfareModule;
	
	public class LoginRewardReceiveSocketHandler extends BaseSocketHandler
	{
		public function LoginRewardReceiveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WELFARE_RECEIVE;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = Boolean(_data.readShort());
			var type:int = _data.readInt();
			if(success)
			{
				if(type == 0)
				{
					GlobalData.loginRewardData.got = true;
					welfareModule.welfarePanel.continuousLoginRewardView.getRewardSuccessHandler();
				}
				if(type == 1)
				{
					GlobalData.loginRewardData.gotChargeUser = true;
					welfareModule.welfarePanel.continuousLoginRewardView.getRewardSuccessChargeUserHandler();
				}
				ModuleEventDispatcher.dispatchModuleEvent(new WelfareEvent(WelfareEvent.AWARD_GET_UPDATE));
			}
		}
		
		public static function send(type:int):void
		{
			//0普通，1 VIP
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WELFARE_RECEIVE);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get welfareModule():WelfareModule
		{
			return _handlerData as WelfareModule;
		}
	}
}