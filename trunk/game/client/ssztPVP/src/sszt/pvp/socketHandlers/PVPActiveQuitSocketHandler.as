package sszt.pvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.pvp.PVPModule;
	import sszt.pvp.events.PVPEvent;
	
	public class PVPActiveQuitSocketHandler extends BaseSocketHandler
	{
		public function PVPActiveQuitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{			
			return ProtocolType.PVP_ACTIVE_QUIT;
		}
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			var activeId:int = _data.readInt();
			var state:int = _data.readInt();
			if(state == 1)
			{
				//trace("join pvp success!");
				pvpModule.pvp1Panel.dispatchEvent(new PVPEvent(PVPEvent.PVP_QUIT));
			}
			else 
			{
				trace("join pvp file");
			}
			GlobalData.pvpInfo.user_pvp_state = 0;
			handComplete();
		}
		/**
		 * 发送到服务端
		 * @param tempId
		 */
		public static function send(activeId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PVP_ACTIVE_QUIT);
			pkg.writeInt(activeId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get pvpModule():PVPModule
		{
			return _handlerData as PVPModule;
		}
	}
}