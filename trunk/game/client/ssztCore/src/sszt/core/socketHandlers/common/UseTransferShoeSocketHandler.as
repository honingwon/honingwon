package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	
	public class UseTransferShoeSocketHandler extends BaseSocketHandler
	{
		public function UseTransferShoeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.USE_TRANSFER_SHOE;
		}
		
		override public function handlePackage():void
		{
			var result:int = _data.readByte();
			if(!result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.useTransferFail"));
			}
			
			handComplete();
		}
		
		public static function send(mapId:int,posX:int,posY:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.USE_TRANSFER_SHOE);
			pkg.writeInt(mapId);
			pkg.writeInt(posX);
			pkg.writeInt(posY);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}