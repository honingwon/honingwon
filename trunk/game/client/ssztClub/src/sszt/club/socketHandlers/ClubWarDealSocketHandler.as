package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubWarDealSocketHandler extends BaseSocketHandler
	{
		public function ClubWarDealSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_WAR_DEAL;
		}
		
		override public function handlePackage():void
		{
//			var tmpListId:int = _data.readInt();
//			if(clubModule.clubInfo.clubWarInfo)
//			{
//				clubModule.clubInfo.clubWarInfo.deleteWarDealList(tmpListId);
//			}
			handComplete();
		}
		
		/**argType   0表示接受   1表示拒绝**/
		public static function sendDeal(argListId:Number,argType:int,page:int,pageSize:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_WAR_DEAL);
			pkg.writeNumber(argListId);
			pkg.writeByte(argType);
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