package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.FurnaceModule;
	import sszt.furnace.events.FuranceEvent;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceFuseSocketHandler extends BaseSocketHandler
	{
		public function FurnaceFuseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_FUSE;
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
		
		override public function handlePackage():void
		{
			//1是成功 0是失败
			var result:int = _data.readByte();
			if(result == 1)
			{
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.FUSE_SUCCESS,result));
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.fuseSuccess"));
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.fuseFail"));
			}
			//请空中间面板
			furnaceModule.furnaceInfo.clearMiddlePanel();
			handComplete();
		}
		
		public static function send(equip1Place:int, equip2Place:int,itemID:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_FUSE);
			pkg.writeInt(equip1Place);
			pkg.writeInt(equip2Place);
			pkg.writeInt(itemID);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}