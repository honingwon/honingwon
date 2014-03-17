package sszt.core.socketHandlers.vip
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.vip.VipAwardType;
	import sszt.core.data.vip.VipTemplateInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class PlayerVipAwardSocketHandler extends BaseSocketHandler
	{
		public function PlayerVipAwardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_VIP_AWARD;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			if(success)
			{
				var vip:VipTemplateInfo = VipTemplateList.getVipTemplateInfo(GlobalData.selfPlayer.getVipType());
				var vipAwardType:int = _data.readByte();
				switch(vipAwardType)
				{
					case VipAwardType.BIND_YUANBAO : 
						GlobalData.selfPlayer.updateVipAwardYuanbaoState(true);
						QuickTips.show(LanguageManager.getWord('ssztl.vip.getAwardYuanbaoSuccess', vip.yuanBao));
						break;
					case VipAwardType.COPPER : 
						GlobalData.selfPlayer.updateVipAwardCopperState(true);
						QuickTips.show(LanguageManager.getWord('ssztl.vip.getAwardCopperSuccess', vip.money));
						break;
					case VipAwardType.BUFF : 
						GlobalData.selfPlayer.updateVipAwardBuffState(true);
						QuickTips.show(LanguageManager.getWord('ssztl.vip.getAwardBuffSuccess', vip.name));
						break;
				}
				ModuleEventDispatcher.dispatchModuleEvent(new WelfareEvent(WelfareEvent.AWARD_GET_UPDATE));
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.getFail"));
			}
			handComplete();
		}
		
		public static function send(vipAwardType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_VIP_AWARD);
			pkg.writeByte(vipAwardType);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}