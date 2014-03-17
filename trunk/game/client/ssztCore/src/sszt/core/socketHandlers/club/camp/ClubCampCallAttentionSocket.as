package sszt.core.socketHandlers.club.camp
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.ClubCampBossAttentionPanel;
	import sszt.core.view.ClubCampCollectionAttentionPanel;
	
	public class ClubCampCallAttentionSocket extends BaseSocketHandler
	{
		public function ClubCampCallAttentionSocket(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_SUMMON_NOTICE;
		}
		
		override public function handlePackage():void
		{
			//1采集
			//0boss
			var type:int = _data.readShort();
			var message:String = _data.readUTF();
			var str:String = message.replace("{N","<font color = '#ff0000'>");
				str = str.replace("}","</font>");
			if(GlobalData.currentMapId == 10000)//如果在帮会营地中不提示
				return ;
			if(type == 0)
			{
				ClubCampBossAttentionPanel.getInstance().show(str);
			}
			if(type == 1)
			{
				ClubCampCollectionAttentionPanel.getInstance().show(str);
			}
		}
		
	}
}