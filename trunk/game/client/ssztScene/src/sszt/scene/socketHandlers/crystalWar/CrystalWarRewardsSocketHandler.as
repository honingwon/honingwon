package sszt.scene.socketHandlers.crystalWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CrystalWarRewardsSocketHandler extends BaseSocketHandler
	{
		public function CrystalWarRewardsSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CRYSTAL_WAR_REWARDS;
		}
		
		public static function send(argType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CRYSTAL_WAR_REWARDS);
			pkg.writeInt(argType);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}