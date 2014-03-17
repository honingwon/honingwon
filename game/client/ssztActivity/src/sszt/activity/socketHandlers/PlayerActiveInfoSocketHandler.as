package sszt.activity.socketHandlers
{
	import sszt.activity.ActivityModule;
	import sszt.activity.data.ActivityInfo;
	import sszt.activity.data.itemViewInfo.ActiveItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PlayerActiveInfoSocketHandler extends BaseSocketHandler
	{
		public function PlayerActiveInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ACTIVE_INFO;
		}
		
		override public function handlePackage():void
		{
			var activityInfo:ActivityInfo = module.activityInfo;
			activityInfo.activeMyNum = _data.readShort();
			var len:int = _data.readByte();
			var temp:ActiveItemInfo;
			for(var i:int = 0; i < len; i++)
			{
				var id:int = _data.readByte();
				var activeNum:int = _data.readByte();
				temp = module.activityInfo.getActiveItem(id);
				if(temp)
				{
					temp.count = activeNum;		
				}
			}
			activityInfo.updateActiveData();
			handComplete();
		}
		
		private function get module():ActivityModule
		{
			return _handlerData as ActivityModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_ACTIVE_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}