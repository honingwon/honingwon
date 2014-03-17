package sszt.core.socketHandlers.skill
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PlayerDragSkillSocketHandler extends BaseSocketHandler
	{
		public function PlayerDragSkillSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_DRAG_SKILL;
		}
		
		/**
		 * 
		 * @param type 0为技能，1为道具
		 * @param id
		 * @param fromPlace拖入为-1
		 * @param toPlace拖出为-1
		 * 
		 */		
		public static function send(type:int,id:int,fromPlace:int = -1,toPlace:int = -1):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_DRAG_SKILL);
			pkg.writeByte(type);
			pkg.writeInt(id);
			pkg.writeShort(fromPlace);
			pkg.writeShort(toPlace);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}