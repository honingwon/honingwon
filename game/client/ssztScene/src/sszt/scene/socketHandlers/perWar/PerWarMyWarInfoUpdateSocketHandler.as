package sszt.scene.socketHandlers.perWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.personalWar.myInfo.PerWarMyWarInfo;
	import sszt.scene.data.personalWar.myInfo.PerWarMyWarItemInfo;
	import sszt.scene.data.shenMoWar.myWarInfo.ShenMoWarMyWarItemInfo;
	
	public class PerWarMyWarInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function PerWarMyWarInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERWAR_MYWAR_INFO_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var tmpInfoAttackedList:Array = [];
			var tmpInfoBeAttackedList:Array = [];
			var tmpInfo:PerWarMyWarItemInfo;
			var attackedLen:int = _data.readShort();
			for(var i:int = 0;i < attackedLen;i++)
			{
				tmpInfo = new PerWarMyWarItemInfo();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.userId = _data.readNumber();
				_data.readByte();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.level = _data.readByte();
				tmpInfo.clubName = _data.readString();
				tmpInfo.score = _data.readInt();
				tmpInfo.killCount = _data.readShort();
				tmpInfo.careerId = _data.readByte();
				_data.readByte();
				tmpInfoAttackedList.push(tmpInfo);
			}
			var beAttackedLen:int = _data.readShort();
			for(var j:int= 0;j< beAttackedLen;j++)
			{
				tmpInfo = new PerWarMyWarItemInfo();
				tmpInfo.serverId = _data.readShort();
				tmpInfo.userId = _data.readNumber();
				_data.readByte();
				tmpInfo.playerNick = _data.readString();
				tmpInfo.level = _data.readByte();
				tmpInfo.clubName = _data.readString();
				tmpInfo.score = _data.readInt();
				tmpInfo.killCount = _data.readShort();
				tmpInfo.careerId = _data.readByte();
				_data.readByte();
				tmpInfoBeAttackedList.push(tmpInfo);
			}
			var tmpMyWarInfo:PerWarMyWarInfo = sceneModule.perWarInfo.perWarMyWarInfo;
			tmpMyWarInfo.attackInfoList = tmpInfoAttackedList;
			tmpMyWarInfo.beAttackedInfoList = tmpInfoBeAttackedList;
			tmpMyWarInfo.update();
			handComplete();
		}
		
		public static function send(argWarSceneId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERWAR_MYWAR_INFO_UPDATE);
			pkg.writeNumber(argWarSceneId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}