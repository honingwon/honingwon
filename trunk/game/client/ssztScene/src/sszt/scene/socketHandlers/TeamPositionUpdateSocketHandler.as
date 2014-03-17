package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class TeamPositionUpdateSocketHandler extends BaseSocketHandler
	{
		public function TeamPositionUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_POSITION_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readByte();
			var i:int = 0;
			for(i;i<len;i++)
			{
				var id:Number = _data.readNumber();
				var mapID:int =_data.readInt();
				var x:int = _data.readShort();
				var y:int = _data.readShort();
				sceneModule.sceneInfo.teamData.updatePartnerPosition(id,mapID,x,y);
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}