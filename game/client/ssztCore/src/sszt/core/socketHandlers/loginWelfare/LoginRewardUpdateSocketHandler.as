package sszt.core.socketHandlers.loginWelfare
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class LoginRewardUpdateSocketHandler extends BaseSocketHandler
	{
		private var flag:Boolean = true;//第一次登录打开福利面板
		public function LoginRewardUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WELFARE_UPDATE;
		}
		
		override public function handlePackage():void
		{
			PackageUtil.readLoginRewardData(GlobalData.loginRewardData,_data);
			if(flag && (GlobalData.selfPlayer.level >= 18))
				SetModuleUtils.addWelfarePanel();
			flag = false;
			ModuleEventDispatcher.dispatchModuleEvent(new WelfareEvent(WelfareEvent.AWARD_GET_UPDATE));
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WELFARE_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}