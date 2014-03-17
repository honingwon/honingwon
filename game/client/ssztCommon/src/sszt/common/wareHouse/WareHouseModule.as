package sszt.common.wareHouse
{
	import sszt.common.wareHouse.component.WareHousePanel;
	import sszt.common.wareHouse.data.WareHouseInfo;
	import sszt.common.wareHouse.socket.WareHouseSetSocket;
	import sszt.common.wareHouse.socket.WareHouseUpdateSocketHandler;
	import sszt.constData.CommonBagType;
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	
	public class WareHouseModule extends BaseModule
	{
		public var warehousePanel:WareHousePanel;
		public var controller:WareHouseController;
		public var wareHouseInfo:WareHouseInfo;
				
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			wareHouseInfo = new WareHouseInfo();
			WareHouseSetSocket.add(this);
			controller = new WareHouseController(this);
			controller.startup(data);
			WareHouseUpdateSocketHandler.sendFetch(CommonBagType.WAREHOUSE);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.WAREHOUSE;
		}
		
		override public function dispose():void
		{
			WareHouseSetSocket.remove();
			if(warehousePanel)
			{
				warehousePanel.dispose();
				warehousePanel = null;
			}
			if(controller)
			{
				controller.dispose();
				controller = null;
			}
			wareHouseInfo = null;
			super.dispose();
		}
			
	}
}