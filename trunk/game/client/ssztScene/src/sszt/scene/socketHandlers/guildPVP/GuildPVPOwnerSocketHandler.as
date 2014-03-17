package sszt.scene.socketHandlers.guildPVP
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class GuildPVPOwnerSocketHandler extends BaseSocketHandler
	{
		public function GuildPVPOwnerSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GUILD_PVP_THEFIRAST;
		}	
		
		override public function handlePackage():void
		{
			var sceneModule:SceneModule = _handlerData as SceneModule;
			var nick:String = _data.readUTF();
			sceneModule.guildPVPInfo.updateGuildNick(nick);
			handComplete();
		}	
	}
}