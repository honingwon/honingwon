package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class CopyTeamApplyNoticeSocketHandler extends BaseSocketHandler
	{
		public function CopyTeamApplyNoticeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_TEAM_APPLY_NOTICE;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();                   //副本id
			GlobalData.copyEnterCountList.apply(id);
			handComplete();
		}
	}
}