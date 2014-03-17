package sszt.scene.socketHandlers.guildPVP
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class GuildPVPKillSocketHandler extends BaseSocketHandler
	{
		public function GuildPVPKillSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GUILD_PVP_KILL;
		}
		
		override public function handlePackage():void
		{
			var sceneModule:SceneModule = _handlerData as SceneModule;
			var time:int = _data.readShort();
			var killNum:int = _data.readShort();
			var name:String = _data.readUTF();			
			
			sceneModule.guildPVPInfo.updateKillInfo(time,killNum);
			handComplete();
		}
		
		
	}
}