package sszt.scene.socketHandlers.bank
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BankBuySocketHandler extends BaseSocketHandler
	{
		public function BankBuySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var state:int  = _data.readByte();
			if(state==1)
			{
				QuickTips.show("购买成功");
			}		
			handComplete();			
		}
		
		override public function getCode():int
		{
			return ProtocolType.BANK_BUY;
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BANK_BUY);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}