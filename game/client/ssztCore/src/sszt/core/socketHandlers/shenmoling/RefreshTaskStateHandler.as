package sszt.core.socketHandlers.shenmoling
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class RefreshTaskStateHandler extends BaseSocketHandler
	{
		public function RefreshTaskStateHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PP_SHENMO_REFRESH_STATE;
		}
		
		override public function handlePackage():void
		{
			var state:int = _data.readByte();
			switch(state)
			{
				case 0:
					QuickTips.show(LanguageManager.getWord("ssztl.core.shenMoLingRefreshSuccess1"));
					break;
				case 1:
					QuickTips.show(LanguageManager.getWord("ssztl.core.shenMoLingRefreshSuccess2"));
					break;
				case 2:
					QuickTips.show(LanguageManager.getWord("ssztl.core.shenMoLingRefreshSuccess3"));
					break;
				case 3:
					QuickTips.show(LanguageManager.getWord("ssztl.core.shenMoLingRefreshSuccess4"));
					break;
				case 4:
					QuickTips.show(LanguageManager.getWord("ssztl.core.shenMoLingRefreshSuccess5"));
					break;
			}
		}
		
		public static function sendRefreshState(shenMoLingId:Number, lingLongShiId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PP_SHENMO_REFRESH_STATE);
			pkg.writeNumber(shenMoLingId);
			pkg.writeNumber(lingLongShiId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}