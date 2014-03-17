package sszt.firstRecharge.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.firstRecharge.FirstRechargeModule;
	
	public class FirstRechargeInfoSocketHandler extends BaseSocketHandler
	{
		public function FirstRechargeInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TEMP_1;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			
			handComplete();
		}
		
		/**
		 * 发送到服务端
		 * @param tempId
		 */
		public static function sendPlayerId(tempId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TEMP_1);
			pkg.writeNumber(tempId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}