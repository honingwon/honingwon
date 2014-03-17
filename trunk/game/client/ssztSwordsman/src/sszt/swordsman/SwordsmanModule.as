package sszt.swordsman
{
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToSwordsmanData;
	import sszt.core.module.BaseModule;
	import sszt.core.socketHandlers.swordsman.UserInfoSocketHandler;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.interfaces.module.IModule;
	import sszt.swordsman.components.SwordsmanPanel;
//	import sszt.swordsman.datas.TokenInfo;
	import sszt.swordsman.socketHandlers.SwordsmanSetSocketHandlers;
	import sszt.swordsman.socketHandlers.TokenPubliskListSocketHandler;

	public class SwordsmanModule extends BaseModule
	{
		public var swordsmanFacade:SwordsmanFacade;
		public var swordsmanPanel:SwordsmanPanel;
		public var toSwordsmanData:ToSwordsmanData;
		
		override public function assetsCompleteHandler():void
		{
			// TODO Auto Generated method stub
			if(swordsmanPanel)
			{
				swordsmanPanel.assetsCompleteHandler();
			}
		}
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			toSwordsmanData = data as ToSwordsmanData;
			TokenPubliskListSocketHandler.send();
			UserInfoSocketHandler.send();
			if(swordsmanPanel)
				swordsmanPanel.dispose();
			else
				swordsmanFacade.sendNotification(SwordsmanMediaEvents.TEMPLATE_MEDIATOR_START,toSwordsmanData);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			if(swordsmanPanel)
			{
				swordsmanPanel.dispose();
				swordsmanPanel = null;
			}
			super.dispose();
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.SWORDSMAN;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			toSwordsmanData = data as ToSwordsmanData;
			SwordsmanSetSocketHandlers.add(this);
			TokenPubliskListSocketHandler.send();
			UserInfoSocketHandler.send();
			swordsmanFacade = SwordsmanFacade.getInstance(moduleId.toString());
			swordsmanFacade.setup(this,toSwordsmanData);
		}
	}
}