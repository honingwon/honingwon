package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsFeedSocketHandler extends BaseSocketHandler
	{
		public function MountsFeedSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_UPGRADE;
		}
		
		override public function handlePackage():void
		{
//			var id:Number = _data.readNumber();
//			
//			GlobalData.mountsList.removeMounts(id);
			handComplete();
		}
		
		public static function send(id:Number,placeList:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_UPGRADE);
			pkg.writeNumber(id);
			pkg.writeByte(placeList.length);
			for (var i:int = 0 ; i < placeList.length ;++i )
			{
				pkg.writeInt(placeList[i]);
			}
			
			GlobalAPI.socketManager.send(pkg);
		}
	}
}