package sszt.scene.socketHandlers.bank
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BankGetSocketHandler extends BaseSocketHandler
	{
		public function BankGetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var state:int  = _data.readByte();
			if(state==0)
			{
				QuickTips.show("领取失败");
			}
			if(state==1)
			{
				QuickTips.show("领取成功");
			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.BANK_GET;
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BANK_GET);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}