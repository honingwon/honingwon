/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-3 下午3:16:31 
 * 
 */ 
package sszt.core.socketHandlers.vip
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;

	public class VipCardUseSocketHandler extends BaseSocketHandler
	{
		public function VipCardUseSocketHandler()
		{
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_VIP_USE;
		}
		
		
		public static function send(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_VIP_USE);
			pkg.writeInt(place);
			GlobalAPI.socketManager.send(pkg);
		}
		
	}
}