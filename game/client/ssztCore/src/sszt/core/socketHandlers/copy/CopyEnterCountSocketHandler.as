package sszt.core.socketHandlers.copy
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CopyEnterCountSocketHandler extends BaseSocketHandler
	{
		public function CopyEnterCountSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ENTER_COUNT;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var ids:Array = [];
			var counts:Array = [];
			var resetCostTimeArr:Array = [];
			for(var i:int = 0;i<len;i++)
			{
				ids[i] = _data.readInt();
				counts[i] = _data.readInt();
				//用了多少次
				resetCostTimeArr[i] = _data.readInt();
			}
			GlobalData.copyEnterCountList.setData(ids,counts);
			GlobalData.copyEnterCountList.setResetCostTimeData(ids,resetCostTimeArr);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ENTER_COUNT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}