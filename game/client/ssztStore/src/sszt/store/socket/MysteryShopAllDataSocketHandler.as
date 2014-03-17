package sszt.store.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.box.BoxMessageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MysteryShopAllDataSocketHandler extends BaseSocketHandler
	{
		public function MysteryShopAllDataSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{	
			
			var lenth:int = _data.readInt();
			var msgList:Array = [];
			var msgList1:Array = [];
			var nickName:String;
			var item:int;
			var message:String;
			GlobalData.mysteryShopInfo.mysteryShopMsgInfo.clearBoxMsgInfo();
			for(var i:int=0;i<lenth;i++)
			{
				var serverId:int = 0; 
				nickName = _data.readUTF();
				item = _data.readInt();
				message = LanguageManager.getWord("ssztl.common.mysteryShopChatNotice",
					"{N"+nickName+"}","{I0-0-"+item+"-0}");
				msgList.push(message);
				msgList1.push({id:item,nickName:nickName});
			}
			
			GlobalData.mysteryShopInfo.mysteryShopMsgInfo.initMysteryShopMsgInfo(msgList,msgList1);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MYSTERY_SHOP_NEAR_MSG);
			GlobalAPI.socketManager.send(pkg);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MYSTERY_SHOP_NEAR_MSG;
		}
		
	}
}