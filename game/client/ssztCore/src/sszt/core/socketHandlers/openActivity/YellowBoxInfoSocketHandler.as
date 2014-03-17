package sszt.core.socketHandlers.openActivity
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.YellowBoxEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class YellowBoxInfoSocketHandler extends BaseSocketHandler
	{
		public function YellowBoxInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.PLAYER_YELLOW_INFO;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var isReceNewPack:Boolean = _data.readBoolean(); //新手礼包 
			var receDayPack:int = _data.readByte(); //每日礼包领取时间  0:未领  1已领
			var levelUpPack:int = _data.readByte(); //升级礼包
			
			GlobalData.yellowBoxInfo.isReceNewPack = isReceNewPack;
			GlobalData.yellowBoxInfo.receDayPack = receDayPack;
			GlobalData.yellowBoxInfo.levelUpPack = levelUpPack;
			
			ModuleEventDispatcher.dispatchModuleEvent(new YellowBoxEvent(YellowBoxEvent.GET_INFO));
			
			handComplete();
		}
		
		/**
		 * 发送到服务端
		 * @param tempId
		 */
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_YELLOW_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}