package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GetLoginDataSocketHandler extends BaseSocketHandler
	{
		public function GetLoginDataSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GETLOGINDATA;
		}
		
		public static function send(bag:int,mail:int,friend:int,task:int,group:int,enthral:int,skill:int,pet:int,skillBar:int,hangup:int,buff:int,title:int,gift:int,vip:int, veins:int,mounts:int,duplicateLottery:int,loginReward:int,active:int,target:int,openActi:int,activityList:int,mysteryGetLastDate:int,hasExchangeSilver:int,entrustment:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GETLOGINDATA);
			pkg.writeInt((entrustment<< 25)+(hasExchangeSilver << 24) + (mysteryGetLastDate << 23)  +(activityList << 22)  + (openActi << 21) + (target << 20) + (active << 19) + (loginReward << 18) + (duplicateLottery << 17) + (mounts << 16) + (bag << 15) + (mail << 14) + (friend << 13) + (task << 12) + (group << 11) + (enthral << 10) + 
				(skill << 9) + (skillBar << 8) + (pet << 7) + (hangup << 6) + (buff << 5) + (title << 4) + (gift << 3) + (vip<<2) + ( veins << 1));
			GlobalAPI.socketManager.send(pkg);
		}
	}
}