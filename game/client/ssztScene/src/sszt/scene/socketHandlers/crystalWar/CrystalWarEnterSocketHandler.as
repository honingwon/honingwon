package sszt.scene.socketHandlers.crystalWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CrystalWarEnterSocketHandler extends BaseSocketHandler
	{
		public function CrystalWarEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CRYSTAL_WAR_ENTER;
		}
		
		override public function handlePackage():void
		{
			GlobalData.copyEnterCountList.isInCopy = true;
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CRYSTAL_WAR_ENTER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}