package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ClubEnemyListUpdateHandler extends BaseSocketHandler
	{
		public function ClubEnemyListUpdateHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_WAR_ENEMY_LIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var tmpList:Array = [];
			for(var i:int = 0;i < len;i++)
			{
				tmpList.push(_data.readNumber());
			}
			GlobalData.selfPlayer.updateClubEnemyList(tmpList);
			handComplete();
		}
	}
}