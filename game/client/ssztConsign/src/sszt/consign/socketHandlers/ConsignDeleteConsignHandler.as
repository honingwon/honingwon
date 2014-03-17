package sszt.consign.socketHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.consign.ConsignModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ConsignDeleteConsignHandler extends BaseSocketHandler
	{
		public function ConsignDeleteConsignHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.consign.cannelConsignSuccess") + _data.readString());
			}
			else
			{
				var message:String = _data.readString();
				QuickTips.show(message);
			}
			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_DELETE;
		}
		
		private function get consignModule():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
		
		public static function sendDelete(argListId:Number,argCurrentPage:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_DELETE);
			pkg.writeNumber(argListId);
			pkg.writeInt(argCurrentPage);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}