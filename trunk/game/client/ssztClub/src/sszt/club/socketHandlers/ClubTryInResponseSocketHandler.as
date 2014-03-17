package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubTryInResponseSocketHandler extends BaseSocketHandler
	{
		public function ClubTryInResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_TRYINRESPONSE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		/**
		 * 
		 * @param id
		 * @param result true:答应，false：拒绝
		 * 
		 */		
		public static function send(id:Number,result:Boolean,page:int,pageSize:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_TRYINRESPONSE);
			pkg.writeNumber(id);
			pkg.writeBoolean(result);
			pkg.writeByte(page);
			pkg.writeByte(pageSize);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}