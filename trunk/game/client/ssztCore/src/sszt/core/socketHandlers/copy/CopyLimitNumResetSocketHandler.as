package sszt.core.socketHandlers.copy
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CopyLimitNumResetSocketHandler extends BaseSocketHandler
	{
		public function CopyLimitNumResetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_LIMIT_NUM_RESET;
		}
		
		override public function handlePackage():void
		{
			var successful:Boolean = _data.readBoolean();
			var code:int = _data.readInt();
			if(successful)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.copyResetSuccessful'));
			}
			else
			{
				
			}
			handComplete();
		}
		
		public static function send(copyId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_LIMIT_NUM_RESET);
			pkg.writeInt(copyId);
			GlobalAPI.socketManager.send(pkg);
		}
		
	}
}