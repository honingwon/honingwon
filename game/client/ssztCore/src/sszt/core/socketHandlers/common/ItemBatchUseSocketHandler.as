/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-5-31 下午2:38:45 
 * 
 */ 
package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;

	public class ItemBatchUseSocketHandler extends BaseSocketHandler
	{
		public function ItemBatchUseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode() : int
		{
			return ProtocolType.ITEM_BATCH_USE;
		}
		
		public static function send(place:int,count:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_BATCH_USE);
			pkg.writeInt(place);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
		
	}
}