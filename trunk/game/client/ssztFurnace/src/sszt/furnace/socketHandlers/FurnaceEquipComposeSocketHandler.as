package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceEquipComposeSocketHandler extends BaseSocketHandler
	{
		public function FurnaceEquipComposeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_EQUIP_COMPOSE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipComposeSuccess"));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipComposeFail"));
			}
			
			handComplete();
		}
		
		public static function sendEquipCompose(argBlueEquipPlace:int,argPurpleEquipPlace1:int,argPurpleEquipPlace2:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_EQUIP_COMPOSE);
			pkg.writeInt(argBlueEquipPlace);
			pkg.writeInt(argPurpleEquipPlace1);
			pkg.writeInt(argPurpleEquipPlace2);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}