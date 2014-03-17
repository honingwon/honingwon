package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class UpdateSelfInfoSocketHandler extends BaseSocketHandler
	{
		public function UpdateSelfInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.UPDATE_SELF_INFO;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.userMoney.updateMoney(_data.readInt(),_data.readInt(),_data.readInt(),_data.readInt(),_data.readInt());
			
			handComplete();
		}
		
		public static function sendMoney(yuanBao:int,copper:int,bindCopper:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.UPDATE_SELF_INFO);
			pkg.writeInt(yuanBao);
			pkg.writeInt(copper);
			pkg.writeInt(bindCopper);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}