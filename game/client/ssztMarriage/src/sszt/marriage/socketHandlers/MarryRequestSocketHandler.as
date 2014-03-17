package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.ui.container.MAlert;
	
	public class MarryRequestSocketHandler extends BaseSocketHandler
	{
		public function MarryRequestSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MARRY_REQUEST;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			if(success)
			{
				MAlert.show('求婚请求已发送');
			}
			handComplete();
		}
		
		public static function send(targetPlayerId:Number, weddingType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MARRY_REQUEST);
			pkg.writeNumber(targetPlayerId);
			pkg.writeShort(weddingType);
			GlobalAPI.socketManager.send(pkg);
		}
		
	}
}