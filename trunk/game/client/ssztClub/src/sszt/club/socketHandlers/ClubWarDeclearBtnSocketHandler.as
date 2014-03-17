package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubWarDeclearBtnSocketHandler extends BaseSocketHandler
	{
		public function ClubWarDeclearBtnSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_WAR_DECLEAR;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		/**argType 0表示宣战  1表示强制**/
		public static function sendDeclear(argListId:Number,argType:int,page:int,pageSize:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_WAR_DECLEAR);
			pkg.writeNumber(argListId);
			pkg.writeByte(argType);
			pkg.writeShort(page);
			pkg.writeByte(pageSize);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}