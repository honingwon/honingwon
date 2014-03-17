package sszt.core.socketHandlers.club
{
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubTransferSocketHandler extends BaseSocketHandler
	{
		public function ClubTransferSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_TRANSFER;
		}
		
		override public function handlePackage():void
		{
			var nick:String = _data.readString();
			var userId:Number = _data.readNumber();
			MAlert.show(nick + LanguageManager.getWord("ssztl.core.clubForYou"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					ClubTransferResponseSocketHandler.send(true,userId);
				}
				else
				{
					ClubTransferResponseSocketHandler.send(false,userId);
				}
			}
			
			handComplete();
		}
		
		public static function send(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_TRANSFER);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}