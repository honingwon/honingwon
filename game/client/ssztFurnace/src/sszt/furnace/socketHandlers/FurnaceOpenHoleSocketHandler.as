package sszt.furnace.socketHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.FurnaceModule;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceOpenHoleSocketHandler extends BaseSocketHandler
	{
		public function FurnaceOpenHoleSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId:Number = _data.readNumber();
			if(result)
			{
//				QuickTips.show("恭喜！！！开孔成功！");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.stilettoSuccess"));
			}
			else
			{
//				QuickTips.show("开孔失败!!");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.stilettoFail"));
			}
			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId);
			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_TAP;
		}
		
		public static function addOpenHole(argEquipPlace:int,argStonePlace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_TAP);
			pkg.writeInt(argEquipPlace);
			pkg.writeInt(argStonePlace);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}