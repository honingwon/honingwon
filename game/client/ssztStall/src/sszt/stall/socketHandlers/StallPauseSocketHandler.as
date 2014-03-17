package sszt.stall.socketHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.stall.StallModule;
	
	public class StallPauseSocketHandler extends BaseSocketHandler
	{
		public function StallPauseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
				module.stallPanel.dealPanel.pasueStallSuccess();
				handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_CANCEL;
		}
		
		public static function sendPause():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.STALL_CANCEL);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get module():StallModule
		{
			return _handlerData as StallModule;
		}
	}
}