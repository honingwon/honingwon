package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubWarEnemyStopSocketHandler extends BaseSocketHandler
	{
		public function ClubWarEnemyStopSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_WAR_STOP;
		}
		
		override public function handlePackage():void
		{
//			var tmpListId:int = _data.readInt();
//			if(clubModule.clubInfo.clubWarInfo)
//			{
//				clubModule.clubInfo.clubWarInfo.deleteWarEnemyList(tmpListId);
//			}
			handComplete();
		}
		
		public static function sendStop(argListId:Number,page:int,pageSize:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_WAR_STOP);
			pkg.writeNumber(argListId);
			pkg.writeShort(page);
			pkg.writeByte(pageSize);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
	}
}