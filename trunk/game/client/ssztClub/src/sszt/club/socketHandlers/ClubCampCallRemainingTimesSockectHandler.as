package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.camp.ClubCampInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubCampCallRemainingTimesSockectHandler extends BaseSocketHandler
	{
		public function ClubCampCallRemainingTimesSockectHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var bossRemainingTimes:int = ClubCampInfo.BOSS_REMAINING_TIMES_MAX -_data.readShort();
			var collectionRemainingTimes:int = ClubCampInfo.COLLECTION_REMAINING_TIMES_MAX - _data.readShort();
			var time:int = _data.readInt();
			clubModule.clubCampInfo.updateRemainingTimes(bossRemainingTimes,collectionRemainingTimes,time);
			handComplete();
		}
		
		public function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_SUMMON_REMAINING_TIMES;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_SUMMON_REMAINING_TIMES);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}