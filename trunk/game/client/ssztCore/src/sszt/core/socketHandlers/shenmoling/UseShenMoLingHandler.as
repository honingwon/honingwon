package sszt.core.socketHandlers.shenmoling
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.shenmoling.ShenMoLingPanel;
	import sszt.interfaces.socket.IPackageOut;
	
	public class UseShenMoLingHandler extends BaseSocketHandler
	{
		public function UseShenMoLingHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SHENMOLING_ADD_TASK;
		}
		
		override public function handlePackage():void
		{
			var itemId:Number = _data.readNumber();
			var item:ItemInfo = GlobalData.bagInfo.getItemByItemId(itemId);
			
			var sPanel:ShenMoLingPanel = new ShenMoLingPanel(item);
			GlobalAPI.layerManager.addPanel(sPanel);
		}
		
		public static function sendShenMoLingTask(taskId:int,itemId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SHENMOLING_ADD_TASK);
			pkg.writeNumber(itemId);
			pkg.writeInt(taskId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}