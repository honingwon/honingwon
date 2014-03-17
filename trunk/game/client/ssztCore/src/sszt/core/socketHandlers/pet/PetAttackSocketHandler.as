/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-12-27 下午7:33:03 
 * 
 */ 
package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;

	public class PetAttackSocketHandler extends BaseSocketHandler
	{
		
		public function PetAttackSocketHandler(handlerData:Object = null)
		{
			super(handlerData);
		} 
		
		override public function getCode() : int
		{
			return ProtocolType.PET_ATTACK;
		} 
		
		public static function sendAttack(targetId:Number, targetType:int, attackType:int, targetX:int = 0, targetY:int = 0) : void
		{
			if (!GlobalData.petList.getFightPet())
			{
				return;
			}
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_ATTACK);
			pkg.writeNumber(targetId);
			pkg.writeByte(targetType);
			pkg.writeInt(attackType);
			pkg.writeInt(targetX);
			pkg.writeInt(targetY);
			GlobalAPI.socketManager.send(pkg);
		} 
		
	}
}