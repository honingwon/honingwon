package sszt.sevenActivity.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.sevenActivity.SevenActivityModule;
	
	/**
	 * 获取全民奖励
	 * */
	public class SevenActivityGetReward2SocketHandler extends BaseSocketHandler
	{
		public function SevenActivityGetReward2SocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_SEVEN_GETREWARD2;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			var reSuc:Boolean = _data.readBoolean();
			if(reSuc)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.getSuccess'));
			}
			module.sevenActivityPanel.reward2GotHandler();
			handComplete();
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_SEVEN_GETREWARD2);
			pkg.writeByte(id);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get module():SevenActivityModule
		{
			return _handlerData as SevenActivityModule;
		}
	}
}