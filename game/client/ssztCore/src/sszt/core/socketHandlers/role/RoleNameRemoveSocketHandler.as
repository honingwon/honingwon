package sszt.core.socketHandlers.role
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class RoleNameRemoveSocketHandler extends BaseSocketHandler
	{
		public function RoleNameRemoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ROLE_NAME_REMOVE;
		}
		
		override public function handlePackage():void
		{
			var len:int;
			GlobalData.selfPlayer.updateRoleTitle(_data.readInt(),_data.readBoolean());
			len = _data.readInt();
			for(var i:int = 0;i < len;i++)
			{
				GlobalData.titleInfo.removeTitle(_data.readInt());
			}
			
		}
	}
}