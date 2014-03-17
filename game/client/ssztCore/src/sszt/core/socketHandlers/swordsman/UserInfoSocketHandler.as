package sszt.core.socketHandlers.swordsman
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	/**
	 * 看自己的江湖令任务 
	 * @author chendong
	 * 
	 */	
	public class UserInfoSocketHandler extends BaseSocketHandler
	{
		public function UserInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TOKEN_USER_INFO;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var rn:int = _data.readShort(); //已领取江湖令个数
			var i:int = 0;
			var list:Array = [];
			for(;i<rn;i++)
			{
				list.push(_data.readShort());
			}
			GlobalData.tokenInfo.updateAcceptArray(list);
			
			i = 0;
			list = [];
			var pn:int = _data.readShort(); //已发布江湖令个数
			for(;i<pn;i++)
			{
				list.push(_data.readShort());
			}
			GlobalData.tokenInfo.updatePublishArray(list);
			
			list = [];                    //发布且被领取
			list.push(_data.readShort());
			list.push(_data.readShort());
			list.push(_data.readShort());
			list.push(_data.readShort());
			GlobalData.tokenInfo.updateTokenPublishArray(list);
		}
		
//		public function get swordsmanModule():SwordsmanModule
//		{
//			return _handlerData as SwordsmanModule;
//		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TOKEN_USER_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}