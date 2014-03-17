package sszt.consign.socketHandlers
{
	import sszt.consign.ConsignModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ConsignContinueHandler extends BaseSocketHandler
	{
		public function ConsignContinueHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.consign.reConsignSuccess") + _data.readString());
			}
			else
			{
				QuickTips.show(_data.readString());
			}
			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_CONTINUE;
		}
		
		public static function sendContinueConsign(argListId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_CONTINUE);
			pkg.writeNumber(argListId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function getConsignModule():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
	}
}