package sszt.stall.socketHandlers
{
	import fl.events.DataChangeEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.stall.StallDealItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class StallDealUpdateSocketHandler extends BaseSocketHandler
	{
		public function StallDealUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_LOG;
		}
		
		override public function handlePackage():void
		{
			var tmpUserId:Number = _data.readNumber();
			var tmpUserNick:String = _data.readString();
			var tmpDealTime:Date = _data.readDate();
			var tmpTag:int = _data.readInt();
			var len:int = _data.readInt();
			var tmpDealItemInfo:StallDealItemInfo;
			for(var i:int = 0;i < len;i++)
			{
				tmpDealItemInfo = new StallDealItemInfo();
				tmpDealItemInfo.userId = tmpUserId;
				tmpDealItemInfo.nick = tmpUserNick;
				tmpDealItemInfo.dealTime = tmpDealTime;
				tmpDealItemInfo.isBuyOrSaleTag = tmpTag;
				tmpDealItemInfo.itemName = _data.readString();
				tmpDealItemInfo.itemCount = _data.readInt();
				GlobalData.stallInfo.addToDealItemVector(tmpDealItemInfo);
			}
			
			handComplete();
		}
		
	}
}