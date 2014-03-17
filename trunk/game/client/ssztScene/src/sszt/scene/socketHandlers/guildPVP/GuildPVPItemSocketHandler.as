package sszt.scene.socketHandlers.guildPVP
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GuildPVPItemSocketHandler extends BaseSocketHandler
	{
		public function GuildPVPItemSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GUILD_PVP_ITEM;
		}	
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GUILD_PVP_ITEM);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}		
	}
}