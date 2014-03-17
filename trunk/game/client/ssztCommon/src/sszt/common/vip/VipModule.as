package sszt.common.vip
{
	import flash.events.Event;
	
	import sszt.common.vip.component.VipPanel;
	import sszt.common.vip.component.pop.BuyVipPanel;
	import sszt.common.vip.data.VipPlayerList;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	
	public class VipModule extends BaseModule
	{
		public var vipPanel:VipPanel;
		public var controller:VipController;
		public var viperInfo:VipPlayerList;
		public var buyVipPanel:BuyVipPanel;
				
		override public function setup(prev:IModule,data:Object=null):void
		{
			super.setup(prev,data);
			viperInfo = new VipPlayerList();
			controller = new VipController(this);
			controller.startUp(data as ToVipData);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			
			if(data.type == 0)
			{
				controller.showVipPanel();
			}
			else if(data.type == 1)
			{
				controller.showBuyVipPanel();
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.VIP;
		}
		
		override public function dispose():void
		{
			if(vipPanel)
			{
				vipPanel.dispose();
				vipPanel = null;
			}
			if(controller)
			{
				controller.dispose();
				controller = null;
			}
			viperInfo = null;
			super.dispose()
		}
	}
}