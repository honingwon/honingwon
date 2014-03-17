package sszt.box.socketHandlers
{
	import sszt.box.BoxModule;
	import sszt.box.data.ToBagType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.quickIcon.QuickIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MoveToBagSocketHandler extends BaseSocketHandler
	{
		public function MoveToBagSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				var type:int = _data.readInt();
				switch(type)
				{
					case ToBagType.SINGLE:
						var itemId:Number = _data.readNumber();
						boxModule.shenmoStoreInfo.removeItem(itemId);
						break;
					case ToBagType.ALL:
						boxModule.shenmoStoreInfo.removeAll();
						break;
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagSizeNotEnough"));
			}
			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.SM_REMOVE_STORE_ITEM;
		}
		
		public static function sendMoveToBag(type:int,itemId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SM_REMOVE_STORE_ITEM);
			pkg.writeInt(type);
			pkg.writeNumber(itemId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get boxModule():BoxModule
		{
			return _handlerData as BoxModule;
		}
	}
}