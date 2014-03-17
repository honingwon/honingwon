package sszt.welfare.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.welfare.WelfareModule;
	
	public class LoginRewardExchangeSocketHandler extends BaseSocketHandler
	{
		public function LoginRewardExchangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WELFARE_EXCHANGE;
		}
		
		override public function handlePackage():void
		{
			var obj:Object = {};
			obj.type = _data.readShort(); //1:单人,2:多人副本 ,3:离线 获得经验  
			if(obj.type == 1)
			{
				welfareModule.welfarePanel.duplicateExpRewardView.getSingleDuplicateSuccess();
			}
			
			if(obj.type == 2)
			{
				welfareModule.welfarePanel.duplicateExpRewardView.getMutiDuplicateSuccess();
			}
			
			if(obj.type == 3)
			{
				obj.type1 = _data.readShort(); //1：(免费)单倍，2：(铜币)双倍，3：(元宝)三倍
				obj.num = _data.readInt();
				ModuleEventDispatcher.dispatchModuleEvent(new WelfareEvent(WelfareEvent.EXCHANGE_EXP,obj));
			}
			ModuleEventDispatcher.dispatchModuleEvent(new WelfareEvent(WelfareEvent.AWARD_GET_UPDATE));
		}
		
		/**
		 *  
		 * @param type 1:单人,2:多人副本 ,3:离线 获得经验 
		 * @param ExchangeType 1：免费单倍 ，2：铜币双倍，3：元宝三倍
		 *  @param hourNum 小时
		 */
		public static function send(type:int,ExchangeType:int,hourNum:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WELFARE_EXCHANGE);
			pkg.writeInt(type);
			pkg.writeInt(ExchangeType);
			pkg.writeInt(hourNum);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get welfareModule():WelfareModule
		{
			return _handlerData as WelfareModule;
		}
	}
}