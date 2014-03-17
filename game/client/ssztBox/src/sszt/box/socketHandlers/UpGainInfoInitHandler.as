package sszt.box.socketHandlers
{
	import sszt.box.BoxModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.box.BoxMessageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class UpGainInfoInitHandler extends BaseSocketHandler
	{
		public function UpGainInfoInitHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{	
			
			var lenth:int = _data.readInt();
			var msgList:Array = [];
			var msgList1:Array = [];
			var nickName:String;
			var type:int;
			var item:int;
			var message:String;
			GlobalData.boxMsgInfo.clearBoxMsgInfo();
			for(var i:int=0;i<lenth;i++)
			{
				var serverId:int = 0;// _data.readShort();
				nickName = _data.readUTF();
				type = _data.readInt();
				item = _data.readInt();
				
				message = LanguageManager.getWord("ssztl.common.taoBaoChatNotice",
					"{N"+nickName+"}","{T"+type+"}","{I0-0-"+item+"-0}");
				msgList.push(message);
				msgList1.push({id:item,nickName:nickName});
			}
			
			GlobalData.boxMsgInfo.initBoxMsgInfo(msgList,msgList1);
			handComplete();
		}
		
		public static function sendInitInfo():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SM_NEAR_BOX_MSG);
			GlobalAPI.socketManager.send(pkg);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SM_NEAR_BOX_MSG;
		}
		
		public function get boxModule():BoxModule
		{
			return _handlerData as BoxModule;
		}
	}
}