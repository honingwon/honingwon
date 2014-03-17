package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.quickIcon.iconInfo.DoubleSitIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class PlayerInviteSitSocketHandler extends BaseSocketHandler
	{
		public function PlayerInviteSitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_INVITE_SIT;
		}
		
		override public function handlePackage():void
		{
			var result:int = _data.readByte();
			if(result == 1)
			{
				GlobalData.quickIconInfo.addToDoubleSitList(new DoubleSitIconInfo(_data.readString(),0,_data.readNumber(),_data.readInt(),_data.readInt()));
			}
			else
			{
				if(result == 2)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.otherInDoubleSit"));
				}
				else if(result == 3)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.tooFar"));
				}
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(serverId:int,nick:String,id:Number = -1):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_INVITE_SIT);
//			pkg.writeShort(serverId);
			pkg.writeString(nick);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}