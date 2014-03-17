package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsReleaseSocketHandler extends BaseSocketHandler
	{
		public function MountsReleaseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_RELEASE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			
			GlobalData.mountsList.removeMounts(id);
			handComplete();
		}
		
		public static function send(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_RELEASE);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}