package sszt.scene.socketHandlers.guildPVP
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.guildPVP.GuildPVPRankingItemInfo;
	
	public class GuildPVPResultSocketHandler extends BaseSocketHandler
	{
		public function GuildPVPResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GUILD_PVP_RESULT;
		}
		
		override public function handlePackage():void
		{
			var sceneModule:SceneModule = _handlerData as SceneModule;
			var totalTime:int = _data.readShort();
			var index:int = _data.readShort();
			var rewardId:int = _data.readInt();
			var len:int = _data.readShort();
			var list:Array = [];
			var rank:GuildPVPRankingItemInfo;
			for(var i:int =0;i<len;i++)
			{
				rank = new GuildPVPRankingItemInfo();
				rank.nick = _data.readUTF();
				rank.time = _data.readShort();
				list.push(rank);
			}
			sceneModule.guildPVPInfo.updateResultInfo(totalTime,index,rewardId,list);
			handComplete();
		}
		
		
	}
}