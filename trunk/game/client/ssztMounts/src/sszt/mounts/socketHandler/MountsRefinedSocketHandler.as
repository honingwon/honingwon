package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mounts.MountsModule;
	
	public class MountsRefinedSocketHandler extends BaseSocketHandler
	{
		public function MountsRefinedSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_REFINED;
		}
		
		override public function handlePackage():void
		{
			var mountsId:Number = _data.readNumber();
			var mounts:MountsItemInfo = GlobalData.mountsList.getMountsById(mountsId);
			PackageUtil.parseMountsRefined(mounts,_data);
			handComplete();
		}
				
		private function get mountModule():MountsModule
		{
			return _handlerData as MountsModule;
		}
		
		public static function send(mountsId:Number, type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_REFINED);
			pkg.writeNumber(mountsId);
			pkg.writeByte(type);//0:铜币  1：银两
			GlobalAPI.socketManager.send(pkg);
		}
	}
}