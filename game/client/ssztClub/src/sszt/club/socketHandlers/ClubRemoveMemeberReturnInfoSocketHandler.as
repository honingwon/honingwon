package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ClubRemoveMemeberReturnInfoSocketHandler extends BaseSocketHandler
	{
		public function ClubRemoveMemeberReturnInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_REMOVE_MEMBER_RETURN_INFO;
		}
		
		override public function handlePackage():void
		{
//			var userId:Number = _data.readNumber();
//			GlobalData.clubMemberInfo.removeMember(userId);
//			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule
		}
	}
}