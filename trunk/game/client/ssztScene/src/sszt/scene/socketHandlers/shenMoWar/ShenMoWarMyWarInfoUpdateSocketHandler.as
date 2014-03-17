package sszt.scene.socketHandlers.shenMoWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.shenMoWar.myWarInfo.ShenMoWarMyWarItemInfo;
	
	public class ShenMoWarMyWarInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function ShenMoWarMyWarInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SHENMO_MYWAR_INFO_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var tmpInfoAttackedList:Array = [];
			var tmpInfoBeAttackedList:Array = [];
			var tmpInfo:ShenMoWarMyWarItemInfo;
			var attackedLen:int = _data.readShort();
			for(var i:int = 0;i < attackedLen;i++)
			{
				tmpInfo = new ShenMoWarMyWarItemInfo();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.userId = _data.readNumber();
				_data.readByte();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.warState = _data.readByte();
				tmpInfo.level = _data.readByte();
				tmpInfo.clubName = _data.readString();
				tmpInfo.killCount = _data.readShort();
				tmpInfo.careerId = _data.readByte();
				_data.readByte();
				tmpInfoAttackedList.push(tmpInfo);
			}
			var beAttackedLen:int = _data.readShort();
			for(var j:int= 0;j< beAttackedLen;j++)
			{
				tmpInfo = new ShenMoWarMyWarItemInfo();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.userId = _data.readNumber();
				_data.readByte();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.warState = _data.readByte();
				tmpInfo.level = _data.readByte();
				tmpInfo.clubName = _data.readString();
				tmpInfo.killCount = _data.readShort();
				tmpInfo.careerId = _data.readByte();
				_data.readByte();
				tmpInfoBeAttackedList.push(tmpInfo);
			}
			sceneModule.shenMoWarInfo.shenMoWarMyWarInfo.attackInfoList = tmpInfoAttackedList;
			sceneModule.shenMoWarInfo.shenMoWarMyWarInfo.beAttackedInfoList = tmpInfoBeAttackedList;
			sceneModule.shenMoWarInfo.shenMoWarMyWarInfo.update();
			handComplete();
		}
		
		public static function send(argWarSceneId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SHENMO_MYWAR_INFO_UPDATE);
			pkg.writeNumber(argWarSceneId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}