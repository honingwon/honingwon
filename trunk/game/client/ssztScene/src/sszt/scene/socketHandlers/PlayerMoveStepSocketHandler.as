package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PlayerMoveStepSocketHandler extends BaseSocketHandler
	{
		public function PlayerMoveStepSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_MOVE_STEP;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(x:int,y:int,index:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_MOVE_STEP);
			pkg.writeInt(x);
			pkg.writeInt(y);
			pkg.writeShort(index);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}