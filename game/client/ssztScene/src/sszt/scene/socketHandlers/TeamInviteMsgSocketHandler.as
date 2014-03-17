package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.quickIcon.iconInfo.TeamIconInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TeamInviteMsgSocketHandler extends BaseSocketHandler
	{
		public function TeamInviteMsgSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_INVITE_MSG;
		}
		
		override public function handlePackage():void
		{
			var tmpServerId:int = 178; // _data.readShort();
			var tmpName:String = _data.readString();
			var tmpId:Number = _data.readNumber();
			if(!sceneModule.sceneInfo.playerList.self)return;
			if(MapTemplateList.getIsPrison()) return;
			if(sceneModule.sceneInfo.playerList.self.getIsHangup() && sceneModule.sceneInfo.hangupData.autoGroup)
			{
				if(sceneModule.sceneInfo.hangupData.isAccept)
				{
					TeamInviteMsgSocketHandler.send(true,tmpId);
				}else
				{
					TeamInviteMsgSocketHandler.send(false,tmpId);
				}
			}
			else
			{
				GlobalData.quickIconInfo.addToTeamIconInfoList(new TeamIconInfo(tmpServerId,tmpName,tmpId));
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(result:Boolean,id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TEAM_INVITE_MSG);
			pkg.writeBoolean(result);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}