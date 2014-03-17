package sszt.scene.socketHandlers.guildPVP
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class GuildPVPReloadSocketHandler extends BaseSocketHandler
	{
		public function GuildPVPReloadSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GUILD_PVP_RELOAD;
		}	
		
		override public function handlePackage():void
		{
			var sceneModule:SceneModule = _handlerData as SceneModule;
			var time:int = _data.readInt();
			var totalTime:int = _data.readShort();
			var len:int = _data.readShort();
			var list:Array = [];
			for(var i:int=0;i<len;i++)
			{
				var item:int = _data.readInt();
				list.push(item);
			}
			var nick:String = _data.readUTF();
			sceneModule.guildPVPInfo.updateRemainTime(time,totalTime,list,nick);
			handComplete();
		}			
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GUILD_PVP_RELOAD);
			GlobalAPI.socketManager.send(pkg);
		}		
	}
}