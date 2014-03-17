package sszt.core.socketHandlers.gm
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GMSendMessageSocketHandler extends BaseSocketHandler
	{
		public function GMSendMessageSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GM_SEND_MESSAGE;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.submitToGM"));
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.msgSendFail"));
			}
			
			handComplete();
		}
		
		public static function sendMessage(type:int,title:String,content:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GM_SEND_MESSAGE);
			pkg.writeInt(type);
			pkg.writeString(title);
			pkg.writeString(content);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}