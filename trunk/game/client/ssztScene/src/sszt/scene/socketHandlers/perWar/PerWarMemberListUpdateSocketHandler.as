package sszt.scene.socketHandlers.perWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.personalWar.menber.PerWarMembersInfo;
	import sszt.scene.data.personalWar.menber.PerWarMembersItemInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMenbersInfo;
	
	public class PerWarMemberListUpdateSocketHandler extends BaseSocketHandler
	{
		public function PerWarMemberListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERWAR_MEMBERLIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			
			var result:Array = [];
			var tmpInfo:PerWarMembersItemInfo;
			var len:int = _data.readShort();
			for(var i:int = 0;i < len;i++)
			{
				tmpInfo = new PerWarMembersItemInfo();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.userId = _data.readNumber();
				tmpInfo.isOnline = _data.readByte();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.level = _data.readByte();
				tmpInfo.clubName = _data.readString();
				tmpInfo.score = _data.readInt();
				tmpInfo.attackPepNum = _data.readShort();
				tmpInfo.careerId = _data.readByte();
				tmpInfo.awardState = _data.readByte();
				result.push(tmpInfo);
			}
			var tmpMemberInfo:PerWarMembersInfo = sceneModule.perWarInfo.perWarMembersInfo;
			if(tmpMemberInfo)
			{
				tmpMemberInfo.dealList(result);
				tmpMemberInfo.currentPepNum = tmpMemberInfo.membersItemList.length;
				tmpMemberInfo.allPepNum = _data.readShort();
				tmpMemberInfo.update(result);
			}
			handComplete();
		}
		
		public static function send(argWarSceneId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERWAR_MEMBERLIST_UPDATE);
			pkg.writeNumber(argWarSceneId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}