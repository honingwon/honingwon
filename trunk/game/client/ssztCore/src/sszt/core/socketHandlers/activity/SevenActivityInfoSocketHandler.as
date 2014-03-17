package sszt.core.socketHandlers.activity
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.SevenActivityItemInfo;
	import sszt.core.data.activity.SevenActivityUserItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ActivityEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class SevenActivityInfoSocketHandler extends BaseSocketHandler
	{
		public function SevenActivityInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.ACTIVE_SEVEN;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			var sevenActivityItemInfo:SevenActivityItemInfo;
			var sevenActivityUserItemInfo:SevenActivityUserItemInfo;
			var gotState:int = _data.readInt();
			var length:int = _data.readByte();	
			
			for(var i:int=0;i<length;i++)
			{
				sevenActivityItemInfo = new SevenActivityItemInfo();
				sevenActivityItemInfo.id = _data.readByte();
				sevenActivityItemInfo.isEnd = _data.readBoolean();
				sevenActivityItemInfo.innerLen = _data.readByte();
				var userArray:Array = [];
				for(var j:int=0;j<sevenActivityItemInfo.innerLen;j++)
				{
					sevenActivityUserItemInfo = new SevenActivityUserItemInfo();
					sevenActivityUserItemInfo.userId = _data.readNumber();
					sevenActivityUserItemInfo.userNick = _data.readString();
					sevenActivityUserItemInfo.userNum = _data.readInt();
					sevenActivityUserItemInfo.isGet = _data.readBoolean();
					userArray.push(sevenActivityUserItemInfo);
				}
				sevenActivityItemInfo.userArray = userArray;
				GlobalData.sevenActInfo.activityDic[sevenActivityItemInfo.id] = sevenActivityItemInfo; 
				GlobalData.sevenActInfo.gotState = gotState;
			}
			
			ModuleEventDispatcher.dispatchModuleEvent(new ActivityEvent(ActivityEvent.SEVEN_ACTIVITY_INFO));
			
			handComplete();
		}
		
		/**
		 * 发送到服务端
		 */
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_SEVEN);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}