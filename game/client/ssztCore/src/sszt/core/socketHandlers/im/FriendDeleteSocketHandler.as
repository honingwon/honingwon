package sszt.core.socketHandlers.im
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.im.GroupType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.im.ImPlayerList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FriendDeleteSocketHandler extends BaseSocketHandler
	{
		public function FriendDeleteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_DELETE;
		}
			
		public static function sendDelete(id:Number,type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.FRIEND_DELETE);
			pkg.writeNumber(id);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}