package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreDealItemRequestSocketHandler extends BaseSocketHandler
	{
		public function ClubStoreDealItemRequestSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_CHECK;
		}
		
		override public function handlePackage():void
		{
			//与服务器端约定：如果有数据包返回，那么一定表示操作成功
			trace('拒绝或同意操作成功');
			ClubStoreExamineAndVerifySocketHandler.send(1);
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(recordId:Number, type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_CHECK);
			pkg.writeNumber(recordId);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}