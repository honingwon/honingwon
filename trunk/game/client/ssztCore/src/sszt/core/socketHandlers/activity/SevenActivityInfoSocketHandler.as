package sszt.core.socketHandlers.activity
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.SevenActivityItemInfo;
	import sszt.core.data.activity.SevenActivityUserItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ActivityEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class SevenActivityInfoSocketHandler extends BaseSocketHandler
	{
		public function SevenActivityInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.ACTIVE_SEVEN;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			GlobalData.sevenActInfo.firstLoginTime = _data.readInt();
			GlobalData.sevenActInfo.gotState = _data.readInt();
			GlobalData.sevenActInfo.gotState2 = _data.readInt();

			ModuleEventDispatcher.dispatchModuleEvent(new ActivityEvent(ActivityEvent.SEVEN_ACTIVITY_INFO));
			
			handComplete();
		}
		
		/**
		 * 发送到服务端
		 */
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_SEVEN);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}