package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.ui.container.MAlert;
	
	public class WeddingPresentGiftSocketHandler extends BaseSocketHandler
	{
		public function WeddingPresentGiftSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WEDDING_GIVE_GIFT;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			if(success)
			{
				MAlert.show('操作成功');
			}
			handComplete();
		}
		
		public static function send(userId:Number, type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WEDDING_GIVE_GIFT);
			pkg.writeShort(type);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}