package sszt.core.socketHandlers.store
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class MysteryShopChatInfoAddSocketHandler extends BaseSocketHandler
	{
		public function MysteryShopChatInfoAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MYSTERY_SHOP_MSG_ADD;
		}
		
		override public function handlePackage():void
		{
			var nickName:String = _data.readUTF();	
			var itemtempId:int = _data.readInt();
			GlobalData.mysteryShopInfo.mysteryShopMsgInfo.addMessage(0,nickName,itemtempId);
			handComplete();
		}
	}
}