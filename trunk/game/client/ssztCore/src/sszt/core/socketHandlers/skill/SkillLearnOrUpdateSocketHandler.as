package sszt.core.socketHandlers.skill
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class SkillLearnOrUpdateSocketHandler extends BaseSocketHandler
	{
		public function SkillLearnOrUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SKILL_LEARNORUPDATE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SKILL_LEARNORUPDATE);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}