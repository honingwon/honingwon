package sszt.core.socketHandlers.box
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class BoxChatInfoAddHandler extends BaseSocketHandler
	{
		public function BoxChatInfoAddHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SM_BOX_MSG_ADD;
		}
		
		override public function handlePackage():void
		{
//			var serverId:int = _data.readShort();
			var nickName:String = _data.readUTF();	
			var type:int = _data.readInt();
			var itemtempId:int = _data.readInt();
			GlobalData.boxMsgInfo.addMessage(0,nickName,type,itemtempId);
			handComplete();
		}
	}
}