package sszt.core.socketHandlers.vip
{
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.vip.VipExpirePanel;
	import sszt.core.view.vip.VipOneHourUsedPanel;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class PlayerVipDetailSocketHandler extends BaseSocketHandler
	{
		public function PlayerVipDetailSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_VIP_DETAIL;
		}
		
		override public function handlePackage():void
		{
			var isAlert:Boolean = _data.readBoolean();
			if(isAlert)
			{
				VipExpirePanel.getInstance().show();
			}
			var vipId:int = _data.readShort();
			var vipTime:int = _data.readInt();
			if(vipTime != 0)
			{
				var now:Date = GlobalData.systemDate.getSystemDate();
				vipTime = vipTime - now.getTime()/1000
			}
			var flyCount:int = _data.readInt();
			var bugle:int = _data.readInt();
			//绑定元宝
			var isVipBindYuanbaoGot:Boolean = _data.readBoolean();
			//铜币
			var  isVipCopperGot:Boolean = _data.readBoolean();
			//buff
			var isVipBuffGot:Boolean = _data.readBoolean();
			GlobalData.selfPlayer.updateVipInfo(vipId, vipTime, flyCount, bugle, isVipBindYuanbaoGot, isVipCopperGot, isVipBuffGot);
			
			if(VipType.OneHour == VipType.getVipType(vipId) && vipTime > 3500)
			{
				VipOneHourUsedPanel.getInstance().show();
			}
			
			if(VipType.OneHour == VipType.getVipType(vipId))
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.SHOW_ONE_HOUR_VIP_COUNTDOW, vipTime));
			}
			
			ModuleEventDispatcher.dispatchModuleEvent(new WelfareEvent(WelfareEvent.AWARD_GET_UPDATE));
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_VIP_DETAIL);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}