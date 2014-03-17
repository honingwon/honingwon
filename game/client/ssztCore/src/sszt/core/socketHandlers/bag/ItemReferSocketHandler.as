package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ItemReferSocketHandler extends BaseSocketHandler
	{
		public function ItemReferSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_REFER;
		}
		
		override public function handlePackage():void
		{
			var item:ItemInfo = new ItemInfo();
			PackageUtil.readItem(item,_data);
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.LOAD_ITEMINFO_COMPLETE,item));
			
			handComplete();
		}
		
		public static function send(userId:Number,itemId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_REFER);
			pkg.writeNumber(userId);
			pkg.writeNumber(itemId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}