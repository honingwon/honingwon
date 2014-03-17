package sszt.welfare
{
	import sszt.core.data.itemDiscount.CheapInfo;
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.loginWelfare.LoginRewardUpdateSocketHandler;
	import sszt.interfaces.module.IModule;
	import sszt.welfare.component.WelfarePanel;
	import sszt.welfare.socket.WelfareSetSocketHandler;
	
	public class WelfareModule extends BaseModule
	{
		public var welfarePanel:WelfarePanel;
		public var cheapInfo:CheapInfo;
		public var facade:WelfareFacade;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(welfarePanel)
			{
				welfarePanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			if(welfarePanel)
			{
				welfarePanel.dispose();
			}
//			WelfareSetSocketHandler.add(this);
//			LoginRewardUpdateSocketHandler.send();
//			facade.sendNotification(WelfareMediatorEvent.INIT);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			WelfareSetSocketHandler.remove();
			if(welfarePanel)
			{
				welfarePanel.dispose();
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			super.dispose();
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.LOGINREWARD;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data); 
			cheapInfo = new CheapInfo();
			WelfareSetSocketHandler.add(this);
			LoginRewardUpdateSocketHandler.send();
			facade = WelfareFacade.getInstance(String(moduleId));
			facade.startup(this,data);
//			configure(data);
		}
	}
}