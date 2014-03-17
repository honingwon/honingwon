package sszt.core.socketHandlers.openActivity
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.YellowBoxEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class YellowBoxGetRewardSocketHandler extends BaseSocketHandler
	{
		public function YellowBoxGetRewardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.PLAYER_YELLOW_GET_REWARD;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var reBoole:Boolean = _data.readBoolean();
			var type:int = _data.readByte();
			if(reBoole)
			{
				ModuleEventDispatcher.dispatchModuleEvent(new YellowBoxEvent(YellowBoxEvent.GET_AWARD,{type:type}));
			}
			
			handComplete();
		}
		
		/**
		 * 发送到服务端
		 * @param type 当前选择的活动类型  0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包
		 */
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_YELLOW_GET_REWARD);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}