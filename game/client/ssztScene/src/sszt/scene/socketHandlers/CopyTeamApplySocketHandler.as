package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CopyTeamApplySocketHandler extends BaseSocketHandler
	{
		public function CopyTeamApplySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_TEAM_APPLY;
		}
		
		public static function send(id:Number,value:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_TEAM_APPLY);
			pkg.writeNumber(id);
			pkg.writeBoolean(value);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}