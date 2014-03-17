package sszt.scene.socketHandlers.shenMoWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMenbersInfo;
	
	public class ShenMoWarMemberListUpdateSocketHandler extends BaseSocketHandler
	{
		public function ShenMoWarMemberListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SHENMO_MEMBERLIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			
			var result:Array = [];
			var tmpInfo:ShenMoWarMembersItemInfo;
			var len:int = _data.readShort();
			for(var i:int = 0;i < len;i++)
			{
				tmpInfo = new ShenMoWarMembersItemInfo();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.userId = _data.readNumber();
				tmpInfo.isOnline = _data.readByte();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.camp = _data.readByte();
				tmpInfo.level = _data.readByte();
				tmpInfo.clubName = _data.readString();
				tmpInfo.attackPepNum = _data.readShort();
				tmpInfo.careerId = _data.readByte();
				tmpInfo.awardState = _data.readByte();
				result.push(tmpInfo);
			}
			if(sceneModule.shenMoWarInfo.shenMoWarMembersInfo)
			{
				sceneModule.shenMoWarInfo.shenMoWarMembersInfo.dealList(result);
				sceneModule.shenMoWarInfo.shenMoWarMembersInfo.currentPepNum = sceneModule.shenMoWarInfo.shenMoWarMembersInfo.membersItemList.length;
				sceneModule.shenMoWarInfo.shenMoWarMembersInfo.allPepNum = _data.readShort();
				sceneModule.shenMoWarInfo.shenMoWarMembersInfo.update(result);
			}
			handComplete();
		}
		
		public static function send(argWarSceneId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SHENMO_MEMBERLIST_UPDATE);
			pkg.writeNumber(argWarSceneId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}