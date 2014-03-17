package sszt.sevenActivity.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ActivityEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.sevenActivity.SevenActivityModule;
	
	public class SevenActivityGetRewardSocketHandler extends BaseSocketHandler
	{
		public function SevenActivityGetRewardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_SEVEN_GETREWARD;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			var reSuc:Boolean = _data.readBoolean();
			if(reSuc)
			{
//				ModuleEventDispatcher.dispatchModuleEvent(new ActivityEvent(ActivityEvent.SEVEN_ACTIVITY_GET_RED));
				QuickTips.show(LanguageManager.getWord('ssztl.common.getSuccess'));
			}
			handComplete();
		}
		
		/**
		 * 发送到服务端
		 * @param id 活动id
		 * 
		 */
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_SEVEN_GETREWARD);
			pkg.writeByte(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}