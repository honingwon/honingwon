package sszt.stall.socketHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.data.stall.StallInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.stall.StallModule;
	
	public class StallOKSocketHandler extends BaseSocketHandler
	{
		public function StallOKSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				stallModule.stallPanel.dealPanel.stallSuccess();
			}
			else
			{
				MAlert.show("摆摊失败","提示");
			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_CREATE;
		}
		
		public static function sendStallOK(stallName:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.STALL_CREATE);
			pkg.writeString(stallName);
			pkg.writeInt(GlobalData.clientBagInfo.stallBegSaleVector.length);
			for each(var i:ItemInfo in GlobalData.clientBagInfo.stallBegSaleVector)
			{
				pkg.writeInt(i.place);
				pkg.writeInt(i.stallSellPrice);
			}
			pkg.writeInt(GlobalData.stallInfo.begBuyInfoVector.length);
			for each(var j:StallBuyCellInfo in GlobalData.stallInfo.begBuyInfoVector)
			{
				pkg.writeInt(j.templateId);
				pkg.writeInt(j.price);
				pkg.writeInt(j.num);
			}
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get stallModule():StallModule
		{
			return _handlerData as StallModule;
		}
	}
}