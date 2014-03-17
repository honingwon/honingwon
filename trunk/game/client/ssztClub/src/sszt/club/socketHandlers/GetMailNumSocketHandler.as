package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.ClubInfo;
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	/**
	 * 
	 * 获取帮会邮件群发次数
	 * 
	 */	
	public class GetMailNumSocketHandler extends BaseSocketHandler
	{
		public function GetMailNumSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GET_MAIL_GUILD_NUM;
		}
		
		override public function handlePackage():void
		{
			var total:int = _data.readByte()
			var num:int = _data.readByte()
				
			if(clubModule.clubInfo.clubDetailInfo)
			{
				var info:ClubDetailInfo = clubModule.clubInfo.clubDetailInfo;
				info.mailTadayNum = num;
				info.mailTotalNum = total;
				info.update();
			}
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GET_MAIL_GUILD_NUM);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}