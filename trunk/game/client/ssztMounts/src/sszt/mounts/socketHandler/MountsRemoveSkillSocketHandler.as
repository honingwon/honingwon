package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsRemoveSkillSocketHandler extends BaseSocketHandler
	{
		public function MountsRemoveSkillSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_REMOVE_SKILL;
		}
		
		public static function send(mountsId:Number,groupId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_REMOVE_SKILL);
			pkg.writeNumber(mountsId);
			pkg.writeInt(groupId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}