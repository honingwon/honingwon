package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.cityCraft.CityCraftRankItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class CityCraftResultSocketHandler extends BaseSocketHandler
	{
		public function CityCraftResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var myPoint:int = _data.readShort();
			var myIndex:int = _data.readShort();
			var itemID:int  = _data.readInt();
			var len:int = _data.readShort();
			var i:int=0;
			var rank:CityCraftRankItemInfo;
			var rankList:Array = [];
			for(i;i<len;i++)
			{
				rank = new CityCraftRankItemInfo();
				rank.nick = _data.readUTF();
				rank.point = _data.readShort();
				rankList.push(rank);
			}
			
			GlobalData.cityCraftInfo.updateResultList(myPoint,myIndex,itemID,rankList);
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_RESULT;
		}		
	}
}