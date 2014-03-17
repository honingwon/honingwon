package sszt.core.socketHandlers.marriage
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.marriage.WeddingInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WeddingInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function WeddingInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MARRY_HALL_INFO;
		}
		
		override public function handlePackage():void
		{
			GlobalData.weddingInfo.bridegroomId = _data.readNumber();
			GlobalData.weddingInfo.brideId = _data.readNumber();
			
			var beginTime:Number = _data.readInt();
			
			var code:int = _data.readShort();
			if(code == 2)
			{
				GlobalData.weddingInfo.inCeremony = true;
			}
			
			GlobalData.weddingInfo.freeNum = _data.readShort();
			
			GlobalData.weddingInfo.bridegroom = _data.readUTF();
			GlobalData.weddingInfo.bride = _data.readUTF();
			
			var nowTime:Number = GlobalData.systemDate.getSystemDate().getTime()/1000;
			var pastSeconds:Number =nowTime - beginTime; 
			if(pastSeconds < 0) pastSeconds = 0;
			var secondsLeft:Number;
			if(!GlobalData.weddingInfo.inCeremony)
			{
				secondsLeft = 20 * 60 - pastSeconds;
			}
			else
			{
				secondsLeft = 2 * 60 + 15 - pastSeconds;
			}
			if(secondsLeft < 0) secondsLeft = 0;
			GlobalData.weddingInfo.seconds = secondsLeft;
			
			if(!GlobalData.weddingInfo.isInit){
				GlobalData.weddingInfo.isInit = true;
			}
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MARRY_HALL_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}