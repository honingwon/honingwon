package sszt.stall.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.stall.StallMessageItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class StallMessageUpdateSocketHandler extends BaseSocketHandler
	{
		public function StallMessageUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_MESSAGE;
		}
		
		override public function handlePackage():void
		{
			var tmpMessageItemInfo:StallMessageItemInfo = new StallMessageItemInfo();;
			tmpMessageItemInfo.userId = _data.readNumber();
			tmpMessageItemInfo.nick = _data.readString();
			tmpMessageItemInfo.messageTime = _data.readDate();
			tmpMessageItemInfo.messageContent = _data.readString();
			GlobalData.stallInfo.addToMessageItemVector(tmpMessageItemInfo);
			handComplete();
		}
	}
}